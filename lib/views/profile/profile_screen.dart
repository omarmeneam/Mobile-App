import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../theme/app_colors.dart';
import '../../viewmodels/profile_viewmodel.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final int _currentIndex = 4;

  @override
  void initState() {
    super.initState();
    // Load user profile when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileViewModel>(context, listen: false).loadUserProfile();
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
        Navigator.pushReplacementNamed(context, '/wishlist');
        break;
      case 4:
        // Already on profile
        break;
    }
  }

  void _signOut() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/sign-in');
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.pushNamed(context, '/profile/edit');
                },
              ),
            ],
          ),
          body: viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : viewModel.error.isNotEmpty
                  ? Center(child: Text(viewModel.error))
                  : viewModel.user == null
                      ? const Center(child: Text('User not found'))
                      : SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // User Profile Card
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 40,
                                          backgroundImage: AssetImage(viewModel.user!.avatar),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                viewModel.user!.name,
                                                style: Theme.of(context).textTheme.titleLarge,
                                              ),
                                              Text(
                                                viewModel.user!.email,
                                                style: Theme.of(context).textTheme.bodyMedium,
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                    size: 16,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    '${viewModel.user!.rating}',
                                                    style: Theme.of(context).textTheme.bodyMedium,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    '(${viewModel.user!.reviewCount} reviews)',
                                                    style: Theme.of(context).textTheme.bodySmall,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // My Account Section
                              Text('My Account', style: Theme.of(context).textTheme.titleLarge),
                              const SizedBox(height: 12),
                              Card(
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: Icon(
                                        Icons.inventory_2_outlined,
                                        color: AppColors.primary,
                                      ),
                                      title: const Text('My Listings'),
                                      trailing: const Icon(Icons.chevron_right),
                                      onTap: () {
                                        Navigator.pushNamed(context, '/my-listings');
                                      },
                                    ),
                                    const Divider(height: 1),
                                    ListTile(
                                      leading: Icon(
                                        Icons.message_outlined,
                                        color: AppColors.secondary,
                                      ),
                                      title: const Text('Messages'),
                                      trailing: const Icon(Icons.chevron_right),
                                      onTap: () {
                                        Navigator.pushNamed(context, '/messages');
                                      },
                                    ),
                                    const Divider(height: 1),
                                    ListTile(
                                      leading: Icon(
                                        Icons.favorite_border,
                                        color: AppColors.primary,
                                      ),
                                      title: const Text('Wishlist'),
                                      trailing: const Icon(Icons.chevron_right),
                                      onTap: () {
                                        Navigator.pushNamed(context, '/wishlist');
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Support Section
                              Text('Support', style: Theme.of(context).textTheme.titleLarge),
                              const SizedBox(height: 16),
                              Card(
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: Icon(
                                        Icons.help_outline,
                                        color: AppColors.tertiary,
                                      ),
                                      title: const Text('Help Center'),
                                      trailing: const Icon(Icons.chevron_right),
                                      onTap: () {
                                        // Navigate to help center
                                      },
                                    ),
                                    const Divider(height: 1),
                                    ListTile(
                                      leading: Icon(
                                        Icons.privacy_tip_outlined,
                                        color: AppColors.tertiary,
                                      ),
                                      title: const Text('Privacy Policy'),
                                      trailing: const Icon(Icons.chevron_right),
                                      onTap: () {
                                        // Navigate to privacy policy
                                      },
                                    ),
                                    const Divider(height: 1),
                                    ListTile(
                                      leading: Icon(
                                        Icons.description_outlined,
                                        color: AppColors.tertiary,
                                      ),
                                      title: const Text('Terms of Service'),
                                      trailing: const Icon(Icons.chevron_right),
                                      onTap: () {
                                        // Navigate to terms of service
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Sign Out Button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.logout),
                                  label: const Text('Sign Out'),
                                  onPressed: _signOut,
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.red,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                              ),
                              
                              // Admin Dashboard Button (for development purposes)
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.admin_panel_settings),
                                  label: const Text('Admin Dashboard'),
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/admin');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.blueGrey,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Center(
                                child: Text(
                                  'Admin access for development purposes',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey,
                                    fontStyle: FontStyle.italic,
                                  ),
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
