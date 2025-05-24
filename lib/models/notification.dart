import 'package:flutter/material.dart' show IconData;

class AppNotification {
  final String id;
  final String type;
  final String title;
  final String description;
  final String time;
  final bool read;
  final IconData icon;

  AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.time,
    required this.read,
    required this.icon,
  });
}
