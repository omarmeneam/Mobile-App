import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';

class WishlistViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _collection = 'wishlists';

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
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final snapshot =
          await _firestore
              .collection(_collection)
              .doc(currentUser.uid)
              .collection('items')
              .get();

      final List<Product?> products = await Future.wait(
        snapshot.docs.map((doc) async {
          final productData = doc.data();
          final productDoc =
              await _firestore
                  .collection('products')
                  .doc(productData['productId'])
                  .get();

          // Skip if product doesn't exist or is inactive
          if (!productDoc.exists || !(productDoc.data()?['active'] ?? false)) {
            // Remove from wishlist if product is deleted or inactive
            await doc.reference.delete();
            return null;
          }

          return Product.fromMap(productDoc.id, productDoc.data()!);
        }),
      );

      // Remove null values (deleted/inactive products)
      _wishlistItems =
          products.where((item) => item != null).cast<Product>().toList();
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
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Check if already in wishlist
      if (_wishlistItems.any((item) => item.id == product.id)) {
        return true; // Already in wishlist
      }

      await _firestore
          .collection(_collection)
          .doc(currentUser.uid)
          .collection('items')
          .doc(product.id)
          .set({
            'productId': product.id,
            'addedAt': FieldValue.serverTimestamp(),
          });

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
  Future<bool> removeFromWishlist(String productId) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      await _firestore
          .collection(_collection)
          .doc(currentUser.uid)
          .collection('items')
          .doc(productId)
          .delete();

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
  bool isInWishlist(String productId) {
    return _wishlistItems.any((product) => product.id == productId);
  }
}
