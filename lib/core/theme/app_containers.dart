import 'package:flutter/material.dart';

import 'app_theme.dart';

class AppContainer extends StatelessWidget {
  const AppContainer({
    super.key,
    required this.child,
    this.backgroundColor = AppColors.surface,
    this.border,
    this.borderRadius = AppRadius.md,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.boxShadow,
    this.decoration,
    this.onTap,
    this.gradient,
    this.width,
    this.height,
  });

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

  @override
  Widget build(BuildContext context) {
    final effectiveDecoration = decoration ??
        BoxDecoration(
          color: gradient == null ? backgroundColor : null,
          gradient: gradient,
          borderRadius: BorderRadius.circular(borderRadius),
          border: border,
          boxShadow: boxShadow,
        );

    final content = Container(
      width: width,
      height: height,
      decoration: effectiveDecoration,
      padding: padding,
      child: child,
    );

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

  factory AppContainer.infoBox({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(AppSpacing.md14),
  }) {
    return AppContainer(
      backgroundColor: AppColors.infoLight,
      border: Border.all(color: AppColors.primarySoft),
      padding: padding,
      child: child,
    );
  }

  factory AppContainer.successBox({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(AppSpacing.md14),
  }) {
    return AppContainer(
      backgroundColor: AppColors.successLight,
      border: Border.all(color: AppColors.successBorder),
      padding: padding,
      child: child,
    );
  }

  factory AppContainer.errorBox({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(AppSpacing.md14),
  }) {
    return AppContainer(
      backgroundColor: AppColors.errorLight,
      border: Border.all(color: AppColors.errorBorder),
      padding: padding,
      child: child,
    );
  }

  factory AppContainer.warningBox({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(AppSpacing.md14),
  }) {
    return AppContainer(
      backgroundColor: AppColors.warningLight,
      border: Border.all(color: AppColors.warningBorder),
      padding: padding,
      child: child,
    );
  }

  factory AppContainer.actionCard({
    required Widget child,
    required VoidCallback onTap,
    EdgeInsets padding = const EdgeInsets.all(AppSpacing.lg),
    double? width,
    double? height,
  }) {
    return AppContainer(
      backgroundColor: AppColors.surface,
      border: AppBorders.cardBorder,
      borderRadius: AppRadius.lg,
      padding: padding,
      boxShadow: AppShadows.lightShadow,
      onTap: onTap,
      width: width,
      height: height,
      child: child,
    );
  }

  factory AppContainer.gradient({
    required Widget child,
    required Gradient gradient,
    EdgeInsets padding = const EdgeInsets.all(AppSpacing.lg),
    double borderRadius = AppRadius.lg,
    List<BoxShadow>? boxShadow,
  }) {
    return AppContainer(
      gradient: gradient,
      borderRadius: borderRadius,
      padding: padding,
      boxShadow: boxShadow,
      child: child,
    );
  }

  factory AppContainer.subtle({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(AppSpacing.md),
  }) {
    return AppContainer(
      backgroundColor: AppColors.surfaceAlt,
      border: AppBorders.lightBorder,
      borderRadius: AppRadius.sm,
      padding: padding,
      boxShadow: const [],
      child: child,
    );
  }

  factory AppContainer.elevated({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(AppSpacing.lg),
  }) {
    return AppContainer(
      backgroundColor: AppColors.surface,
      border: AppBorders.cardBorder,
      borderRadius: AppRadius.lg,
      padding: padding,
      boxShadow: AppShadows.mediumShadow,
      child: child,
    );
  }

  factory AppContainer.outlined({
    required Widget child,
    Color borderColor = AppColors.border,
    double borderWidth = 1,
    EdgeInsets padding = const EdgeInsets.all(AppSpacing.md),
  }) {
    return AppContainer(
      backgroundColor: AppColors.transparent,
      border: Border.all(color: borderColor, width: borderWidth),
      borderRadius: AppRadius.md,
      padding: padding,
      boxShadow: const [],
      child: child,
    );
  }

  factory AppContainer.transparent({
    required Widget child,
    EdgeInsets padding = EdgeInsets.zero,
  }) {
    return AppContainer(
      backgroundColor: AppColors.transparent,
      padding: padding,
      boxShadow: const [],
      child: child,
    );
  }
}

class AppStatusBadge extends StatelessWidget {
  const AppStatusBadge({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.sm10,
      vertical: AppSpacing.xs,
    ),
    this.borderRadius = AppRadius.sm,
  });

  final String label;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
  final EdgeInsets padding;
  final double borderRadius;

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
            const SizedBox(width: AppSpacing.xs),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: textColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  factory AppStatusBadge.active(String label) => AppStatusBadge(
        label: label,
        backgroundColor: AppColors.successLight,
        textColor: AppColors.success,
        icon: Icons.check_circle_outline_rounded,
      );

  factory AppStatusBadge.inactive(String label) => AppStatusBadge(
        label: label,
        backgroundColor: AppColors.surfaceAlt,
        textColor: AppColors.textSecondary,
        icon: Icons.remove_circle_outline_rounded,
      );

  factory AppStatusBadge.pending(String label) => AppStatusBadge(
        label: label,
        backgroundColor: AppColors.warningLight,
        textColor: AppColors.warning,
        icon: Icons.schedule_rounded,
      );

  factory AppStatusBadge.error(String label) => AppStatusBadge(
        label: label,
        backgroundColor: AppColors.errorLight,
        textColor: AppColors.error,
        icon: Icons.error_outline_rounded,
      );
}

class AppDivider extends StatelessWidget {
  const AppDivider({
    super.key,
    this.color = AppColors.divider,
    this.height = 1,
    this.thickness = 1,
    this.indent,
    this.endIndent,
    this.direction = Axis.horizontal,
  });

  final Color color;
  final double height;
  final double thickness;
  final double? indent;
  final double? endIndent;
  final Axis direction;

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

  factory AppDivider.subtle() => const AppDivider(
        color: AppColors.divider,
        height: AppSpacing.sm,
      );

  factory AppDivider.spaced({double spacing = AppSpacing.lg}) => AppDivider(
        height: spacing,
        color: AppColors.transparent,
      );
}

class AppSpacer extends StatelessWidget {
  const AppSpacer.horizontal(this.width, {super.key}) : height = 0;
  const AppSpacer.vertical(this.height, {super.key}) : width = 0;
  const AppSpacer.all(double size, {super.key}) : width = size, height = size;
  const AppSpacer({super.key, this.width = 0, this.height = 0});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) => SizedBox(width: width, height: height);

  factory AppSpacer.xs() => const AppSpacer.all(AppSpacing.xs);
  factory AppSpacer.sm() => const AppSpacer.all(AppSpacing.sm);
  factory AppSpacer.md() => const AppSpacer.all(AppSpacing.md);
  factory AppSpacer.lg() => const AppSpacer.all(AppSpacing.lg);
  factory AppSpacer.xl() => const AppSpacer.all(AppSpacing.xl);
  factory AppSpacer.xxl() => const AppSpacer.all(AppSpacing.xxl);
}
