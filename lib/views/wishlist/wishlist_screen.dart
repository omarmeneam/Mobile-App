import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../theme/app_colors.dart';
import '../../viewmodels/wishlist_viewmodel.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final int _currentIndex = 3;

  @override
  void initState() {
    super.initState();
    // Load wishlist items when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WishlistViewModel>(context, listen: false).loadWishlist();
    });
  }

  void _onNavBarTap(int index) {
    if (index == _currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/search');
        break;
      case 2:
        Navigator.pushNamed(context, '/create-listing');
        break;
      case 3:
        // Already on wishlist
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WishlistViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('Wishlist')),
          body: viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : viewModel.error.isNotEmpty
                  ? Center(child: Text(viewModel.error))
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Saved Items (${viewModel.wishlistItems.length})',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),

                          Expanded(
                            child: viewModel.wishlistItems.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.favorite_border,
                                          size: 64,
                                          color: Colors.grey[400],
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'Your wishlist is empty',
                                          style: TextStyle(color: Colors.grey[600]),
                                        ),
                                        const SizedBox(height: 16),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pushReplacementNamed(
                                              context,
                                              '/home',
                                            );
                                          },
                                          child: const Text('Browse Items'),
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: viewModel.wishlistItems.length,
                                    itemBuilder: (context, index) {
                                      final item = viewModel.wishlistItems[index];
                                      return Card(
                                        margin: const EdgeInsets.only(bottom: 16),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              '/product/${item.id}',
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              // Product Image
                                              SizedBox(
                                                width: 100,
                                                height: 100,
                                                child: Image.asset(
                                                  item.image,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),

                                              // Product Details
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(12.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        item.title,
                                                        style:
                                                            Theme.of(
                                                              context,
                                                            ).textTheme.titleMedium,
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        'RM ${item.price.toStringAsFixed(2)}',
                                                        style:
                                                            Theme.of(
                                                              context,
                                                            ).textTheme.titleLarge,
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Row(
                                                        children: [
                                                          Chip(
                                                            label: Text(
                                                              item.category,
                                                              style:
                                                                  Theme.of(
                                                                    context,
                                                                  ).textTheme.bodySmall,
                                                            ),
                                                            backgroundColor: AppColors
                                                                .secondary
                                                                .withOpacity(0.2),
                                                          ),
                                                          const SizedBox(width: 8),
                                                          if (item.seller != null)
                                                            Row(
                                                              children: [
                                                                CircleAvatar(
                                                                  radius: 12,
                                                                  backgroundImage:
                                                                      AssetImage(
                                                                          item.seller!.avatar),
                                                                ),
                                                                const SizedBox(width: 4),
                                                                Text(
                                                                  item.seller!.name,
                                                                  style:
                                                                      Theme.of(context)
                                                                          .textTheme
                                                                          .bodySmall,
                                                                ),
                                                              ],
                                                            ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                              // Remove Button
                                              IconButton(
                                                icon: const Icon(Icons.favorite, color: Colors.red),
                                                onPressed: () async {
                                                  final success = await viewModel.removeFromWishlist(item.id);
                                                  if (success) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(
                                                        content: Text('Removed from wishlist'),
                                                        duration: Duration(seconds: 2),
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
          bottomNavigationBar: BottomNavBar(
            currentIndex: _currentIndex,
            onTap: _onNavBarTap,
          ),
        );
      },
    );
  }
}
