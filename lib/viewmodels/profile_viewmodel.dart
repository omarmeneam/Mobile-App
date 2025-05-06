import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import '../models/user.dart';
import '../services/storage_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileViewModel extends ChangeNotifier {
  final StorageService _storageService = StorageService();
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
      String avatarUrl = _user!.avatar;

      // If avatar was changed, upload it
      if (_avatarFile != null) {
        avatarUrl = await _storageService.uploadImage(_avatarFile!);
      }

      // Get current user
      final firebase.User? firebaseUser = _auth.currentUser;

      if (firebaseUser != null) {
        // Update Firebase user profile
        await firebaseUser.updateDisplayName(_name);

        // Email update requires re-authentication, only update if changed
        if (_email != firebaseUser.email) {
          await firebaseUser.updateEmail(_email);
        }

        // Update photo URL if available
        if (avatarUrl != _user!.avatar) {
          await firebaseUser.updatePhotoURL(avatarUrl);
        }

        // Refresh user to get updated data
        await firebaseUser.reload();

        // Update local user object with new data
        _user = User.fromFirebaseUser(_auth.currentUser!);

        // TODO: Store additional profile data (bio, phone) in Firestore or other DB
      }

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
    try {
      // Sign out from Firebase
      await _auth.signOut();

      // Sign out from Google as well
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // Check if signed in before attempting to sign out
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();

        // Try to disconnect but don't fail if it errors
        try {
          await googleSignIn.disconnect();
        } catch (e) {
          print("Non-critical error during disconnect: $e");
          // Continue even if disconnect fails
        }
      }
    } catch (e) {
      _error = 'Failed to sign out: ${e.toString()}';
      notifyListeners();
    }
  }
}
