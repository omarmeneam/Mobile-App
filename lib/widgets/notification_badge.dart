import 'package:flutter/material.dart';

class NotificationBadge extends StatelessWidget {
  final int count;
  final double size;
  final Color color;

  const NotificationBadge({
    super.key,
    required this.count,
    this.size = 16,
    this.color = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    return count > 0
        ? Container(
          width: size,
          height: size,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Center(
            child: Text(
              count > 99 ? '99+' : count.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: size * 0.6,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
        : const SizedBox.shrink();
  }
}
