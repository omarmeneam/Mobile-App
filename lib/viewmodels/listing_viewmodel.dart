import 'dart:io';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../services/storage_service.dart';

class ListingViewModel extends ChangeNotifier {
  final ProductService _productService = ProductService();
  final StorageService _storageService = StorageService();
  
  bool _isLoading = false;
  String _error = '';
  List<Product> _myListings = [];
  
  // Form data
  String _title = '';
  String _description = '';
  double _price = 0.0;
  String _category = '';
  File? _image;
  String? _imageUrl;
  
  // Getters
  bool get isLoading => _isLoading;
  String get error => _error;
  List<Product> get myListings => _myListings;
  
  String get title => _title;
  String get description => _description;
  double get price => _price;
  String get category => _category;
  File? get image => _image;
  String? get imageUrl => _imageUrl;
  
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
  
  set image(File? value) {
    _image = value;
    notifyListeners();
  }
  
  // Load user's listings
  Future<void> loadMyListings() async {
    _isLoading = true;
    _error = '';
    notifyListeners();
    
    try {
      // In a real app, this would filter by the current user's ID
      _myListings = await _productService.getProducts();
    } catch (e) {
      _error = 'Failed to load listings: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Create a new listing
  Future<bool> createListing() async {
    if (_title.isEmpty || _price <= 0 || _category.isEmpty || _image == null) {
      _error = 'Please fill all required fields and add an image';
      notifyListeners();
      return false;
    }
    
    _isLoading = true;
    _error = '';
    notifyListeners();
    
    try {
      // 1. Upload image
      _imageUrl = await _storageService.uploadImage(_image!);
      
      // 2. Create product with the image URL
      final newProduct = Product(
        id: DateTime.now().millisecondsSinceEpoch, // This would be server-generated in a real app
        title: _title,
        price: _price,
        description: _description,
        image: _imageUrl!,
        category: _category,
        createdAt: DateTime.now(),
      );
      
      // 3. Save product to database
      final success = await _productService.createProduct(newProduct);
      
      if (success) {
        // Clear form data
        _resetForm();
      }
      
      return success;
    } catch (e) {
      _error = 'Failed to create listing: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Delete a listing
  Future<bool> deleteListing(int productId) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final success = await _productService.deleteProduct(productId);
      
      if (success) {
        // Remove from local list
        _myListings.removeWhere((product) => product.id == productId);
      }
      
      return success;
    } catch (e) {
      _error = 'Failed to delete listing: ${e.toString()}';
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
    _image = null;
    _imageUrl = null;
  }
}
