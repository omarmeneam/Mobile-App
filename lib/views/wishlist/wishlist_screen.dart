import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../theme/app_colors.dart';
import '../../viewmodels/wishlist_viewmodel.dart';
import '../../models/product.dart';
import '../../models/app_notification.dart';
import '../../services/notification_service.dart';
import '../../widgets/product_card.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final int _currentIndex = 3;
  final NotificationService _notificationService = NotificationService();
  Map<String, List<ProductNotification>> _productNotifications = {};

  @override
  void initState() {
    super.initState();
    // Load wishlist items when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WishlistViewModel>(context, listen: false).loadWishlist();
    });
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final wishlistViewModel = Provider.of<WishlistViewModel>(
      context,
      listen: false,
    );
    final notifications = <String, List<ProductNotification>>{};

    print(
      'Loading notifications for ${wishlistViewModel.wishlistItems.length} wishlist items',
    );

    for (final product in wishlistViewModel.wishlistItems) {
      print(
        'Checking notifications for product: ${product.title} (${product.id})',
      );

      // Get notifications for this product
      final productNotifications = await _notificationService
          .getProductNotifications(product.id);
      print(
        'Found ${productNotifications.length} notifications for ${product.title}',
      );

      if (productNotifications.isNotEmpty) {
        notifications[product.id] = productNotifications;
        print(
          'Added notifications for ${product.title}: ${productNotifications.map((n) => n.message).join(', ')}',
        );
      }
    }

    if (mounted) {
      setState(() {
        _productNotifications = notifications;
        print(
          'Updated _productNotifications with ${notifications.length} products having notifications',
        );
      });
    }
  }

  Future<void> _handleProductTap(Product product) async {
    // Mark notifications as read when product is tapped
    await _notificationService.markProductNotificationsAsRead(product.id);

    // Remove notifications from local state
    setState(() {
      _productNotifications.remove(product.id);
    });

    // Navigate to product details
    if (mounted) {
      Navigator.pushNamed(context, '/product/${product.id}');
    }
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
    return Material(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Wishlist'),
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: SafeArea(
          child: Consumer<WishlistViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (viewModel.wishlistItems.isEmpty) {
                return Center(
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
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add items to your wishlist to see them here',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  await viewModel.loadWishlist();
                  await _loadNotifications();
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: viewModel.wishlistItems.length,
                  itemBuilder: (context, index) {
                    final product = viewModel.wishlistItems[index];
                    final notifications =
                        _productNotifications[product.id] ?? [];

                    print(
                      'Building product card for ${product.title} with ${notifications.length} notifications',
                    );

                    return GestureDetector(
                      onTap: () => _handleProductTap(product),
                      child: Stack(
                        children: [
                          ProductCard(
                            product: product,
                            onTap: () => _handleProductTap(product),
                          ),
                          if (notifications.isNotEmpty)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      notifications.length.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.notifications,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (notifications.isNotEmpty)
                            Positioned(
                              bottom: 8,
                              left: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  notifications.first.message,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: _currentIndex,
          onTap: _onNavBarTap,
        ),
      ),
    );
  }
}
