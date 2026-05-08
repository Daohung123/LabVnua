import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'app_text_styles.dart';

/// ========================================
/// APP BUTTONS - Unified Button Components
/// ========================================
///
/// Centralized button styling following Material 3 design.
/// Provides semantic button variants for different use cases.
///
/// Usage:
/// ```
/// AppButton.primary(
///   label: 'Submit',
///   onPressed: () => _handleSubmit(),
/// )
/// ```

class AppButton extends StatelessWidget {
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

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.onLongPress,
    this.isLoading = false,
    this.isEnabled = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    this.borderRadius = AppRadius.md,
    this.width,
    this.height,
    this.icon,
    this.iconWidget,
    this.backgroundColor = AppColors.primary,
    this.foregroundColor = Colors.white,
    this.textStyle,
    this.elevation = 2,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isLoading)
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                foregroundColor ?? Colors.white,
              ),
            ),
          )
        else if (iconWidget != null) ...[
          iconWidget!,
          const SizedBox(width: 8),
        ] else if (icon != null) ...[
          Icon(icon, size: 18, color: foregroundColor),
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style:
              textStyle ??
              AppTextStyles.buttonText.copyWith(color: foregroundColor),
        ),
      ],
    );

    if (width != null || height != null) {
      content = SizedBox(width: width, height: height, child: content);
    }

    return ElevatedButton(
      onPressed: isEnabled && !isLoading ? onPressed : null,
      onLongPress: isEnabled && !isLoading ? onLongPress : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        disabledBackgroundColor: AppColors.textMuted.withOpacity(0.3),
        elevation: elevation,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: content,
    );
  }

  /// Primary button - Main action
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
      horizontal: 24,
      vertical: 12,
    ),
  }) => AppButton(
    label: label,
    onPressed: onPressed,
    onLongPress: onLongPress,
    isLoading: isLoading,
    isEnabled: isEnabled,
    icon: icon,
    iconWidget: iconWidget,
    width: width,
    height: height,
    padding: padding,
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    textStyle: AppTextStyles.buttonText,
  );

  /// Secondary button - Alternative action
  factory AppButton.secondary({
    required String label,
    required VoidCallback onPressed,
    VoidCallback? onLongPress,
    bool isLoading = false,
    bool isEnabled = true,
    IconData? icon,
    double? width,
    double? height,
  }) => AppButton(
    label: label,
    onPressed: onPressed,
    onLongPress: onLongPress,
    isLoading: isLoading,
    isEnabled: isEnabled,
    icon: icon,
    width: width,
    height: height,
    backgroundColor: AppColors.surface,
    foregroundColor: AppColors.primary,
    textStyle: AppTextStyles.buttonText.copyWith(color: AppColors.primary),
    elevation: 1,
  );

  /// Outline button - Low emphasis action
  factory AppButton.outline({
    required String label,
    required VoidCallback onPressed,
    VoidCallback? onLongPress,
    bool isLoading = false,
    bool isEnabled = true,
    IconData? icon,
    double? width,
    double? height,
    Color borderColor = AppColors.primary,
  }) => AppButton(
    label: label,
    onPressed: onPressed,
    onLongPress: onLongPress,
    isLoading: isLoading,
    isEnabled: isEnabled,
    icon: icon,
    width: width,
    height: height,
    backgroundColor: Colors.transparent,
    foregroundColor: AppColors.primary,
    textStyle: AppTextStyles.buttonText.copyWith(color: AppColors.primary),
    elevation: 0,
  );

  /// Text button - Minimal emphasis
  factory AppButton.text({
    required String label,
    required VoidCallback onPressed,
    VoidCallback? onLongPress,
    bool isLoading = false,
    bool isEnabled = true,
    IconData? icon,
    Color textColor = AppColors.primary,
  }) => AppButton(
    label: label,
    onPressed: onPressed,
    onLongPress: onLongPress,
    isLoading: isLoading,
    isEnabled: isEnabled,
    icon: icon,
    backgroundColor: Colors.transparent,
    foregroundColor: textColor,
    textStyle: AppTextStyles.labelMedium.copyWith(color: textColor),
    elevation: 0,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  );

  /// Success button - Positive action (confirm, submit, etc.)
  factory AppButton.success({
    required String label,
    required VoidCallback onPressed,
    VoidCallback? onLongPress,
    bool isLoading = false,
    bool isEnabled = true,
    IconData? icon,
    double? width,
  }) => AppButton(
    label: label,
    onPressed: onPressed,
    onLongPress: onLongPress,
    isLoading: isLoading,
    isEnabled: isEnabled,
    icon: icon,
    width: width,
    backgroundColor: AppColors.success,
    foregroundColor: Colors.white,
    textStyle: AppTextStyles.buttonText,
  );

  /// Error button - Destructive action (delete, remove, etc.)
  factory AppButton.error({
    required String label,
    required VoidCallback onPressed,
    VoidCallback? onLongPress,
    bool isLoading = false,
    bool isEnabled = true,
    IconData? icon,
    double? width,
  }) => AppButton(
    label: label,
    onPressed: onPressed,
    onLongPress: onLongPress,
    isLoading: isLoading,
    isEnabled: isEnabled,
    icon: icon,
    width: width,
    backgroundColor: AppColors.error,
    foregroundColor: Colors.white,
    textStyle: AppTextStyles.buttonText,
  );

  /// Small button - For compact spaces
  factory AppButton.small({
    required String label,
    required VoidCallback onPressed,
    bool isLoading = false,
    bool isEnabled = true,
    IconData? icon,
  }) => AppButton(
    label: label,
    onPressed: onPressed,
    isLoading: isLoading,
    isEnabled: isEnabled,
    icon: icon,
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    textStyle: AppTextStyles.labelSmall.copyWith(color: Colors.white),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    borderRadius: AppRadius.sm,
  );

  /// Block button - Full width action
  factory AppButton.block({
    required String label,
    required VoidCallback onPressed,
    VoidCallback? onLongPress,
    bool isLoading = false,
    bool isEnabled = true,
    IconData? icon,
    Color backgroundColor = AppColors.primary,
  }) => AppButton(
    label: label,
    onPressed: onPressed,
    onLongPress: onLongPress,
    isLoading: isLoading,
    isEnabled: isEnabled,
    icon: icon,
    backgroundColor: backgroundColor,
    foregroundColor: Colors.white,
    textStyle: AppTextStyles.buttonText,
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
  );
}

/// ========================================
/// ICON BUTTON - Icon-only button component
/// ========================================

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color iconColor;
  final Color? backgroundColor;
  final double iconSize;
  final double size;
  final String? tooltip;
  final bool isEnabled;
  final EdgeInsets padding;

  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.iconColor = AppColors.primary,
    this.backgroundColor,
    this.iconSize = 24,
    this.size = 40,
    this.tooltip,
    this.isEnabled = true,
    this.padding = const EdgeInsets.all(8),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: IconButton(
        onPressed: isEnabled ? onPressed : null,
        icon: Icon(icon, size: iconSize, color: iconColor),
        tooltip: tooltip,
        style: IconButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: padding,
          disabledBackgroundColor: AppColors.border,
        ),
      ),
    );
  }

  /// Filled icon button with background
  factory AppIconButton.filled({
    required IconData icon,
    required VoidCallback onPressed,
    Color iconColor = Colors.white,
    Color backgroundColor = AppColors.primary,
    double iconSize = 24,
    double size = 40,
    String? tooltip,
    bool isEnabled = true,
  }) => AppIconButton(
    icon: icon,
    onPressed: onPressed,
    iconColor: iconColor,
    backgroundColor: backgroundColor,
    iconSize: iconSize,
    size: size,
    tooltip: tooltip,
    isEnabled: isEnabled,
  );

  /// Outlined icon button
  factory AppIconButton.outlined({
    required IconData icon,
    required VoidCallback onPressed,
    Color iconColor = AppColors.primary,
    double iconSize = 24,
    double size = 40,
    String? tooltip,
  }) => AppIconButton(
    icon: icon,
    onPressed: onPressed,
    iconColor: iconColor,
    backgroundColor: Colors.transparent,
    iconSize: iconSize,
    size: size,
    tooltip: tooltip,
  );
}

/// ========================================
/// CHIP BUTTON - Compact labeled button
/// ========================================

class AppChip extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final VoidCallback? onRemoved;
  final IconData? leadingIcon;
  final Color backgroundColor;
  final Color? labelColor;
  final bool isSelected;
  final TextStyle? textStyle;

  const AppChip({
    super.key,
    required this.label,
    required this.onPressed,
    this.onRemoved,
    this.leadingIcon,
    this.backgroundColor = AppColors.primaryLight,
    this.labelColor,
    this.isSelected = false,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(
        label,
        style:
            textStyle ??
            AppTextStyles.chipText.copyWith(
              color: labelColor ?? Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
      ),
      avatar: leadingIcon != null ? Icon(leadingIcon, size: 16) : null,
      onSelected: (_) => onPressed(),
      onDeleted: onRemoved,
      backgroundColor: isSelected ? AppColors.primary : backgroundColor,
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
    );
  }

  /// Input chip - Like a tag in input field
  factory AppChip.input({
    required String label,
    required VoidCallback onRemoved,
  }) => AppChip(
    label: label,
    onPressed: () {},
    onRemoved: onRemoved,
    backgroundColor: AppColors.background,
    labelColor: AppColors.textPrimary,
    textStyle: AppTextStyles.labelSmall,
  );

  /// Filter chip - For filtering options
  factory AppChip.filter({
    required String label,
    required VoidCallback onPressed,
    bool isSelected = false,
  }) => AppChip(
    label: label,
    onPressed: onPressed,
    backgroundColor: AppColors.border,
    labelColor: AppColors.textPrimary,
    isSelected: isSelected,
  );
}
