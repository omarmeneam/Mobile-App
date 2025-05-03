import 'dart:io';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/storage_service.dart';

class ProfileViewModel extends ChangeNotifier {
  final StorageService _storageService = StorageService();
  
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
      // This would fetch the user from a user service in a real app
      await Future.delayed(const Duration(milliseconds: 800));
      
      _user = User(
        id: 1,
        name: 'John Doe',
        avatar: 'assets/images/avatars/john.jpg',
        email: 'john.doe@university.edu',
        bio: 'CS Major, Class of 2025. Interested in mobile app development and AI.',
        phone: '(555) 123-4567',
        joinedDate: 'Jan 2023',
        rating: 4.9,
        reviewCount: 15,
      );
      
      _name = _user!.name;
      _email = _user!.email;
      _bio = _user!.bio;
      _phone = _user!.phone;
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
      
      // In a real app, this would make an API call to update the user profile
      await Future.delayed(const Duration(seconds: 1));
      
      // Update local user object
      _user = User(
        id: _user!.id,
        name: _name,
        avatar: avatarUrl,
        email: _email,
        bio: _bio,
        phone: _phone,
        joinedDate: _user!.joinedDate,
        rating: _user!.rating,
        reviewCount: _user!.reviewCount,
        online: _user!.online,
      );
      
      return true;
    } catch (e) {
      _error = 'Failed to update profile: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
