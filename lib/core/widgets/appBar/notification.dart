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
    this.iconSize = 24,
    this.tooltip = 'Thông báo',
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        splashColor: Colors.white.withOpacity(0.15),
        highlightColor: Colors.white.withOpacity(0.08),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                notificationCount > 0
                    ? Icons.notifications_active
                    : Icons.notifications_outlined,
                size: iconSize,
                color: iconColor,
              ),
              if (notificationCount > 0)
                Positioned(
                  right: -6,
                  top: -6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.shade400,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.9),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.4),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      notificationCount > 99 ? '99+' : '$notificationCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}