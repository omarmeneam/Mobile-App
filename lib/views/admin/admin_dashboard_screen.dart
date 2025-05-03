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
      description: 'Counterfeit designer bag being sold as authentic. This violates our marketplace policies.',
      image: 'https://images.unsplash.com/photo-1584917865442-de89df41a97a?q=80&w=800',
      category: 'Fashion',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      seller: Seller(
        id: 101,
        name: 'John Doe',
        avatar: 'https://randomuser.me/api/portraits/men/42.jpg',
        rating: 4.2,
        joinedDate: 'Jan 2024',
      ),
    ),
    Product(
      id: 2,
      title: 'Exam Answer Key',
      price: 50.0,
      description: 'Selling academic materials not allowed. This is an exam answer key from professor Smith.',
      image: 'https://images.unsplash.com/photo-1588580000645-5661c9f2ddcc?q=80&w=800',
      category: 'Books',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      seller: Seller(
        id: 102,
        name: 'Jane Smith',
        avatar: 'https://randomuser.me/api/portraits/women/33.jpg',
        rating: 3.8,
        joinedDate: 'Feb 2024',
      ),
    ),
    Product(
      id: 3,
      title: 'Research Paper Writing Service',
      price: 120.0,
      description: 'Will write your research paper or essay for you. 100% guaranteed good grade.',
      image: 'https://images.unsplash.com/photo-1532153955177-f59af40d6472?q=80&w=800',
      category: 'Services',
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
      seller: Seller(
        id: 103,
        name: 'Alex Wilson',
        avatar: 'https://randomuser.me/api/portraits/men/48.jpg',
        rating: 4.6,
        joinedDate: 'Dec 2023',
      ),
    ),
    Product(
      id: 4,
      title: 'Alcohol for Under 21',
      price: 75.0,
      description: 'Premium spirits and beer for campus delivery. No ID required.',
      image: 'https://images.unsplash.com/photo-1597290282695-edc43d0e7129?q=80&w=800',
      category: 'Food & Drinks',
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      seller: Seller(
        id: 104,
        name: 'Mike Johnson',
        avatar: 'https://randomuser.me/api/portraits/men/67.jpg',
        rating: 3.9,
        joinedDate: 'Mar 2024',
      ),
    ),
  ];

  // Mock user data
  final List<Map<String, dynamic>> _users = [
    {
      'id': 1,
      'name': 'John Doe',
      'email': 'john.doe@university.edu',
      'avatar': 'https://randomuser.me/api/portraits/men/42.jpg',
      'status': 'Active',
      'joinDate': 'Jan 15, 2024',
      'listings': 8,
      'reports': 2,
    },
    {
      'id': 2,
      'name': 'Jane Smith',
      'email': 'jane.smith@university.edu',
      'avatar': 'https://randomuser.me/api/portraits/women/33.jpg',
      'status': 'Active',
      'joinDate': 'Feb 23, 2024',
      'listings': 5,
      'reports': 1,
    },
    {
      'id': 3,
      'name': 'Mike Johnson',
      'email': 'mike.johnson@university.edu',
      'avatar': 'https://randomuser.me/api/portraits/men/67.jpg',
      'status': 'Warning',
      'joinDate': 'Mar 10, 2024',
      'listings': 12,
      'reports': 3,
    },
    {
      'id': 4,
      'name': 'Sarah Davis',
      'email': 'sarah.davis@university.edu',
      'avatar': 'https://randomuser.me/api/portraits/women/42.jpg',
      'status': 'Suspended',
      'joinDate': 'Dec 5, 2023',
      'listings': 0,
      'reports': 5,
    },
  ];

  // Mock reports data
  final List<Map<String, dynamic>> _reports = [
    {
      'id': 1,
      'type': 'Counterfeit Item',
      'productId': 101,
      'productTitle': 'Fake Designer Bag',
      'reportedBy': 'User #458',
      'date': 'Apr 12, 2024',
      'status': 'Pending',
    },
    {
      'id': 2,
      'type': 'Academic Fraud',
      'productId': 102,
      'productTitle': 'Exam Answer Key',
      'reportedBy': 'User #221',
      'date': 'Apr 11, 2024',
      'status': 'Pending',
    },
    {
      'id': 3,
      'type': 'Inappropriate Content',
      'productId': 98,
      'productTitle': 'Dorm Party Services',
      'reportedBy': 'User #345',
      'date': 'Apr 10, 2024',
      'status': 'Resolved',
    },
    {
      'id': 4,
      'type': 'Scam',
      'productId': 87,
      'productTitle': 'iPhone 13 Pro (Broken)',
      'reportedBy': 'User #512',
      'date': 'Apr 9, 2024',
      'status': 'Resolved',
    },
  ];

  // Mock banned users data
  final List<Map<String, dynamic>> _bannedUsers = [
    {
      'id': 5,
      'name': 'Sarah Davis',
      'email': 'sarah.davis@university.edu',
      'avatar': 'https://randomuser.me/api/portraits/women/42.jpg',
      'status': 'Banned',
      'joinDate': 'Dec 5, 2023',
      'banDate': 'Apr 10, 2024',
      'banReason': 'Multiple policy violations (5 reports)',
    },
    {
      'id': 6,
      'name': 'Alex Wilson',
      'email': 'alex.wilson@university.edu',
      'avatar': 'https://randomuser.me/api/portraits/men/48.jpg',
      'status': 'Banned',
      'joinDate': 'Dec 13, 2023',
      'banDate': 'Apr 12, 2024',
      'banReason': 'Selling counterfeit items',
    },
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
    
    // Add the user to banned users list
    if (product.seller != null) {
      final newBannedUser = {
        'id': product.seller!.id,
        'name': product.seller!.name,
        'email': '${product.seller!.name.toLowerCase().replaceAll(' ', '.')}@university.edu',
        'avatar': product.seller!.avatar,
        'status': 'Banned',
        'joinDate': product.seller!.joinedDate,
        'banDate': DateTime.now().toString().substring(0, 10),
        'banReason': 'Violating marketplace policies with listing: ${product.title}',
      };
      
      setState(() {
        _bannedUsers.add(newBannedUser);
        _pendingListings.removeWhere((p) => p.id == productId);
      });
    } else {
      setState(() {
        _pendingListings.removeWhere((p) => p.id == productId);
      });
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('User ${product.seller?.name} has been banned'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'warning':
        return Colors.orange;
      case 'suspended':
        return Colors.red;
      case 'pending':
        return Colors.blue;
      case 'resolved':
        return Colors.green;
      default:
        return Colors.grey;
    }
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

  Color _getStatColor(int index) {
    switch (index) {
      case 0:
        return Colors.blue;
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
          bottom: TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey[600],
            indicatorColor: AppColors.primary,
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'Moderation'),
              Tab(text: 'Users'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(),
            _buildModerationTab(),
            _buildUsersTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Welcome Card
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: AppColors.primary,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.admin_panel_settings,
                        color: AppColors.primary,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Welcome, Admin',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Last login: ${DateTime.now().toString().substring(0, 16)}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          Text(
            'Dashboard Overview',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Stats Grid
          LayoutBuilder(
            builder: (context, constraints) {
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: constraints.maxWidth > 500 ? 4 : 2,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _stats.length,
                itemBuilder: (context, index) {
                  final stat = _stats[index];
                  final isPositive = stat['change'].startsWith('+');

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            stat['icon'],
                            size: 24,
                            color: _getStatColor(index),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            stat['title'],
                            style: Theme.of(context).textTheme.titleSmall,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 2),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              stat['value'],
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                                size: 12,
                                color: isPositive ? Colors.green : Colors.red,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                stat['change'],
                                style: TextStyle(
                                  color: isPositive ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildModerationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.orange[50],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber,
                    color: Colors.orange[800],
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Items Requiring Moderation',
                          style: TextStyle(
                            color: Colors.orange[800],
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_pendingListings.length} items need your attention',
                          style: TextStyle(
                            color: Colors.orange[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Pending Posts Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pending Listings',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          _pendingListings.isEmpty
              ? SizedBox(
                  height: 200,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No pending posts',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.58,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: _pendingListings.length,
                    itemBuilder: (context, index) {
                      final product = _pendingListings[index];
                      return AdminProductCard(
                        product: product,
                        onTap: () {
                          _showItemDetailDialog(context, product);
                        },
                        onApprove: () => _handleApprovePost(product.id),
                        onTakeDown: () => _handleTakeDownPost(product.id),
                        onBanUser: () => _handleBanUser(product.id),
                      );
                    },
                  ),
                ),

          const SizedBox(height: 24),

          // Reports Section
          Text(
            'Recent Reports',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _reports.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final report = _reports[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getStatusColor(report['status']),
                    child: Text(
                      '#${report['id']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  title: Text(report['productTitle']),
                  subtitle: Text('${report['type']} - ${report['date']}'),
                  trailing: Chip(
                    label: Text(
                      report['status'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    backgroundColor: _getStatusColor(report['status']),
                    padding: EdgeInsets.zero,
                  ),
                  onTap: () {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersTab() {
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search users...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
              ),
            ),
          ),
          
          // Tab Bar
          const TabBar(
            tabs: [
              Tab(text: 'Active Users'),
              Tab(text: 'Banned Users'),
            ],
          ),
          
          // Tab Views
          Expanded(
            child: TabBarView(
              children: [
                // Active Users Tab
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'User Management',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.filter_list),
                            label: const Text('Filter'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // User List
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _users.length,
                          separatorBuilder: (context, index) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final user = _users[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(user['avatar']),
                              ),
                              title: Row(
                                children: [
                                  Text(user['name']),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(user['status']),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      user['status'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Text('${user['email']} • Joined ${user['joinDate']}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${user['listings']} listings',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      if (user['reports'] > 0)
                                        Text(
                                          '${user['reports']} reports',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: user['reports'] > 2 ? Colors.red : Colors.orange,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.chevron_right),
                                ],
                              ),
                              onTap: () {},
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Banned Users Tab
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Banned Users',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Badge(
                            label: Text(
                              _bannedUsers.length.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Users banned from the platform due to policy violations',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 16),
                      
                      // Banned User List
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _bannedUsers.length,
                          separatorBuilder: (context, index) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final user = _bannedUsers[index];
                            return ListTile(
                              isThreeLine: true,
                              leading: Stack(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(user['avatar']),
                                  ),
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 1),
                                      ),
                                      child: const Icon(
                                        Icons.block,
                                        size: 10,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              title: Text(user['name']),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${user['email']} • Banned on ${user['banDate']}'),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Reason: ${user['banReason']}',
                                    style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 12,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: OutlinedButton(
                                onPressed: () {
                                  // Show an unban confirmation dialog
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Unban User?'),
                                      content: Text('Are you sure you want to unban ${user['name']}?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text('Cancel'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            // Implement unban logic here
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('${user['name']} has been unbanned'),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                            Navigator.pop(context);
                                          },
                                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                          child: const Text('Unban'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.green,
                                  side: const BorderSide(color: Colors.green),
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                ),
                                child: const Text('Unban'),
                              ),
                              onTap: () {},
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showItemDetailDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Item Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (product.image.startsWith('http'))
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    product.image,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                )
              else
                const SizedBox.shrink(),
              const SizedBox(height: 16),
              Text(
                product.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'RM ${product.price.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Description',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(product.description),
              const SizedBox(height: 16),
              const Text(
                'Seller Information',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (product.seller?.avatar != null)
                    CircleAvatar(
                      backgroundImage: (product.seller!.avatar.startsWith('http'))
                        ? NetworkImage(product.seller!.avatar)
                        : null,
                      radius: 20,
                    ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.seller?.name ?? 'Unknown',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('Member since ${product.seller?.joinedDate ?? 'unknown'}'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Reason for Review',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: const Text(
                  'This listing may violate marketplace policies. Please review the content and make a moderation decision.',
                ),
              ),
            ],
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _handleTakeDownPost(product.id);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Take Down'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _handleApprovePost(product.id);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Approve'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
