import 'package:flutter/material.dart';
import 'app_theme.dart';

/// ========================================
/// APP CONTAINERS - Reusable Container Components
/// ========================================
///
/// Provides container styles for different use cases like info boxes,
/// status indicators, action cards, and decorative containers.
///
/// Usage:
/// ```
/// AppContainer.infoBox(child: Text('Info message'))
/// AppContainer.statusBadge(status: 'active')
/// ```

class AppContainer extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final Border? border;
  final double borderRadius;
  final EdgeInsets padding;
  final List<BoxShadow>? boxShadow;
  final Decoration? decoration;
  final VoidCallback? onTap;
  final Gradient? gradient;
  final double? width;
  final double? height;

  const AppContainer({
    super.key,
    required this.child,
    this.backgroundColor = AppColors.surface,
    this.border,
    this.borderRadius = AppRadius.md,
    this.padding = const EdgeInsets.all(12),
    this.boxShadow,
    this.decoration,
    this.onTap,
    this.gradient,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final boxDecoration =
        decoration ??
        BoxDecoration(
          color: gradient != null ? null : backgroundColor,
          gradient: gradient,
          borderRadius: BorderRadius.circular(borderRadius),
          border: border,
          boxShadow: boxShadow,
        );

    Widget content = Container(
      width: width,
      height: height,
      decoration: boxDecoration,
      padding: padding,
      child: child,
    );

    if (onTap != null) {
      content = GestureDetector(onTap: onTap, child: content);
    }

    return content;
  }

  /// Info box - For informational content
  factory AppContainer.infoBox({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(14),
  }) => AppContainer(
    backgroundColor: AppColors.infoLight,
    border: Border.all(color: AppColors.info, width: 0.8),
    borderRadius: AppRadius.md,
    padding: padding,
    boxShadow: AppShadows.lightShadow,
    child: child,
  );

  /// Success box - For success/positive messages
  factory AppContainer.successBox({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(14),
  }) => AppContainer(
    backgroundColor: AppColors.successLight,
    border: Border.all(color: AppColors.success, width: 0.8),
    borderRadius: AppRadius.md,
    padding: padding,
    boxShadow: AppShadows.lightShadow,
    child: child,
  );

  /// Error box - For error/negative messages
  factory AppContainer.errorBox({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(14),
  }) => AppContainer(
    backgroundColor: AppColors.errorLight,
    border: Border.all(color: AppColors.error, width: 0.8),
    borderRadius: AppRadius.md,
    padding: padding,
    boxShadow: AppShadows.lightShadow,
    child: child,
  );

  /// Warning box - For warnings/cautions
  factory AppContainer.warningBox({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(14),
  }) => AppContainer(
    backgroundColor: AppColors.warningLight,
    border: Border.all(color: AppColors.warning, width: 0.8),
    borderRadius: AppRadius.md,
    padding: padding,
    boxShadow: AppShadows.lightShadow,
    child: child,
  );

  /// Action card - Clickable card with elevation
  factory AppContainer.actionCard({
    required Widget child,
    required VoidCallback onTap,
    EdgeInsets padding = const EdgeInsets.all(14),
    double? width,
    double? height,
  }) => AppContainer(
    backgroundColor: AppColors.surface,
    borderRadius: AppRadius.lg,
    padding: padding,
    boxShadow: AppShadows.lightShadow,
    onTap: onTap,
    width: width,
    height: height,
    child: child,
  );

  /// Gradient container - With gradient background
  factory AppContainer.gradient({
    required Widget child,
    required Gradient gradient,
    EdgeInsets padding = const EdgeInsets.all(14),
    double borderRadius = AppRadius.lg,
    List<BoxShadow>? boxShadow,
  }) => AppContainer(
    gradient: gradient,
    borderRadius: borderRadius,
    padding: padding,
    boxShadow: boxShadow,
    child: child,
  );

  /// Subtle container - Minimal styling
  factory AppContainer.subtle({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(10),
  }) => AppContainer(
    backgroundColor: AppColors.background,
    border: Border.all(color: AppColors.border, width: 0.5),
    borderRadius: AppRadius.sm,
    padding: padding,
    boxShadow: [],
    child: child,
  );

  /// Elevated container - Strong shadow for prominence
  factory AppContainer.elevated({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(14),
  }) => AppContainer(
    backgroundColor: AppColors.surface,
    borderRadius: AppRadius.xl,
    padding: padding,
    boxShadow: AppShadows.elevatedShadow,
    child: child,
  );

  /// Outlined container - Bordered without fill
  factory AppContainer.outlined({
    required Widget child,
    Color borderColor = AppColors.border,
    double borderWidth = 1.0,
    EdgeInsets padding = const EdgeInsets.all(12),
  }) => AppContainer(
    backgroundColor: Colors.transparent,
    border: Border.all(color: borderColor, width: borderWidth),
    borderRadius: AppRadius.md,
    padding: padding,
    boxShadow: [],
    child: child,
  );

  /// Transparent container - No styling
  factory AppContainer.transparent({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(0),
  }) => AppContainer(
    backgroundColor: Colors.transparent,
    padding: padding,
    boxShadow: [],
    child: child,
  );
}

/// ========================================
/// STATUS BADGE - Colored status indicator
/// ========================================

class AppStatusBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
  final EdgeInsets padding;
  final double borderRadius;

  const AppStatusBadge({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    this.borderRadius = AppRadius.full,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Active status badge
  factory AppStatusBadge.active(String label) => AppStatusBadge(
    label: label,
    backgroundColor: AppColors.success.withOpacity(0.1),
    textColor: AppColors.success,
    icon: Icons.check_circle,
  );

  /// Inactive status badge
  factory AppStatusBadge.inactive(String label) => AppStatusBadge(
    label: label,
    backgroundColor: AppColors.textMuted.withOpacity(0.1),
    textColor: AppColors.textMuted,
    icon: Icons.cancel,
  );

  /// Pending status badge
  factory AppStatusBadge.pending(String label) => AppStatusBadge(
    label: label,
    backgroundColor: AppColors.warning.withOpacity(0.1),
    textColor: AppColors.warning,
    icon: Icons.schedule,
  );

  /// Error status badge
  factory AppStatusBadge.error(String label) => AppStatusBadge(
    label: label,
    backgroundColor: AppColors.error.withOpacity(0.1),
    textColor: AppColors.error,
    icon: Icons.error,
  );
}

/// ========================================
/// DIVIDER - Custom divider component
/// ========================================

class AppDivider extends StatelessWidget {
  final Color color;
  final double height;
  final double thickness;
  final double? indent;
  final double? endIndent;
  final Axis direction;

  const AppDivider({
    super.key,
    this.color = AppColors.divider,
    this.height = 1.0,
    this.thickness = 1.0,
    this.indent,
    this.endIndent,
    this.direction = Axis.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    if (direction == Axis.horizontal) {
      return Divider(
        color: color,
        height: height,
        thickness: thickness,
        indent: indent,
        endIndent: endIndent,
      );
    }
    return VerticalDivider(
      color: color,
      width: height,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
    );
  }

  /// Subtle divider
  factory AppDivider.subtle() =>
      const AppDivider(color: AppColors.border, height: 8, thickness: 0.5);

  /// With spacing
  factory AppDivider.spaced({double spacing = 16}) =>
      AppDivider(height: spacing, color: Colors.transparent);
}

/// ========================================
/// SPACER HELPER - For consistent spacing
/// ========================================

class AppSpacer extends StatelessWidget {
  final double width;
  final double height;

  const AppSpacer.horizontal(this.width, {super.key}) : height = 0;

  const AppSpacer.vertical(this.height, {super.key}) : width = 0;

  const AppSpacer.all(double size, {super.key}) : width = size, height = size;

  const AppSpacer({super.key, this.width = 0, this.height = 0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width, height: height);
  }

  factory AppSpacer.xs() => AppSpacer.all(AppSpacing.xs);

  factory AppSpacer.sm() => AppSpacer.all(AppSpacing.sm);

  factory AppSpacer.md() => AppSpacer.all(AppSpacing.md);

  factory AppSpacer.lg() => AppSpacer.all(AppSpacing.lg);

  factory AppSpacer.xl() => AppSpacer.all(AppSpacing.xl);

  factory AppSpacer.xxl() => AppSpacer.all(AppSpacing.xxl);
}
