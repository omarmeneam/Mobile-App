import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../screens/auth/sign_in_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/product/product_detail_screen.dart';
import '../../screens/search/search_screen.dart';
import '../../screens/create_listing/create_listing_screen.dart';
import '../../screens/my_listings/my_listings_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/profile/edit_profile_screen.dart';
import '../../screens/wishlist/wishlist_screen.dart';
import '../../screens/messages/messages_screen.dart';
import '../../screens/messages/chat_screen.dart';
import '../../screens/notifications/notifications_screen.dart';
import '../../screens/admin/admin_dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusCart',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/sign-in',
      routes: {
        '/sign-in': (context) => const SignInScreen(),
        '/home': (context) => const HomeScreen(),
        '/search': (context) => const SearchScreen(),
        '/create-listing': (context) => const CreateListingScreen(),
        '/my-listings': (context) => const MyListingsScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/profile/edit': (context) => const EditProfileScreen(),
        '/wishlist': (context) => const WishlistScreen(),
        '/messages': (context) => const MessagesScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/admin': (context) => const AdminDashboardScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name?.startsWith('/product/') ?? false) {
          final productId = int.parse(settings.name!.split('/')[2]);
          return MaterialPageRoute(
            builder: (context) => ProductDetailScreen(productId: productId),
          );
        }
        if (settings.name?.startsWith('/messages/') ?? false) {
          final userId = int.parse(settings.name!.split('/')[2]);
          return MaterialPageRoute(
            builder: (context) => ChatScreen(userId: userId),
          );
        }
        return null;
      },
    );
  }
}
