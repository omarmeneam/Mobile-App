import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/admin_product_card.dart';
import '../../models/product.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock stats data
  final List<Map<String, dynamic>> _stats = [
    {
      'title': 'Total Users',
      'value': '1,234',
      'change': '+12%',
      'icon': Icons.people,
    },
    {
      'title': 'Active Listings',
      'value': '856',
      'change': '+5%',
      'icon': Icons.inventory_2,
    },
    {'title': 'Reports', 'value': '23', 'change': '-8%', 'icon': Icons.flag},
    {
      'title': 'Transactions',
      'value': '432',
      'change': '+18%',
      'icon': Icons.bar_chart,
    },
  ];

  // Mock pending listings data
  final List<Product> _pendingListings = [
    Product(
      id: 1,
      title: 'Fake Designer Bag',
      price: 150.0,
      image: 'assets/images/placeholder.png',
      category: 'Fashion',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      seller: Seller(
        id: 101,
        name: 'John Doe',
        avatar: 'assets/images/placeholder.png',
        rating: 4.2,
        joinedDate: 'Jan 2024',
      ),
    ),
    Product(
      id: 2,
      title: 'Exam Answer Key',
      price: 50.0,
      image: 'assets/images/placeholder.png',
      category: 'Books',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      seller: Seller(
        id: 102,
        name: 'Jane Smith',
        avatar: 'assets/images/placeholder.png',
        rating: 3.8,
        joinedDate: 'Feb 2024',
      ),
    ),
  ];

  void _handleApprovePost(int productId) {
    setState(() {
      _pendingListings.removeWhere((product) => product.id == productId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Post approved successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleTakeDownPost(int productId) {
    setState(() {
      _pendingListings.removeWhere((product) => product.id == productId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Post taken down and warning sent to user'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleBanUser(int productId) {
    final product = _pendingListings.firstWhere((p) => p.id == productId);
    setState(() {
      _pendingListings.removeWhere((p) => p.id == productId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('User ${product.seller?.name} has been banned'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _stats.length,
              itemBuilder: (context, index) {
                final stat = _stats[index];
                final isPositive = stat['change'].startsWith('+');

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          stat['icon'],
                          size: 32,
                          color: _getStatColor(index),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          stat['title'],
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          stat['value'],
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          stat['change'],
                          style: TextStyle(
                            color: isPositive ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Tabs
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: Colors.grey[600],
                indicatorColor: AppColors.primary,
                tabs: const [
                  Tab(text: 'Pending Posts'),
                  Tab(text: 'Users'),
                  Tab(text: 'Reports'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tab Content
            SizedBox(
              height: 600,
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Pending Posts Tab
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pending Posts',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child:
                                _pendingListings.isEmpty
                                    ? Center(
                                      child: Text(
                                        'No pending posts',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    )
                                    : GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            childAspectRatio: 0.70,
                                            crossAxisSpacing: 16,
                                            mainAxisSpacing: 16,
                                          ),
                                      itemCount: _pendingListings.length,
                                      itemBuilder: (context, index) {
                                        final product = _pendingListings[index];
                                        return AdminProductCard(
                                          product: product,
                                          onTap: () {},
                                          onApprove:
                                              () => _handleApprovePost(
                                                product.id,
                                              ),
                                          onTakeDown:
                                              () => _handleTakeDownPost(
                                                product.id,
                                              ),
                                          onBanUser:
                                              () => _handleBanUser(product.id),
                                        );
                                      },
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Users Tab
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'User Management',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: Center(
                              child: Text(
                                'User management interface would go here',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Reports Tab
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reports Management',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: Center(
                              child: Text(
                                'Reports management interface would go here',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ),
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

  Color _getStatColor(int index) {
    switch (index) {
      case 0:
        return AppColors.primary;
      case 1:
        return AppColors.secondary;
      case 2:
        return AppColors.tertiary;
      case 3:
        return AppColors.accent;
      default:
        return Colors.grey;
    }
  }
}
