import 'package:flutter/material.dart';
import '../models/notification.dart';
import '../services/notification_service.dart';

class NotificationsViewModel extends ChangeNotifier {
  final NotificationService _notificationService = NotificationService();

  List<AppNotification> _notifications = [];
  bool _isLoading = false;
  String _error = '';

  // Getters
  List<AppNotification> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String get error => _error;
  int get unreadCount =>
      _notifications.where((notification) => !notification.read).length;

  // Load all notifications
  Future<void> loadNotifications() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _notifications = await _notificationService.getNotifications();
    } catch (e) {
      _error = 'Failed to load notifications: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Mark a notification as read
  Future<bool> markAsRead(String notificationId) async {
    try {
      final success = await _notificationService.markAsRead(notificationId);

      if (success) {
        // Update local notification
        final index = _notifications.indexWhere(
          (notification) => notification.id == notificationId,
        );
        if (index != -1) {
          final updatedNotification = AppNotification(
            id: _notifications[index].id,
            type: _notifications[index].type,
            title: _notifications[index].title,
            description: _notifications[index].description,
            time: _notifications[index].time,
            read: true,
            icon: _notifications[index].icon,
          );

          _notifications[index] = updatedNotification;
          notifyListeners();
        }
      }

      return success;
    } catch (e) {
      _error = 'Failed to mark notification as read: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  // Mark all notifications as read
  Future<bool> markAllAsRead() async {
    try {
      final success = await _notificationService.markAllAsRead();

      if (success) {
        // Update all local notifications
        _notifications =
            _notifications
                .map(
                  (notification) => AppNotification(
                    id: notification.id,
                    type: notification.type,
                    title: notification.title,
                    description: notification.description,
                    time: notification.time,
                    read: true,
                    icon: notification.icon,
                  ),
                )
                .toList();

        notifyListeners();
      }

      return success;
    } catch (e) {
      _error = 'Failed to mark all notifications as read: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }
}
