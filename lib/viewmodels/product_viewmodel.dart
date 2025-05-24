import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductService _productService = ProductService();

  Product? _product;
  List<Product> _products = [];
  bool _isLoading = false;
  String _error = '';

  // Getters
  Product? get product => _product;
  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String get error => _error;

  // Load all products
  Future<void> loadProducts() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _products = await _productService.getProducts();
    } catch (e) {
      _error = 'Failed to load products: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load product by id
  Future<void> loadProduct(String productId) async {
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

  // Load seller's products
  Future<void> loadSellerProducts(String sellerId) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _products = await _productService.getProductsBySeller(sellerId);
    } catch (e) {
      _error = 'Failed to load seller products: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create new product
  Future<String?> createProduct(Product product) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final productId = await _productService.createProduct(product);
      await loadProducts(); // Refresh the products list
      return productId;
    } catch (e) {
      _error = 'Failed to create product: ${e.toString()}';
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update product
  Future<bool> updateProduct(String id, Map<String, dynamic> data) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      await _productService.updateProduct(id, data);
      await loadProduct(id); // Refresh the product
      return true;
    } catch (e) {
      _error = 'Failed to update product: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete product
  Future<bool> deleteProduct(String id) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      await _productService.deleteProduct(id);
      _products.removeWhere((p) => p.id == id);
      return true;
    } catch (e) {
      _error = 'Failed to delete product: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Toggle product active status
  Future<bool> toggleActive(String id, bool active) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      await _productService.toggleActive(id, active);
      await loadProduct(id); // Refresh the product
      return true;
    } catch (e) {
      _error = 'Failed to toggle product status: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Increment view count
  Future<void> incrementViews(String id) async {
    try {
      await _productService.incrementViews(id);
      await loadProduct(id); // Refresh the product
    } catch (e) {
      _error = 'Failed to increment views: ${e.toString()}';
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
