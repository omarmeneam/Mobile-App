import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'views/auth/sign_in_screen.dart';
import 'views/home/home_screen.dart';
import 'views/product/product_detail_screen.dart';
import 'views/search/search_screen.dart';
import 'views/create_listing/create_listing_screen.dart';
import 'views/my_listings/my_listings_screen.dart';
import 'views/profile/profile_screen.dart';
import 'views/profile/edit_profile_screen.dart';
import 'views/wishlist/wishlist_screen.dart';
import 'views/messages/messages_screen.dart';
import 'views/messages/chat_screen.dart';
import 'views/notifications/notifications_screen.dart';
import 'views/admin/admin_dashboard_screen.dart';
import 'viewmodels/home_viewmodel.dart';
import 'viewmodels/product_viewmodel.dart';
import 'viewmodels/search_viewmodel.dart';
import 'viewmodels/listing_viewmodel.dart';
import 'viewmodels/profile_viewmodel.dart';
import 'viewmodels/wishlist_viewmodel.dart';
import 'viewmodels/messages_viewmodel.dart';
import 'viewmodels/notifications_viewmodel.dart';

void main() async{
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => ProductViewModel()),
        ChangeNotifierProvider(create: (_) => SearchViewModel()),
        ChangeNotifierProvider(create: (_) => ListingViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => WishlistViewModel()),
        ChangeNotifierProvider(create: (_) => MessagesViewModel()),
        ChangeNotifierProvider(create: (_) => NotificationsViewModel()),
      ],
      child: MaterialApp(
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
      ),
    );
  }
}
