import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

/// Standard surface component. Default cards use a light border and only the
/// lowest elevation, keeping the interface calm and content-led.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.borderRadius = AppRadius.lg,
    this.backgroundColor = AppColors.surface,
    this.shadow,
    this.border,
    this.decoration,
    this.clipContent = true,
    this.onTap,
  });

  final Widget child;
  final EdgeInsets padding;
  final double borderRadius;
  final Color backgroundColor;
  final BoxShadow? shadow;
  final Border? border;
  final Decoration? decoration;
  final bool clipContent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final effectiveDecoration = decoration ??
        BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: border ?? AppBorders.cardBorder,
          boxShadow: shadow == null ? const [] : [shadow!],
        );

    Widget content = Container(
      padding: padding,
      decoration: effectiveDecoration,
      child: child,
    );

    if (clipContent) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: content,
      );
    }

    if (onTap == null) return content;

    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: content,
      ),
    );
  }

  factory AppCard.hero({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(AppSpacing.lg20),
    VoidCallback? onTap,
  }) {
    return AppCard(
      padding: padding,
      borderRadius: AppRadius.lg,
      backgroundColor: AppColors.primary,
      border: const Border(),
      shadow: AppShadows.medium,
      clipContent: true,
      onTap: onTap,
      child: child,
    );
  }

  factory AppCard.elevated({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(AppSpacing.lg),
  }) {
    return AppCard(
      padding: padding,
      shadow: AppShadows.medium,
      child: child,
    );
  }

  factory AppCard.subtle({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(AppSpacing.md),
  }) {
    return AppCard(
      padding: padding,
      backgroundColor: AppColors.surfaceAlt,
      border: AppBorders.lightBorder,
      shadow: null,
      child: child,
    );
  }

  factory AppCard.success({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(AppSpacing.md14),
  }) {
    return AppCard(
      padding: padding,
      backgroundColor: AppColors.successLight,
      border: AppBorders.successBorder,
      shadow: null,
      child: child,
    );
  }

  factory AppCard.error({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(AppSpacing.md14),
  }) {
    return AppCard(
      padding: padding,
      backgroundColor: AppColors.errorLight,
      border: AppBorders.errorBorder,
      shadow: null,
      child: child,
    );
  }
}
