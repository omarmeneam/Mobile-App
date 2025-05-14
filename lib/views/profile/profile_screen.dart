import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../theme/app_colors.dart';
import '../../viewmodels/profile_viewmodel.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  // Make buildAvatar static and public
  static Widget buildAvatar(String avatarUrl) {
    // Check if it's a network image (starts with http/https)
    if (avatarUrl.startsWith('http')) {
      return CircleAvatar(
        radius: 40,
        backgroundColor: Colors.grey[200],
        child: ClipOval(
          child: Image.network(
            avatarUrl,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            // Handle loading state
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value:
                      loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                  strokeWidth: 2,
                ),
              );
            },
            // Handle loading errors gracefully
            errorBuilder: (context, error, stackTrace) {
              print('Error loading profile image: $error');
              // On error, show a fallback image
              return Image.asset(
                'assets/images/avatars/default.jpg',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              );
            },
          ),
        ),
      );
    } else {
      // Local asset image
      return CircleAvatar(
        radius: 40,
        backgroundColor: Colors.grey[200],
        backgroundImage: AssetImage(avatarUrl),
      );
    }
  }

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
    // Create a scaffold messenger key to use outside of context
    final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
        GlobalKey<ScaffoldMessengerState>();

    showDialog(
      context: context,
      builder:
          (BuildContext dialogContext) => AlertDialog(
            title: const Text('Sign Out'),
            content: const Text('Are you sure you want to sign out?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  // First dismiss the dialog
                  Navigator.pop(dialogContext);

                  // Use a separate function to handle the async work
                  _performSignOut();
                },
                child: const Text('Sign Out'),
              ),
            ],
          ),
    );
  }

  // Separate method to handle the async sign out process
  Future<void> _performSignOut() async {
    // Store the BuildContext at the beginning of the operation
    final BuildContext currentContext = context;

    // Track whether we're still mounted throughout the async operation
    bool isCurrentlyMounted = true;

    // Keep track of the current state to properly handle navigation
    bool signedOut = false;

    // Show loading overlay that doesn't depend on async Dialog
    final OverlayState overlayState = Overlay.of(currentContext);
    final OverlayEntry overlayEntry = OverlayEntry(
      builder:
          (BuildContext context) => Container(
            color: Colors.black54,
            child: const Center(child: CircularProgressIndicator()),
          ),
    );

    overlayState.insert(overlayEntry);

    try {
      // Reference the viewModel once before async operations
      final profileViewModel = Provider.of<ProfileViewModel>(
        currentContext,
        listen: false,
      );

      // Perform sign out
      await profileViewModel.signOut();
      signedOut = true;
    } catch (e) {
      // Handle error - we'll show it below if still mounted
      if (mounted) {
        ScaffoldMessenger.of(
          currentContext,
        ).showSnackBar(SnackBar(content: Text('Error signing out: $e')));
      }
    } finally {
      // Always remove the loading overlay
      overlayEntry.remove();

      // Only navigate if we're still mounted and actually signed out
      if (mounted && signedOut) {
        // Navigate without using context from a callback
        Navigator.of(currentContext).pushNamedAndRemoveUntil(
          '/sign-in',
          (route) => false, // Clear all routes in the stack
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Image.asset(
                  'assets/images/LogoImage.png',
                  width: 30,
                  height: 30,
                ),
                const SizedBox(width: 8),
                const Text('Profile'),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.pushNamed(context, '/profile/edit');
                },
              ),
            ],
          ),
          body:
              viewModel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : viewModel.error.isNotEmpty
                  ? Center(child: Text(viewModel.error))
                  : viewModel.user == null
                  ? const Center(child: Text('User not found'))
                  : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // User Profile Card
                        Card(
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ProfileScreen.buildAvatar(
                                    viewModel.user!.avatar,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          viewModel.user!.name,
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.titleLarge,
                                        ),
                                        Text(
                                          viewModel.user!.email,
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.bodyMedium,
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 4.0,
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                viewModel.user!.isEmailVerified
                                                    ? Icons.verified
                                                    : Icons
                                                        .warning, // Use Icons.warning as a placeholder
                                                color:
                                                    viewModel
                                                            .user!
                                                            .isEmailVerified
                                                        ? Colors.green[800]
                                                        : Colors.yellow[800],
                                                size: 16,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                viewModel.user!.isEmailVerified
                                                    ? 'UTM Email Verified'
                                                    : 'Email Not Verified',
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodySmall?.copyWith(
                                                  color:
                                                      viewModel
                                                              .user!
                                                              .isEmailVerified
                                                          ? Colors.green[800]
                                                          : Colors.yellow[800],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        const SizedBox(height: 8),
                                        Text(
                                          'Member since: ${viewModel.user!.joinedDate}',
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.bodySmall,
                                        ),
                                        const SizedBox(height: 4),
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
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.bodyMedium,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '(${viewModel.user!.reviewCount} reviews)',
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
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // My Account Section
                        Text(
                          'My Account',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        Card(
                          elevation: 0,
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
                        Text(
                          'Support',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        Card(
                          elevation: 0,
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
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(
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
