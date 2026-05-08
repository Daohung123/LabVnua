import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// ========================================
/// APP CARD - Reusable Card Component
/// ========================================
///
/// A unified card widget that standardizes the card styling across the app.
/// Provides consistent shadows, borders, border radius, and padding.
/// Replaces repeated BoxDecoration code throughout the application.
///
/// Usage:
/// ```
/// AppCard(
///   padding: AppSpacing.lg,
///   child: YourWidget(),
/// )
/// ```
///
/// Benefits:
/// - Single source of truth for card styling
/// - Easy to maintain and modify card appearance globally
/// - Reduces code duplication by ~30%
/// - Professional, consistent elevation

class AppCard extends StatelessWidget {
  /// The main content widget inside the card
  final Widget child;

  /// Internal padding within the card
  final EdgeInsets padding;

  /// Corner radius of the card
  final double borderRadius;

  /// Background color of the card
  final Color backgroundColor;

  /// Box shadow for elevation effect
  final BoxShadow? shadow;

  /// Border of the card
  final Border? border;

  /// Additional box decoration properties
  final Decoration? decoration;

  /// Optional: clips child content to border radius
  final bool clipContent;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.borderRadius = AppRadius.xl,
    this.backgroundColor = AppColors.surface,
    this.shadow,
    this.border,
    this.decoration,
    this.clipContent = true,
  });

  @override
  Widget build(BuildContext context) {
    // Combine default decoration with any overrides
    final BoxDecoration boxDecoration =
        (decoration as BoxDecoration?) ??
        BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: border ?? AppBorders.cardBorder,
          boxShadow: shadow != null ? [shadow!] : AppShadows.lightShadow,
        );

    Widget content = Container(
      padding: padding,
      decoration: boxDecoration,
      child: child,
    );

    // Optionally clip content to border radius
    if (clipContent) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: content,
      );
    }

    return content;
  }

  /// Factory constructor for hero cards (with larger shadow)
  factory AppCard.hero({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(18),
    VoidCallback? onTap,
  }) {
    return AppCard(
      padding: padding,
      borderRadius: AppRadius.xxl,
      shadow: AppShadows.hero,
      decoration: BoxDecoration(
        gradient: AppGradients.heroGradient,
        borderRadius: BorderRadius.circular(AppRadius.xxl),
      ),
      clipContent: false,
      child: onTap != null
          ? GestureDetector(onTap: onTap, child: child)
          : child,
    );
  }

  /// Factory constructor for elevated cards (stronger shadow)
  factory AppCard.elevated({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(16),
  }) {
    return AppCard(
      padding: padding,
      borderRadius: AppRadius.xl,
      shadow: AppShadows.elevated,
      child: child,
    );
  }

  /// Factory constructor for subtle cards (minimal shadow)
  factory AppCard.subtle({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(12),
  }) {
    return AppCard(
      padding: padding,
      borderRadius: AppRadius.lg,
      shadow: AppShadows.light,
      border: AppBorders.lightBorder,
      child: child,
    );
  }

  /// Factory constructor for semantic success card
  factory AppCard.success({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(14),
  }) {
    return AppCard(
      padding: padding,
      backgroundColor: AppColors.successLight,
      border: AppBorders.successBorder,
      shadow: AppShadows.light,
      child: child,
    );
  }

  /// Factory constructor for semantic error card
  factory AppCard.error({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(14),
  }) {
    return AppCard(
      padding: padding,
      backgroundColor: AppColors.errorLight,
      border: AppBorders.errorBorder,
      shadow: AppShadows.light,
      child: child,
    );
  }
}
