import 'package:flutter/material.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/product_card.dart';
import '../../models/product.dart';
import '../../theme/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final int _currentIndex = 0;
  late TabController _tabController;
  final List<String> _categories = [
    'All',
    'Books',
    'Electronics',
    'Furniture',
    'Clothing',
    'Appliances',
    'Transportation',
  ];

  // Mock product data
  final List<Product> _products = [
    Product(
      id: 1,
      title: 'Textbook - Introduction to Psychology',
      price: 45.0,
      image: 'assets/images/placeholder.png',
      category: 'Books',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Product(
      id: 2,
      title: 'Desk Lamp - Adjustable LED',
      price: 25.0,
      image: 'assets/images/placeholder.png',
      category: 'Electronics',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Product(
      id: 3,
      title: 'Dorm Mini Fridge',
      price: 80.0,
      image: 'assets/images/placeholder.png',
      category: 'Appliances',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Product(
      id: 4,
      title: 'Scientific Calculator',
      price: 30.0,
      image: 'assets/images/placeholder.png',
      category: 'Electronics',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Product(
      id: 5,
      title: 'Bicycle - Campus Cruiser',
      price: 120.0,
      image: 'assets/images/placeholder.png',
      category: 'Transportation',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
    Product(
      id: 6,
      title: 'Desk Chair - Ergonomic',
      price: 65.0,
      image: 'assets/images/placeholder.png',
      category: 'Furniture',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onNavBarTap(int index) {
    if (index == _currentIndex) return;

    switch (index) {
      case 0:
        // Already on home
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

  List<Product> _getFilteredProducts(String category) {
    if (category == 'All') {
      return _products;
    }
    return _products.where((product) => product.category == category).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CampusCart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.message_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/messages');
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/search');
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(
                      'Search for items...',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Category Tabs
          TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey[600],
            indicatorColor: AppColors.primary,
            tabs: _categories.map((category) => Tab(text: category)).toList(),
          ),

          // Product Grid
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children:
                  _categories.map((category) {
                    final filteredProducts = _getFilteredProducts(category);
                    return filteredProducts.isEmpty
                        ? Center(
                          child: Text(
                            'No products in this category',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        )
                        : GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio:
                                    0.70, // Adjusted for taller cards
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            return ProductCard(
                              product: filteredProducts[index],
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/product/${filteredProducts[index].id}',
                                );
                              },
                            );
                          },
                        );
                  }).toList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarTap,
      ),
    );
  }
}
