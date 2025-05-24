import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class HomeViewModel extends ChangeNotifier {
  final ProductService _productService = ProductService();

  List<Product> _products = [];
  bool _isLoading = false;
  String _error = '';

  // Getters
  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String get error => _error;

  // Initialize and load products
  Future<void> loadProducts() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      // Get all active products
      _products = await _productService.getProducts();
      // Filter out inactive products
      _products = _products.where((product) => product.active).toList();
    } catch (e) {
      _error = 'Failed to load products: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Filter products by category
  List<Product> getProductsByCategory(String category) {
    if (category == 'All') {
      return _products;
    }
    return _products.where((product) => product.category == category).toList();
  }

  // Search products by query
  List<Product> searchProducts(String query) {
    if (query.isEmpty) return _products;

    final queryLower = query.toLowerCase();
    return _products
        .where(
          (product) =>
              product.title.toLowerCase().contains(queryLower) ||
              product.description.toLowerCase().contains(queryLower) ||
              product.category.toLowerCase().contains(queryLower),
        )
        .toList();
  }
}
