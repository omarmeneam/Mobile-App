import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/notification.dart';
import '../../theme/app_colors.dart';
import '../../viewmodels/notifications_viewmodel.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    // Load notifications when screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationsViewModel>().loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () {
              context.read<NotificationsViewModel>().markAllAsRead();
            },
            child: const Text('Mark all as read'),
          ),
        ],
      ),
      body: Consumer<NotificationsViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.error.isNotEmpty) {
            return Center(
              child: Text(
                viewModel.error,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (viewModel.notifications.isEmpty) {
            return const Center(child: Text('No notifications yet'));
          }

          return ListView.builder(
            itemCount: viewModel.notifications.length,
            itemBuilder: (context, index) {
              final notification = viewModel.notifications[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      notification.read
                          ? Colors.grey.shade200
                          : AppColors.primary.withOpacity(0.1),
                  child: Icon(
                    notification.icon,
                    color: notification.read ? Colors.grey : AppColors.primary,
                  ),
                ),
                title: Text(
                  notification.title,
                  style: TextStyle(
                    fontWeight:
                        notification.read ? FontWeight.normal : FontWeight.bold,
                  ),
                ),
                subtitle: Text(notification.description),
                trailing: Text(
                  notification.time,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                onTap: () {
                  if (!notification.read) {
                    viewModel.markAsRead(notification.id);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
