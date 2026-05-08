import 'package:flutter/material.dart';

/// Notification Button - Icon button with badge for notification count
class NotificationButton extends StatelessWidget {
  final VoidCallback onPressed;
  final int notificationCount;
  final Color iconColor;
  final double iconSize;
  final String tooltip;

  const NotificationButton({
    super.key,
    required this.onPressed,
    this.notificationCount = 0,
    this.iconColor = Colors.white,
    this.iconSize = 28,
    this.tooltip = 'Thông báo',
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(Icons.notifications_active_outlined),
          iconSize: iconSize,
          color: iconColor,
          tooltip: tooltip,
        ),
        if (notificationCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                notificationCount > 99 ? '99+' : '$notificationCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
