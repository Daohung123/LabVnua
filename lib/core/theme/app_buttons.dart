import 'package:flutter/material.dart';

import 'app_text_styles.dart';
import 'app_theme.dart';

/// Unified button component. All variants preserve a minimum 44 px touch area
/// and use the restrained interaction hierarchy defined in DESIGN.md.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.onLongPress,
    this.isLoading = false,
    this.isEnabled = true,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.xl,
      vertical: AppSpacing.md,
    ),
    this.borderRadius = AppRadius.md,
    this.width,
    this.height = 50,
    this.icon,
    this.iconWidget,
    this.backgroundColor = AppColors.primary,
    this.foregroundColor = AppColors.onPrimary,
    this.textStyle,
    this.elevation = 0,
    this.borderColor,
  });

  final String label;
  final VoidCallback onPressed;
  final VoidCallback? onLongPress;
  final bool isLoading;
  final bool isEnabled;
  final EdgeInsets padding;
  final double borderRadius;
  final double? width;
  final double? height;
  final IconData? icon;
  final Widget? iconWidget;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final TextStyle? textStyle;
  final double elevation;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final effectiveForeground = foregroundColor ?? AppColors.onPrimary;
    final enabled = isEnabled && !isLoading;

    final content = AnimatedSwitcher(
      duration: const Duration(milliseconds: 120),
      child: isLoading
          ? SizedBox(
              key: const ValueKey('loading'),
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(effectiveForeground),
              ),
            )
          : Row(
              key: const ValueKey('content'),
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (iconWidget != null) ...[
                  iconWidget!,
                  const SizedBox(width: AppSpacing.sm),
                ] else if (icon != null) ...[
                  Icon(icon, size: 18, color: effectiveForeground),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: (textStyle ?? AppTextStyles.buttonText).copyWith(
                      color: effectiveForeground,
                    ),
                  ),
                ),
              ],
            ),
    );

    final button = ElevatedButton(
      onPressed: enabled ? onPressed : null,
      onLongPress: enabled ? onLongPress : null,
      style: ButtonStyle(
        minimumSize: WidgetStatePropertyAll(Size(44, height ?? 50)),
        padding: WidgetStatePropertyAll(padding),
        elevation: WidgetStatePropertyAll(elevation),
        shadowColor: const WidgetStatePropertyAll(AppColors.transparent),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.disabled)
              ? AppColors.textTertiary
              : effectiveForeground;
        }),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.disabled;
          }
          if (states.contains(WidgetState.pressed) &&
              backgroundColor == AppColors.primary) {
            return AppColors.primaryPressed;
          }
          return backgroundColor;
        }),
        side: borderColor == null
            ? null
            : WidgetStatePropertyAll(BorderSide(color: borderColor!)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
      child: content,
    );

    return SizedBox(width: width, height: height, child: button);
  }

  factory AppButton.primary({
    required String label,
    required VoidCallback onPressed,
    VoidCallback? onLongPress,
    bool isLoading = false,
    bool isEnabled = true,
    IconData? icon,
    Widget? iconWidget,
    double? width,
    double? height,
    EdgeInsets padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.xl,
      vertical: AppSpacing.md,
    ),
  }) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      onLongPress: onLongPress,
      isLoading: isLoading,
      isEnabled: isEnabled,
      icon: icon,
      iconWidget: iconWidget,
      width: width,
      height: height ?? 50,
      padding: padding,
    );
  }

  factory AppButton.secondary({
    required String label,
    required VoidCallback onPressed,
    VoidCallback? onLongPress,
    bool isLoading = false,
    bool isEnabled = true,
    IconData? icon,
    double? width,
    double? height,
  }) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      onLongPress: onLongPress,
      isLoading: isLoading,
      isEnabled: isEnabled,
      icon: icon,
      width: width,
      height: height ?? 50,
      backgroundColor: AppColors.primarySoft,
      foregroundColor: AppColors.primaryPressed,
      textStyle: AppTextStyles.labelLarge,
    );
  }

  factory AppButton.outline({
    required String label,
    required VoidCallback onPressed,
    VoidCallback? onLongPress,
    bool isLoading = false,
    bool isEnabled = true,
    IconData? icon,
    double? width,
    double? height,
    Color borderColor = AppColors.border,
  }) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      onLongPress: onLongPress,
      isLoading: isLoading,
      isEnabled: isEnabled,
      icon: icon,
      width: width,
      height: height ?? 50,
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      borderColor: borderColor,
      textStyle: AppTextStyles.labelLarge,
    );
  }

  factory AppButton.text({
    required String label,
    required VoidCallback onPressed,
    VoidCallback? onLongPress,
    bool isLoading = false,
    bool isEnabled = true,
    IconData? icon,
    Color textColor = AppColors.primary,
  }) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      onLongPress: onLongPress,
      isLoading: isLoading,
      isEnabled: isEnabled,
      icon: icon,
      height: 44,
      backgroundColor: AppColors.transparent,
      foregroundColor: textColor,
      textStyle: AppTextStyles.labelLarge,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
    );
  }

  factory AppButton.success({
    required String label,
    required VoidCallback onPressed,
    VoidCallback? onLongPress,
    bool isLoading = false,
    bool isEnabled = true,
    IconData? icon,
    double? width,
  }) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      onLongPress: onLongPress,
      isLoading: isLoading,
      isEnabled: isEnabled,
      icon: icon,
      width: width,
      backgroundColor: AppColors.success,
    );
  }

  factory AppButton.error({
    required String label,
    required VoidCallback onPressed,
    VoidCallback? onLongPress,
    bool isLoading = false,
    bool isEnabled = true,
    IconData? icon,
    double? width,
  }) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      onLongPress: onLongPress,
      isLoading: isLoading,
      isEnabled: isEnabled,
      icon: icon,
      width: width,
      backgroundColor: AppColors.error,
    );
  }

  factory AppButton.small({
    required String label,
    required VoidCallback onPressed,
    bool isLoading = false,
    bool isEnabled = true,
    IconData? icon,
  }) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      isEnabled: isEnabled,
      icon: icon,
      height: 44,
      borderRadius: AppRadius.sm,
      textStyle: AppTextStyles.labelMedium,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
    );
  }

  factory AppButton.block({
    required String label,
    required VoidCallback onPressed,
    VoidCallback? onLongPress,
    bool isLoading = false,
    bool isEnabled = true,
    IconData? icon,
    Color backgroundColor = AppColors.primary,
  }) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      onLongPress: onLongPress,
      isLoading: isLoading,
      isEnabled: isEnabled,
      icon: icon,
      width: double.infinity,
      backgroundColor: backgroundColor,
    );
  }
}

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.iconColor = AppColors.primary,
    this.backgroundColor,
    this.iconSize = 24,
    this.size = 44,
    this.tooltip,
    this.isEnabled = true,
    this.padding = const EdgeInsets.all(AppSpacing.sm),
    this.borderColor,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final Color iconColor;
  final Color? backgroundColor;
  final double iconSize;
  final double size;
  final String? tooltip;
  final bool isEnabled;
  final EdgeInsets padding;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size < 44 ? 44 : size,
      height: size < 44 ? 44 : size,
      child: IconButton(
        onPressed: isEnabled ? onPressed : null,
        tooltip: tooltip,
        padding: padding,
        icon: Icon(icon, size: iconSize),
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(iconColor),
          backgroundColor: WidgetStatePropertyAll(backgroundColor),
          side: borderColor == null
              ? null
              : WidgetStatePropertyAll(BorderSide(color: borderColor!)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
        ),
      ),
    );
  }

  factory AppIconButton.filled({
    required IconData icon,
    required VoidCallback onPressed,
    Color iconColor = AppColors.onPrimary,
    Color backgroundColor = AppColors.primary,
    double iconSize = 24,
    double size = 44,
    String? tooltip,
    bool isEnabled = true,
  }) {
    return AppIconButton(
      icon: icon,
      onPressed: onPressed,
      iconColor: iconColor,
      backgroundColor: backgroundColor,
      iconSize: iconSize,
      size: size,
      tooltip: tooltip,
      isEnabled: isEnabled,
    );
  }

  factory AppIconButton.outlined({
    required IconData icon,
    required VoidCallback onPressed,
    Color iconColor = AppColors.primary,
    double iconSize = 24,
    double size = 44,
    String? tooltip,
  }) {
    return AppIconButton(
      icon: icon,
      onPressed: onPressed,
      iconColor: iconColor,
      backgroundColor: AppColors.surface,
      borderColor: AppColors.border,
      iconSize: iconSize,
      size: size,
      tooltip: tooltip,
    );
  }
}

class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    required this.onPressed,
    this.onRemoved,
    this.leadingIcon,
    this.backgroundColor = AppColors.surfaceAlt,
    this.labelColor,
    this.isSelected = false,
    this.textStyle,
  });

  final String label;
  final VoidCallback onPressed;
  final VoidCallback? onRemoved;
  final IconData? leadingIcon;
  final Color backgroundColor;
  final Color? labelColor;
  final bool isSelected;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(
        label,
        style: (textStyle ?? AppTextStyles.labelMedium).copyWith(
          color: labelColor ??
              (isSelected ? AppColors.primaryPressed : AppColors.textPrimary),
        ),
      ),
      avatar: leadingIcon == null ? null : Icon(leadingIcon, size: 16),
      onSelected: (_) => onPressed(),
      onDeleted: onRemoved,
      selected: isSelected,
      backgroundColor: backgroundColor,
      selectedColor: AppColors.primarySoft,
      side: const BorderSide(color: AppColors.border),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
    );
  }

  factory AppChip.input({
    required String label,
    required VoidCallback onRemoved,
  }) {
    return AppChip(
      label: label,
      onPressed: () {},
      onRemoved: onRemoved,
      labelColor: AppColors.textPrimary,
    );
  }

  factory AppChip.filter({
    required String label,
    required VoidCallback onPressed,
    bool isSelected = false,
  }) {
    return AppChip(
      label: label,
      onPressed: onPressed,
      isSelected: isSelected,
    );
  }
}
