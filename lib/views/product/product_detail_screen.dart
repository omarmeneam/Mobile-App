import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../viewmodels/product_viewmodel.dart';
import '../../viewmodels/wishlist_viewmodel.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    // Fetch product details when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductViewModel>(
        context,
        listen: false,
      ).loadProduct(widget.productId);
    });
  }

  void _toggleWishlist() async {
    final productViewModel = Provider.of<ProductViewModel>(
      context,
      listen: false,
    );
    final wishlistViewModel = Provider.of<WishlistViewModel>(
      context,
      listen: false,
    );

    if (productViewModel.product != null) {
      final product = productViewModel.product!;
      final isInWishlist = wishlistViewModel.isInWishlist(product.id);

      final success =
          isInWishlist
              ? await wishlistViewModel.removeFromWishlist(product.id)
              : await wishlistViewModel.addToWishlist(product);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isInWishlist ? 'Removed from wishlist' : 'Added to wishlist',
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _shareProduct() async {
    final productViewModel = Provider.of<ProductViewModel>(
      context,
      listen: false,
    );
    final success = await productViewModel.shareProduct();

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product shared successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _reportListing() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Report Listing'),
            content: const Text(
              'Are you sure you want to report this listing?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Listing reported'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Report'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ProductViewModel, WishlistViewModel>(
      builder: (context, productViewModel, wishlistViewModel, child) {
        if (productViewModel.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (productViewModel.error.isNotEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(child: Text(productViewModel.error)),
          );
        }

        if (productViewModel.product == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Product Not Found')),
            body: const Center(
              child: Text('The requested product could not be found'),
            ),
          );
        }

        final product = productViewModel.product!;
        final isInWishlist = wishlistViewModel.isInWishlist(product.id);

        // Mock image list
        final List<String> images = [
          product.image,
          product.image, // Using same image as placeholder for multiple views
          product.image,
        ];

        return Scaffold(
          appBar: AppBar(
            title: const Text('Product Details'),
            actions: [
              IconButton(
                icon: Icon(
                  isInWishlist ? Icons.favorite : Icons.favorite_border,
                  color: isInWishlist ? AppColors.primary : null,
                ),
                onPressed: _toggleWishlist,
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: _shareProduct,
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Images
                AspectRatio(
                  aspectRatio: 1,
                  child: PageView.builder(
                    itemCount: images.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Image.asset(images[index], fit: BoxFit.cover);
                    },
                  ),
                ),

                // Image Indicators
                if (images.length > 1)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        images.length,
                        (index) => Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                _currentImageIndex == index
                                    ? AppColors.primary
                                    : Colors.grey[300],
                          ),
                        ),
                      ),
                    ),
                  ),

                // Product Details
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and Price
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              product.title,
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ),
                          Text(
                            'RM ${product.price.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.displaySmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Category and Posted Date
                      Wrap(
                        spacing: 8,
                        children: [
                          Chip(
                            label: Text(product.category),
                            backgroundColor: AppColors.secondary.withOpacity(
                              0.2,
                            ),
                          ),
                          Text(
                            product.timeAgo,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Description
                      Text(
                        'Description',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 24),

                      // Seller Information
                      if (product.seller != null)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundImage: AssetImage(
                                        product.seller!.avatar,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                product.seller!.name,
                                                style:
                                                    Theme.of(
                                                      context,
                                                    ).textTheme.titleMedium,
                                              ),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.star,
                                                    size: 16,
                                                    color: Colors.amber,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    product.seller!.rating
                                                        .toString(),
                                                    style:
                                                        Theme.of(
                                                          context,
                                                        ).textTheme.bodySmall,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Text(
                                            'Member since ${product.seller!.joinedDate}',
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                            context,
                                            '/messages/${product.seller!.uid}',
                                          );
                                        },
                                        icon: const Icon(Icons.message),
                                        label: const Text('Message Seller'),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      onPressed: _reportListing,
                                      icon: const Icon(Icons.flag_outlined),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
