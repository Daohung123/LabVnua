import 'package:flutter/material.dart';

import 'app_theme.dart';

/// Typography tokens from DESIGN.md.
abstract final class AppTextStyles {
  static const TextStyle display = TextStyle(
    fontSize: 32,
    height: 1.25,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
  static const TextStyle titleLarge = TextStyle(
    fontSize: 24,
    height: 1.34,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
  static const TextStyle titleMedium = TextStyle(
    fontSize: 20,
    height: 1.4,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static const TextStyle titleSmall = TextStyle(
    fontSize: 17,
    height: 1.42,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    height: 1.5,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    height: 1.43,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );
  static const TextStyle bodySmall = TextStyle(
    fontSize: 13,
    height: 1.38,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
  static const TextStyle labelLarge = TextStyle(
    fontSize: 15,
    height: 1.34,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static const TextStyle labelMedium = TextStyle(
    fontSize: 13,
    height: 1.38,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static const TextStyle labelSmall = TextStyle(
    fontSize: 12,
    height: 1.34,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    height: 1.34,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // Compatibility names used by the current feature code.
  static const TextStyle heroTitle = titleLarge;
  static const TextStyle heroSubtitle = TextStyle(
    fontSize: 15,
    height: 1.45,
    fontWeight: FontWeight.w500,
    color: AppColors.onPrimary,
  );
  static const TextStyle sectionTitle = titleSmall;
  static const TextStyle sectionSubtitle = bodySmall;
  static const TextStyle cardHeading = titleSmall;
  static const TextStyle cardValue = titleMedium;
  static const TextStyle cardSubtitle = caption;
  static const TextStyle chipText = TextStyle(
    fontSize: 12,
    height: 1.34,
    fontWeight: FontWeight.w600,
    color: AppColors.onPrimary,
  );
  static const TextStyle actionTileTitle = labelLarge;
  static const TextStyle actionTileSubtitle = bodySmall;
  static const TextStyle buttonText = TextStyle(
    fontSize: 15,
    height: 1.34,
    fontWeight: FontWeight.w600,
    color: AppColors.onPrimary,
  );
  static const TextStyle linkText = TextStyle(
    fontSize: 14,
    height: 1.43,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );
  static const TextStyle disabledText = TextStyle(
    fontSize: 14,
    height: 1.43,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
  );
  static const TextStyle labelTiny = caption;

  static TextStyle withColor(TextStyle style, Color color) =>
      style.copyWith(color: color);

  static TextStyle withOpacity(TextStyle style, double opacity) =>
      style.copyWith(color: style.color?.withValues(alpha: opacity));

  static TextStyle merge(TextStyle base, TextStyle override) =>
      base.merge(override);
}
