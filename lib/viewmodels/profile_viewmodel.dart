import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import '../models/user.dart';
import '../services/storage_service.dart';
import '../services/product_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileViewModel extends ChangeNotifier {
  final StorageService _storageService = StorageService();
  final ProductService _productService = ProductService();
  final firebase.FirebaseAuth _auth = firebase.FirebaseAuth.instance;

  User? _user;
  bool _isLoading = false;
  String _error = '';

  // Form data for editing profile
  String _name = '';
  String _email = '';
  String _bio = '';
  String _phone = '';
  File? _avatarFile;

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String get error => _error;

  String get name => _name;
  String get email => _email;
  String get bio => _bio;
  String get phone => _phone;
  File? get avatarFile => _avatarFile;

  // Setters
  set name(String value) {
    _name = value;
    notifyListeners();
  }

  set email(String value) {
    _email = value;
    notifyListeners();
  }

  set bio(String value) {
    _bio = value;
    notifyListeners();
  }

  set phone(String value) {
    _phone = value;
    notifyListeners();
  }

  set avatarFile(File? value) {
    _avatarFile = value;
    notifyListeners();
  }

  // Initialize with current user data
  void initializeWithUser(User user) {
    _user = user;
    _name = user.name;
    _email = user.email;
    _bio = user.bio;
    _phone = user.phone;
    notifyListeners();
  }

  // Load user profile
  Future<void> loadUserProfile() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      // Get current Firebase user
      final firebase.User? firebaseUser = _auth.currentUser;

      if (firebaseUser != null) {
        // Convert Firebase user to our app User model
        _user = User.fromFirebaseUser(firebaseUser);

        // Set form data with user information
        _name = _user!.name;
        _email = _user!.email;
        _bio = _user!.bio;
        _phone = _user!.phone;
      } else {
        // Use mock user data if not signed in (guest mode)
        _user = User(
          uid: 'guest',
          name: 'Guest User',
          avatar: 'assets/images/avatars/default.jpg',
          email: '',
          bio: 'Browsing as guest',
          joinedDate: 'Guest',
        );

        _name = _user!.name;
        _email = _user!.email;
        _bio = _user!.bio;
        _phone = _user!.phone;
      }
    } catch (e) {
      _error = 'Failed to load profile: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update user profile
  Future<bool> updateProfile() async {
    if (_name.isEmpty || _email.isEmpty) {
      _error = 'Name and email are required';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      // Get current user
      final firebase.User? firebaseUser = _auth.currentUser;
      if (firebaseUser == null) {
        _error = 'User not authenticated';
        return false;
      }

      String avatarUrl = _user!.avatar;

      // Upload new avatar if available
      if (_avatarFile != null) {
        try {
          // Upload the new image file
          avatarUrl = await _storageService.uploadImage(_avatarFile!);

          // Update Firebase user profile with new photo URL
          await firebaseUser.updatePhotoURL(avatarUrl);

          // Clear the avatar file after successful upload
          _avatarFile = null;
        } catch (e) {
          print('Error uploading avatar: $e');
          _error = 'Failed to upload profile picture: ${e.toString()}';
          return false;
        }
      }

      // Update Firebase Auth display name
      await firebaseUser.updateDisplayName(_name);

      // Update user document in Firestore
      final userData = {
        'name': _name,
        'email': _email,
        'avatar': avatarUrl,
        'bio': _bio,
        'phone': _phone,
        'online': true,
        'isEmailVerified': _user!.isEmailVerified,
        'joinedDate': _user!.joinedDate,
        'rating': _user!.rating,
        'reviewCount': _user!.reviewCount,
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .update(userData);

      // Refresh user to get updated data
      await firebaseUser.reload();

      // Update local user object with new data
      _user = User.fromFirebaseUser(_auth.currentUser!);

      // Update seller info in all their product listings
      await _productService.updateSellerInfo(_user!.uid, userData);

      // Synchronize form data with updated user
      _name = _user!.name;
      _email = _user!.email;
      _bio = _user!.bio;
      _phone = _user!.phone;

      return true;
    } catch (e) {
      _error = 'Failed to update profile: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sign out user
  Future<void> signOut() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      // Using a safer approach to sign out

      // First try to sign out from Google
      // Do this first since it sometimes depends on Firebase Auth
      bool googleSignOutAttempted = false;

      try {
        final GoogleSignIn googleSignIn = GoogleSignIn();

        // Add timeout to isSignedIn check to prevent hanging
        bool isSignedIn = false;
        try {
          isSignedIn = await googleSignIn.isSignedIn().timeout(
            const Duration(seconds: 3),
            onTimeout: () {
              print(
                "Google isSignedIn check timed out - assuming not signed in",
              );
              return false;
            },
          );
        } catch (checkError) {
          print("Error checking Google sign in status: $checkError");
          isSignedIn = false;
        }

        if (isSignedIn) {
          googleSignOutAttempted = true;
          // First try regular sign out with timeout
          await googleSignIn.signOut().timeout(
            const Duration(seconds: 3),
            onTimeout: () {
              print("Google signOut timed out - continuing anyway");
              return;
            },
          );

          // Then try to disconnect (but don't block on failure)
          try {
            await googleSignIn.disconnect().timeout(
              const Duration(seconds: 2),
              onTimeout: () {
                print("Google disconnect timed out - continuing anyway");
                return;
              },
            );
          } catch (disconnectError) {
            print("Non-critical error during disconnect: $disconnectError");
            // Continue even if disconnect fails
          }
        }
      } catch (googleError) {
        print("Error during Google sign out: $googleError");
        // Continue to Firebase sign out even if Google sign out fails
      }

      // Then sign out from Firebase
      await _auth.signOut();

      // Clear user data
      _user = null;
      _name = '';
      _email = '';
      _bio = '';
      _phone = '';
      _avatarFile = null;
    } catch (e) {
      _error = 'Failed to sign out: ${e.toString()}';
      print("Sign out error: $_error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
