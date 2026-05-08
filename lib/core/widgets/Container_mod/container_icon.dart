import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Icon Container - Decorative container with icon inside
class IconContainer extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final double iconSize;
  final double containerSize;
  final double borderRadius;
  final VoidCallback? onTap;

  const IconContainer({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    this.iconSize = 24,
    this.containerSize = 48,
    this.borderRadius = AppRadius.md,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      width: containerSize,
      height: containerSize,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Center(
        child: Icon(icon, color: iconColor, size: iconSize),
      ),
    );

    if (onTap != null) {
      content = GestureDetector(onTap: onTap, child: content);
    }

    return content;
  }

  /// Circular icon container
  factory IconContainer.circular({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    double iconSize = 24,
    double containerSize = 48,
    VoidCallback? onTap,
  }) => IconContainer(
    icon: icon,
    iconColor: iconColor,
    backgroundColor: backgroundColor,
    iconSize: iconSize,
    containerSize: containerSize,
    borderRadius: containerSize / 2,
    onTap: onTap,
  );

  /// Rounded icon container with app theme colors
  factory IconContainer.themed({
    required IconData icon,
    Color iconColor = Colors.white,
    Color backgroundColor = AppColors.primary,
    double size = 48,
    VoidCallback? onTap,
  }) => IconContainer(
    icon: icon,
    iconColor: iconColor,
    backgroundColor: backgroundColor,
    containerSize: size,
    borderRadius: AppRadius.md,
    onTap: onTap,
  );
}
