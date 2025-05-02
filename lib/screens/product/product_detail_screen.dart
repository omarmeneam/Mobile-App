import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/product.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Product _product;
  int _currentImageIndex = 0;
  bool _isInWishlist = false;

  @override
  void initState() {
    super.initState();
    // In a real app, you would fetch the product from an API or database
    _product = Product(
      id: widget.productId,
      title: 'Textbook - Introduction to Psychology',
      price: 45.0,
      description:
          'Excellent condition psychology textbook. 10th edition, hardcover. No highlights or notes. Perfect for PSY101. Selling because I\'ve completed the course.',
      image: 'assets/images/placeholder.png',
      category: 'Books',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      seller: Seller(
        id: 123,
        name: 'Alex Johnson',
        avatar: 'assets/images/placeholder.png',
        rating: 4.8,
        joinedDate: 'Sep 2023',
        online: true,
      ),
    );
  }

  void _toggleWishlist() {
    setState(() {
      _isInWishlist = !_isInWishlist;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isInWishlist ? 'Added to wishlist' : 'Removed from wishlist',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareProduct() {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sharing functionality would be implemented here'),
        duration: Duration(seconds: 2),
      ),
    );
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
    // Mock image list
    final List<String> images = [
      'assets/images/placeholder.png',
      'assets/images/placeholder.png',
      'assets/images/placeholder.png',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          IconButton(
            icon: Icon(
              _isInWishlist ? Icons.favorite : Icons.favorite_border,
              color: _isInWishlist ? AppColors.primary : null,
            ),
            onPressed: _toggleWishlist,
          ),
          IconButton(icon: const Icon(Icons.share), onPressed: _shareProduct),
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
                          _product.title,
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ),
                      Text(
                        'RM ${_product.price.toStringAsFixed(2)}',
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
                        label: Text(_product.category),
                        backgroundColor: AppColors.secondary.withOpacity(0.2),
                      ),
                      Text(
                        _product.timeAgo,
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
                    _product.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),

                  // Seller Information
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
                                  _product.seller!.avatar,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _product.seller!.name,
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
                                              _product.seller!.rating
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
                                      'Member since ${_product.seller!.joinedDate}',
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
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
                                      '/messages/${_product.seller!.id}',
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
  }
}
