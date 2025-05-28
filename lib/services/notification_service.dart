import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/app_notification.dart';
import '../models/product.dart';
import '../models/notification.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _collection = 'notifications';

  // Get all notifications for the current user
  Future<List<AppNotification>> getNotifications() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return [];

      final snapshot =
          await _firestore
              .collection(_collection)
              .doc(currentUser.uid)
              .collection('items')
              .orderBy('timestamp', descending: true)
              .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return AppNotification(
          id: doc.id,
          type: data['type'] as String,
          title: data['productTitle'] as String,
          description: data['message'] as String,
          time: _getTimeAgo((data['timestamp'] as Timestamp).toDate()),
          read: data['isRead'] as bool,
          icon: _getIconForType(data['type'] as String),
        );
      }).toList();
    } catch (e) {
      print('Error getting notifications: $e');
      return [];
    }
  }

  // Mark a single notification as read
  Future<bool> markAsRead(String notificationId) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      await _firestore
          .collection(_collection)
          .doc(currentUser.uid)
          .collection('items')
          .doc(notificationId)
          .update({'isRead': true});

      return true;
    } catch (e) {
      print('Error marking notification as read: $e');
      return false;
    }
  }

  // Mark all notifications as read
  Future<bool> markAllAsRead() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      final batch = _firestore.batch();
      final snapshot =
          await _firestore
              .collection(_collection)
              .doc(currentUser.uid)
              .collection('items')
              .where('isRead', isEqualTo: false)
              .get();

      for (var doc in snapshot.docs) {
        batch.update(doc.reference, {'isRead': true});
      }

      await batch.commit();
      return true;
    } catch (e) {
      print('Error marking all notifications as read: $e');
      return false;
    }
  }

  // Get unread notification count
  Future<int> getUnreadCount() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return 0;

      final snapshot =
          await _firestore
              .collection(_collection)
              .doc(currentUser.uid)
              .collection('items')
              .where('isRead', isEqualTo: false)
              .get();

      return snapshot.docs.length;
    } catch (e) {
      print('Error getting unread count: $e');
      return 0;
    }
  }

  // Get notifications for a specific product
  Future<List<ProductNotification>> getProductNotifications(
    String productId,
  ) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        print('No current user found when getting product notifications');
        return [];
      }

      print('=== FETCHING PRODUCT NOTIFICATIONS ===');
      print(
        'Fetching notifications for product $productId for user ${currentUser.uid}',
      );

      // Get notifications from the user's notifications collection
      final notificationsRef = _firestore
          .collection('notifications')
          .doc(currentUser.uid)
          .collection('items')
          .where('productId', isEqualTo: productId);

      final snapshot = await notificationsRef.get();
      print('Found ${snapshot.docs.length} notifications in Firestore');

      if (snapshot.docs.isNotEmpty) {
        print('First notification data: ${snapshot.docs.first.data()}');
      }

      final notifications =
          snapshot.docs
              .map((doc) => ProductNotification.fromFirestore(doc))
              .toList();

      // Sort notifications by timestamp in memory
      notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      print('Returning ${notifications.length} sorted notifications');
      print('=== FETCHING PRODUCT NOTIFICATIONS END ===');

      return notifications;
    } catch (e) {
      print('Error getting product notifications: $e');
      print('Error stack trace: ${StackTrace.current}');
      return [];
    }
  }

  // Mark notifications as read for a specific product
  Future<void> markProductNotificationsAsRead(String productId) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return;

      final batch = _firestore.batch();
      final snapshot =
          await _firestore
              .collection(_collection)
              .doc(currentUser.uid)
              .collection('items')
              .where('productId', isEqualTo: productId)
              .where('isRead', isEqualTo: false)
              .get();

      for (var doc in snapshot.docs) {
        batch.update(doc.reference, {'isRead': true});
      }

      await batch.commit();
    } catch (e) {
      print('Error marking notifications as read: $e');
    }
  }

  // Send notification to users who wishlisted a product
  Future<void> notifyWishlistUsers(Product product, String type) async {
    try {
      print('=== NOTIFICATION CREATION START ===');
      print(
        'Sending notifications for product ${product.id} (${product.title})',
      );
      print('Notification type: $type');
      print('Current user: ${_auth.currentUser?.uid}');

      // Get all users who have this product in their wishlist
      final wishlistsSnapshot = await _firestore.collection('wishlists').get();
      print('Found ${wishlistsSnapshot.docs.length} wishlists to check');

      // Create notifications for each user
      for (var wishlistDoc in wishlistsSnapshot.docs) {
        print('Checking wishlist for user: ${wishlistDoc.id}');

        // Check if this user has the product in their wishlist
        final itemDoc =
            await wishlistDoc.reference
                .collection('items')
                .doc(product.id)
                .get();

        if (itemDoc.exists) {
          print('User ${wishlistDoc.id} has product in wishlist');

          // Create notification in the correct collection structure
          final notificationData = {
            'type': type,
            'productId': product.id,
            'productTitle': product.title,
            'message': _getMessageForType(type, product.title),
            'timestamp': FieldValue.serverTimestamp(),
            'isRead': false,
          };
          print('Notification data: $notificationData');

          // Create the notifications collection if it doesn't exist
          final notificationsRef = _firestore
              .collection('notifications')
              .doc(wishlistDoc.id)
              .collection('items');

          final notificationRef = await notificationsRef.add(notificationData);
          print('Notification created with ID: ${notificationRef.id}');

          // Verify the notification was created
          final createdNotification = await notificationRef.get();
          print(
            'Verification - Created notification data: ${createdNotification.data()}',
          );
        } else {
          print('User ${wishlistDoc.id} does not have product in wishlist');
        }
      }
      print('=== NOTIFICATION CREATION END ===');
    } catch (e) {
      print('Error sending notifications: $e');
      print('Error stack trace: ${StackTrace.current}');
    }
  }

  // Helper methods
  String _getMessageForType(String type, String productTitle) {
    switch (type) {
      case 'product_updated':
        return '$productTitle has been updated';
      case 'price_changed':
        return 'Price has changed for $productTitle';
      default:
        return 'Update for $productTitle';
    }
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'product_updated':
        return Icons.edit;
      case 'price_changed':
        return Icons.attach_money;
      default:
        return Icons.notifications;
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}w ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else {
      return '${(difference.inDays / 365).floor()}y ago';
    }
  }
}
