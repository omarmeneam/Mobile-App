import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductService _productService = ProductService();
  
  Product? _product;
  bool _isLoading = false;
  String _error = '';
  
  // Getters
  Product? get product => _product;
  bool get isLoading => _isLoading;
  String get error => _error;
  
  // Load product by id
  Future<void> loadProduct(int productId) async {
    _isLoading = true;
    _error = '';
    notifyListeners();
    
    try {
      _product = await _productService.getProductById(productId);
    } catch (e) {
      _error = 'Failed to load product: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Toggle wishlist status (would connect to a wishlist service in a real app)
  Future<bool> toggleWishlist() async {
    // Simulate adding/removing from wishlist
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }
  
  // Share product (would implement sharing functionality in a real app)
  Future<bool> shareProduct() async {
    // Simulate sharing
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }
}
