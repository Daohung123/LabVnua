import 'package:flutter/material.dart';

import 'package:aqedu/core/theme/app_components.dart';
/// User Avatar - Circular profile image with border
class UserAvatar extends StatelessWidget {
  final String imagePath;
  final double radius;
  final VoidCallback? onTap;
  final Color borderColor;
  final double borderWidth;

  const UserAvatar({
    super.key,
    required this.imagePath,
    this.radius = 20,
    this.onTap,
    this.borderColor = AppColors.white,
    this.borderWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    Widget avatar = Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.transparent,
        child: ClipOval(
          child: Image.asset(
            imagePath,
            width: radius * 2,
            height: radius * 2,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );

    if (onTap != null) {
      avatar = GestureDetector(onTap: onTap, child: avatar);
    }

    return avatar;
  }
}
