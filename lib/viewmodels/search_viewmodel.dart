import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class SearchViewModel extends ChangeNotifier {
  final ProductService _productService = ProductService();

  List<Product> _allProducts = [];
  List<Product> _searchResults = [];
  bool _isLoading = false;
  String _error = '';
  String _searchQuery = '';

  // Getters
  List<Product> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String get error => _error;
  String get searchQuery => _searchQuery;

  // Set search query
  set searchQuery(String value) {
    _searchQuery = value;
    _searchProducts();
    notifyListeners();
  }

  // Load all products initially
  Future<void> loadProducts() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _allProducts = await _productService.getProducts();
      _searchResults = List.from(_allProducts);
    } catch (e) {
      _error = 'Failed to load products: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Filter products based on search query
  void _searchProducts() {
    if (_searchQuery.isEmpty) {
      _searchResults = List.from(_allProducts);
      return;
    }

    final query = _searchQuery.toLowerCase();
    _searchResults =
        _allProducts
            .where(
              (product) =>
                  product.title.toLowerCase().contains(query) ||
                  product.description.toLowerCase().contains(query) ||
                  product.category.toLowerCase().contains(query),
            )
            .toList();
  }

  // Filter products by category
  void filterByCategory(String category) {
    if (category.isEmpty) {
      _searchResults = List.from(_allProducts);
    } else {
      _searchResults =
          _allProducts
              .where(
                (product) =>
                    product.category.toLowerCase() == category.toLowerCase(),
              )
              .toList();
    }
    notifyListeners();
  }

  // Sort results by price (ascending or descending)
  void sortByPrice(bool ascending) {
    _searchResults.sort(
      (a, b) =>
          ascending ? a.price.compareTo(b.price) : b.price.compareTo(a.price),
    );
    notifyListeners();
  }

  // Sort results by newest first
  void sortByNewest() {
    _searchResults.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    notifyListeners();
  }

  // Reset all filters and sorting
  void resetFilters() {
    _searchQuery = '';
    _searchResults = List.from(_allProducts);
    notifyListeners();
  }
}
