import 'package:flutter/material.dart';
import '../models/notification.dart';

class NotificationService {
  // Simulate API call to fetch notifications
  Future<List<AppNotification>> getNotifications() async {
    // This would be an API call in a real app
    await Future.delayed(const Duration(milliseconds: 700));
    
    // Return dummy data for now
    return [
      AppNotification(
        id: 1,
        type: 'message',
        title: 'New Message',
        description: 'Maria sent you a message about MacBook Pro',
        time: '2 min ago',
        read: false,
        icon: Icons.message,
      ),
      AppNotification(
        id: 2,
        type: 'offer',
        title: 'New Offer',
        description: 'James made an offer on your Calculus Textbook',
        time: '1 hour ago',
        read: true,
        icon: Icons.local_offer,
      ),
      AppNotification(
        id: 3,
        type: 'sold',
        title: 'Item Sold',
        description: 'Congratulations! Your Physics Textbook has been sold',
        time: 'Yesterday',
        read: true,
        icon: Icons.check_circle,
      ),
    ];
  }
  
  Future<bool> markAsRead(int notificationId) async {
    // This would be an API call in a real app
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }
  
  Future<bool> markAllAsRead() async {
    // This would be an API call in a real app
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }
}
