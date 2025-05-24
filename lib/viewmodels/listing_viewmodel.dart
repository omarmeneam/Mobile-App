import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../services/storage_service.dart';

class ListingViewModel extends ChangeNotifier {
  final ProductService _productService = ProductService();
  final StorageService _storageService = StorageService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  String _error = '';
  List<Product> _myListings = [];

  // Form data
  String _title = '';
  String _description = '';
  double _price = 0.0;
  String _category = '';
  String _condition = '';
  List<String> _imageUrls = [];

  // Getters
  bool get isLoading => _isLoading;
  String get error => _error;
  List<Product> get myListings => _myListings;

  String get title => _title;
  String get description => _description;
  double get price => _price;
  String get category => _category;
  String get condition => _condition;
  List<String> get imageUrls => _imageUrls;

  // Setters
  set title(String value) {
    _title = value;
    notifyListeners();
  }

  set description(String value) {
    _description = value;
    notifyListeners();
  }

  set price(double value) {
    _price = value;
    notifyListeners();
  }

  set category(String value) {
    _category = value;
    notifyListeners();
  }

  set condition(String value) {
    _condition = value;
    notifyListeners();
  }

  set imageUrls(List<String> value) {
    _imageUrls = value;
    notifyListeners();
  }

  // Load user's listings
  Future<void> loadMyListings() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }
      _myListings = await _productService.getProductsBySeller(currentUser.uid);
    } catch (e) {
      _error = 'Failed to load listings: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create a new listing
  Future<bool> createListing() async {
    if (_title.isEmpty ||
        _price <= 0 ||
        _category.isEmpty ||
        _imageUrls.isEmpty) {
      _error = 'Please fill all required fields and add at least one image';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Create product with the image URLs
      final newProduct = Product(
        id: '', // Will be set by Firestore
        title: _title,
        price: _price,
        description: _description,
        image: _imageUrls.first, // Use first image as primary
        images: _imageUrls, // Store all images
        category: _category,
        condition: _condition,
        createdAt: DateTime.now(),
        sellerId: currentUser.uid,
        active: true,
        views: 0,
      );

      // Save product to database
      final productId = await _productService.createProduct(newProduct);
      if (productId != null) {
        // Clear form data
        _resetForm();
        return true;
      }
      return false;
    } catch (e) {
      _error = 'Failed to create listing: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete a listing
  Future<bool> deleteListing(String productId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _productService.deleteProduct(productId);
      // Remove from local list
      _myListings.removeWhere((product) => product.id == productId);
      return true;
    } catch (e) {
      _error = 'Failed to delete listing: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Toggle listing active status
  Future<bool> toggleActive(String productId, bool active) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _productService.toggleActive(productId, active);
      // Update local list
      final index = _myListings.indexWhere(
        (product) => product.id == productId,
      );
      if (index != -1) {
        final product = _myListings[index];
        _myListings[index] = Product(
          id: product.id,
          title: product.title,
          price: product.price,
          description: product.description,
          image: product.image,
          images: product.images,
          category: product.category,
          condition: product.condition,
          createdAt: product.createdAt,
          sellerId: product.sellerId,
          active: active,
          views: product.views,
        );
      }
      return true;
    } catch (e) {
      _error = 'Failed to toggle listing status: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Reset form data
  void _resetForm() {
    _title = '';
    _description = '';
    _price = 0.0;
    _category = '';
    _condition = '';
    _imageUrls = [];
    notifyListeners();
  }

  // Create a new product
  Future<String?> createProduct(Product product) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final productId = await _productService.createProduct(product);
      if (productId != null) {
        // Add to local list
        _myListings.add(product);
        notifyListeners();
      }
      return productId;
    } catch (e) {
      _error = 'Failed to create product: ${e.toString()}';
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
