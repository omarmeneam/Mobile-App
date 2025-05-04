import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../theme/app_colors.dart';
import '../../views/home/home_screen.dart'; // Assuming you have a home screen

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Google Sign-In method
  Future<void> _signInWithGoogle() async {
    try {
      // Trigger Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // If the user cancels the sign-in flow
      if (googleUser == null) return;

      // Obtain the Google authentication details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create credentials for Firebase Authentication
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the credentials
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      // If the user is signed in, navigate to the Home Screen
      if (user != null) {
        // Navigate to the home screen after successful sign-in
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (error) {
      // Handle errors
      print("Error signing in with Google: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in with Google. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // Dev mode access to admin dashboard
          IconButton(
            icon: const Icon(
              Icons.admin_panel_settings,
              color: Colors.grey,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/admin');
            },
            tooltip: 'Admin Dashboard (Dev Mode)',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.shopping_cart,
                  size: 60,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),

              // App Name
              Text(
                'CampusCart',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.black),
              ),
              const SizedBox(height: 8),

              // App Description
              Text(
                'Buy and sell items within your campus community',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
              ),
              const SizedBox(height: 48),

              // Sign in with Google Button
              ElevatedButton.icon(
                onPressed: _signInWithGoogle, // Call the sign-in method
                icon: const Icon(Icons.login),
                label: const Text(
                  'Sign in with Google',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 16),

              // Divider
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey[300])),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('OR', style: TextStyle(color: Colors.black)),
                  ),
                  Expanded(child: Divider(color: Colors.grey[300])),
                ],
              ),
              const SizedBox(height: 16),

              // Continue as Guest Button
              OutlinedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
                child: const Text(
                  'Continue as Guest',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 24),

              // Terms and Conditions
              Text(
                'By continuing, you agree to our Terms of Service and Privacy Policy',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
