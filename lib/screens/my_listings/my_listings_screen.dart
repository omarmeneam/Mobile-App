import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../theme/app_colors.dart';

class MyListingsScreen extends StatefulWidget {
  const MyListingsScreen({super.key});

  @override
  _MyListingsScreenState createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen> {
  final int _currentIndex = 4; // Profile tab

  // Mock listings data
  final List<Product> _listings = [
    Product(
      id: 1,
      title: 'Textbook - Introduction to Psychology',
      price: 45.0,
      image: 'assets/images/placeholder.png',
      category: 'Books',
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      active: true,
      views: 12,
    ),
    Product(
      id: 2,
      title: 'Desk Lamp - Adjustable LED',
      price: 25.0,
      image: 'assets/images/placeholder.png',
      category: 'Electronics',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      active: true,
      views: 8,
    ),
    Product(
      id: 3,
      title: 'Scientific Calculator',
      price: 30.0,
      image: 'assets/images/placeholder.png',
      category: 'Electronics',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      active: false,
      views: 5,
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
        Navigator.pushReplacementNamed(context, '/wishlist');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  void _toggleActive(int id) {
    setState(() {
      final index = _listings.indexWhere((listing) => listing.id == id);
      if (index != -1) {
        final listing = _listings[index];
        _listings[index] = Product(
          id: listing.id,
          title: listing.title,
          price: listing.price,
          image: listing.image,
          category: listing.category,
          createdAt: listing.createdAt,
          active: !listing.active,
          views: listing.views,
        );
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _listings.firstWhere((listing) => listing.id == id).active
              ? 'Listing activated'
              : 'Listing hidden',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _deleteListing(int id) {
    setState(() {
      _listings.removeWhere((listing) => listing.id == id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Listing deleted'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Listing'),
            content: const Text(
              'Are you sure you want to delete this listing? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _deleteListing(id);
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Listings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/profile');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Items (${_listings.length})',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/create-listing');
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('New Listing'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Expanded(
              child:
                  _listings.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'You don\'t have any listings yet',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/create-listing');
                              },
                              child: const Text('Create Your First Listing'),
                            ),
                          ],
                        ),
                      )
                      : ListView.builder(
                        itemCount: _listings.length,
                        itemBuilder: (context, index) {
                          final listing = _listings[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Opacity(
                              opacity: listing.active ? 1.0 : 0.7,
                              child: Row(
                                children: [
                                  // Product Image
                                  SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: Image.asset(
                                      listing.image,
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
                                            listing.title,
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.titleMedium,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'RM ${listing.price.toStringAsFixed(2)}',
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
                                                  listing.category,
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
                                                '${listing.views} views',
                                                style:
                                                    Theme.of(
                                                      context,
                                                    ).textTheme.bodySmall,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // Action Buttons
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          // Navigate to edit listing screen
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Edit functionality would be implemented here',
                                              ),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          listing.active
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                        ),
                                        onPressed:
                                            () => _toggleActive(listing.id),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed:
                                            () => _confirmDelete(listing.id),
                                      ),
                                    ],
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
  }
}
