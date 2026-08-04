import 'package:flutter/material.dart';

import 'package:aqedu/core/theme/app_components.dart';
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
    this.iconColor = AppColors.white,
    this.iconSize = 24,
    this.tooltip = 'Thông báo',
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        splashColor: AppColors.white.withOpacity(0.15),
        highlightColor: AppColors.white.withOpacity(0.08),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
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
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(
                        color: AppColors.white.withOpacity(0.9),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.error.withOpacity(0.4),
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
                        color: AppColors.white,
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