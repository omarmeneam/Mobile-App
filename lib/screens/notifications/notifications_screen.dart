import 'package:flutter/material.dart';
import '../../models/notification.dart';
import '../../theme/app_colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Mock notifications data
  final List<AppNotification> _notifications = [
    AppNotification(
      id: 1,
      type: 'message',
      title: 'New message from Jamie Smith',
      description: 'Is this still available?',
      time: '10 minutes ago',
      read: false,
      icon: Icons.message,
    ),
    AppNotification(
      id: 2,
      type: 'wishlist',
      title: 'Item added to wishlist',
      description: 'Scientific Calculator has been added to your wishlist',
      time: '2 hours ago',
      read: true,
      icon: Icons.favorite,
    ),
    AppNotification(
      id: 3,
      type: 'price',
      title: 'Price drop alert',
      description: 'Desk Lamp - Adjustable LED price dropped from \$30 to \$25',
      time: 'Yesterday',
      read: true,
      icon: Icons.attach_money,
    ),
    AppNotification(
      id: 4,
      type: 'alert',
      title: 'Safety alert',
      description: 'Important safety tips for meeting with buyers and sellers',
      time: '3 days ago',
      read: true,
      icon: Icons.warning,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body:
          _notifications.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_none,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No notifications',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'When you receive notifications about messages, wishlist updates, or other activities, they\'ll appear here',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ],
                ),
              )
              : ListView.separated(
                itemCount: _notifications.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final notification = _notifications[index];

                  return Container(
                    color:
                        notification.read
                            ? null
                            : AppColors.accent.withOpacity(0.1),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getIconColor(
                          notification.type,
                        ).withOpacity(0.2),
                        child: Icon(
                          notification.icon,
                          color: _getIconColor(notification.type),
                          size: 20,
                        ),
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontWeight:
                                    notification.read
                                        ? FontWeight.normal
                                        : FontWeight.bold,
                              ),
                            ),
                          ),
                          if (!notification.read)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'New',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(notification.description),
                          const SizedBox(height: 4),
                          Text(
                            notification.time,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      onTap: () {
                        // Mark as read and navigate to relevant screen
                        setState(() {
                          _notifications[index] = AppNotification(
                            id: notification.id,
                            type: notification.type,
                            title: notification.title,
                            description: notification.description,
                            time: notification.time,
                            read: true,
                            icon: notification.icon,
                          );
                        });

                        // Navigate based on notification type
                        switch (notification.type) {
                          case 'message':
                            Navigator.pushNamed(context, '/messages');
                            break;
                          case 'wishlist':
                            Navigator.pushNamed(context, '/wishlist');
                            break;
                          case 'price':
                          case 'alert':
                            // Show details in a dialog
                            showDialog(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: Text(notification.title),
                                    content: Text(notification.description),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Close'),
                                      ),
                                    ],
                                  ),
                            );
                            break;
                        }
                      },
                    ),
                  );
                },
              ),
    );
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'message':
        return AppColors.primary;
      case 'wishlist':
        return Colors.red;
      case 'price':
        return AppColors.secondary;
      case 'alert':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
