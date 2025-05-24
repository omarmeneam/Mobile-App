import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'notifications';

  Future<List<AppNotification>> getNotifications() async {
    try {
      // TODO: Get current user ID from auth service
      const currentUserId = 'current_user_id';

      final snapshot =
          await _firestore
              .collection(_collection)
              .where('userId', isEqualTo: currentUserId)
              .orderBy('timestamp', descending: true)
              .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return AppNotification(
          id: doc.id,
          type: data['type'] as String,
          title: data['title'] as String,
          description: data['description'] as String,
          time: _getTimeAgo((data['timestamp'] as Timestamp).toDate()),
          read: data['read'] as bool,
          icon: _getIconForType(data['type'] as String),
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to get notifications: $e');
    }
  }

  Future<bool> markAsRead(String notificationId) async {
    try {
      await _firestore.collection(_collection).doc(notificationId).update({
        'read': true,
      });
      return true;
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  Future<bool> markAllAsRead() async {
    try {
      // TODO: Get current user ID from auth service
      const currentUserId = 'current_user_id';

      final batch = _firestore.batch();
      final snapshot =
          await _firestore
              .collection(_collection)
              .where('userId', isEqualTo: currentUserId)
              .where('read', isEqualTo: false)
              .get();

      for (var doc in snapshot.docs) {
        batch.update(doc.reference, {'read': true});
      }

      await batch.commit();
      return true;
    } catch (e) {
      throw Exception('Failed to mark all notifications as read: $e');
    }
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'message':
        return Icons.message;
      case 'offer':
        return Icons.local_offer;
      case 'sold':
        return Icons.check_circle;
      case 'wishlist':
        return Icons.favorite;
      case 'price':
        return Icons.attach_money;
      case 'alert':
        return Icons.warning;
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
