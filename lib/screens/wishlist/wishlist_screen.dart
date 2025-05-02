import 'package:flutter/material.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../models/product.dart';
import '../../theme/app_colors.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final int _currentIndex = 3;

  // Mock wishlist data
  final List<Product> _wishlist = [
    Product(
      id: 1,
      title: 'Textbook - Introduction to Psychology',
      price: 45.0,
      image: 'assets/images/placeholder.png',
      category: 'Books',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      seller: Seller(
        id: 101,
        name: 'Alex Johnson',
        avatar: 'assets/images/placeholder.png',
        rating: 4.8,
        joinedDate: 'Sep 2023',
      ),
    ),
    Product(
      id: 2,
      title: 'Desk Lamp - Adjustable LED',
      price: 25.0,
      image: 'assets/images/placeholder.png',
      category: 'Electronics',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      seller: Seller(
        id: 102,
        name: 'Jamie Smith',
        avatar: 'assets/images/placeholder.png',
        rating: 4.5,
        joinedDate: 'Aug 2023',
      ),
    ),
    Product(
      id: 5,
      title: 'Bicycle - Campus Cruiser',
      price: 120.0,
      image: 'assets/images/placeholder.png',
      category: 'Transportation',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      seller: Seller(
        id: 103,
        name: 'Taylor Wilson',
        avatar: 'assets/images/placeholder.png',
        rating: 4.2,
        joinedDate: 'Jul 2023',
      ),
    ),
  ];

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

  void _removeFromWishlist(int id) {
    setState(() {
      _wishlist.removeWhere((item) => item.id == id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Removed from wishlist'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Saved Items (${_wishlist.length})',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            Expanded(
              child:
                  _wishlist.isEmpty
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
                        itemCount: _wishlist.length,
                        itemBuilder: (context, index) {
                          final item = _wishlist[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
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
                                              padding: EdgeInsets.zero,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Seller: ${item.seller!.name}',
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.bodySmall,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pushNamed(
                                                    context,
                                                    '/product/${item.id}',
                                                  );
                                                },
                                                child: const Text('View Item'),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed:
                                                  () => _removeFromWishlist(
                                                    item.id,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
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
  }
}
