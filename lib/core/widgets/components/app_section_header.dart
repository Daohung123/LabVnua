import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_text_styles.dart';

/// ========================================
/// APP SECTION HEADER - Reusable Section Header
/// ========================================
///
/// A standardized component for section headers with title and subtitle.
/// Used throughout the app to introduce content sections with consistent styling.
///
/// Usage:
/// ```
/// AppSectionHeader(
///   title: 'Thời khóa biểu',
///   subtitle: 'Theo dõi lịch học trong ngày',
/// )
/// ```
///
/// Benefits:
/// - Consistent section heading appearance
/// - Reduces duplicate code across views
/// - Easy to modify globally
/// - Handles typography automatically

class AppSectionHeader extends StatelessWidget {
  /// Main title of the section
  final String title;

  /// Optional subtitle/description
  final String? subtitle;

  /// Optional trailing widget (e.g., button, icon)
  final Widget? trailing;

  /// Padding around the header
  final EdgeInsets padding;

  /// Text color for title (default: primary)
  final Color titleColor;

  /// Text color for subtitle (default: muted)
  final Color subtitleColor;

  /// Title text style override
  final TextStyle? titleStyle;

  /// Subtitle text style override
  final TextStyle? subtitleStyle;

  /// Space between title and subtitle
  final double spaceBetween;

  const AppSectionHeader({
    Key? key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.padding = const EdgeInsets.only(left: 4, bottom: 10),
    this.titleColor = AppColors.textPrimary,
    this.subtitleColor = AppColors.textSecondary,
    this.titleStyle,
    this.subtitleStyle,
    this.spaceBetween = 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and subtitle column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  style:
                      titleStyle ??
                      AppTextStyles.sectionTitle.copyWith(color: titleColor),
                ),
                // Spacing
                SizedBox(height: spaceBetween),
                // Subtitle (if provided)
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style:
                        subtitleStyle ??
                        AppTextStyles.sectionSubtitle.copyWith(
                          color: subtitleColor,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          // Trailing widget (if provided)
          if (trailing != null) ...[const SizedBox(width: 12), trailing!],
        ],
      ),
    );
  }

  /// Factory for alternative style header (bold, minimal spacing)
  factory AppSectionHeader.compact({
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onSubtitleTap,
  }) {
    return AppSectionHeader(
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      padding: const EdgeInsets.only(bottom: 8),
      spaceBetween: 2,
      titleStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      ),
      subtitleStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      ),
    );
  }

  /// Factory for header with action button
  factory AppSectionHeader.withAction({
    required String title,
    String? subtitle,
    required String actionText,
    required VoidCallback onAction,
  }) {
    return AppSectionHeader(
      title: title,
      subtitle: subtitle,
      trailing: GestureDetector(
        onTap: onAction,
        child: Text(
          actionText,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  /// Factory for header with colored title
  factory AppSectionHeader.colored({
    required String title,
    String? subtitle,
    required Color titleColor,
    Widget? trailing,
  }) {
    return AppSectionHeader(
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      titleColor: titleColor,
    );
  }
}
