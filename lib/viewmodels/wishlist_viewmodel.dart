import 'package:flutter/material.dart';
import '../models/product.dart';

class WishlistViewModel extends ChangeNotifier {
  List<Product> _wishlistItems = [];
  bool _isLoading = false;
  String _error = '';
  
  // Getters
  List<Product> get wishlistItems => _wishlistItems;
  bool get isLoading => _isLoading;
  String get error => _error;
  
  // Load the user's wishlist
  Future<void> loadWishlist() async {
    _isLoading = true;
    _error = '';
    notifyListeners();
    
    try {
      // This would fetch from an API in a real app
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Sample wishlist data
      _wishlistItems = [
        Product(
          id: 3,
          title: 'Ergonomic Mesh Office Chair',
          price: 129.99,
          description: 'Comfortable ergonomic desk chair, perfect for long study sessions. Black mesh back, height adjustable.',
          image: 'https://images.unsplash.com/photo-1505843490578-d7111bd4bd27?q=80&w=800',
          category: 'Furniture',
          createdAt: DateTime.now().subtract(const Duration(days: 7)),
          seller: Seller(
            id: 4,
            name: 'Sarah Kim',
            avatar: 'https://randomuser.me/api/portraits/women/44.jpg',
            rating: 4.7,
            joinedDate: 'Nov 2022',
          ),
          views: 35,
        ),
        Product(
          id: 4,
          title: 'iPhone 13 Pro 128GB Sierra Blue',
          price: 699.99,
          description: 'iPhone 13 Pro 128GB, Sierra Blue. Minor wear on the corners but perfect working condition. Includes charger.',
          image: 'https://images.unsplash.com/photo-1632661674596-df8be070a5c5?q=80&w=800',
          category: 'Electronics',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
          seller: Seller(
            id: 5,
            name: 'Michael Lee',
            avatar: 'https://randomuser.me/api/portraits/men/45.jpg',
            rating: 4.9,
            joinedDate: 'Oct 2022',
            online: true,
          ),
          views: 64,
        ),
      ];
    } catch (e) {
      _error = 'Failed to load wishlist: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Add a product to wishlist
  Future<bool> addToWishlist(Product product) async {
    try {
      // Check if already in wishlist
      if (_wishlistItems.any((item) => item.id == product.id)) {
        return true; // Already in wishlist
      }
      
      // In a real app, this would be an API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Add to local list
      _wishlistItems.add(product);
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to add to wishlist: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }
  
  // Remove a product from wishlist
  Future<bool> removeFromWishlist(int productId) async {
    try {
      // In a real app, this would be an API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Remove from local list
      _wishlistItems.removeWhere((product) => product.id == productId);
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to remove from wishlist: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }
  
  // Check if a product is in the wishlist
  bool isInWishlist(int productId) {
    return _wishlistItems.any((product) => product.id == productId);
  }
}
