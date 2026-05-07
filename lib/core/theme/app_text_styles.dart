import 'package:flutter/material.dart';
import 'app_theme.dart';

/// ========================================
/// APP TEXT STYLES - Typography System
/// ========================================
///
/// Centralized typography definitions for consistent text styling across the app.
/// Defines TextStyle constants for all text hierarchies:
/// - Display styles (hero titles, section headers)
/// - Body text (content, descriptions)
/// - Label text (buttons, chips, tags)
///
/// Usage: Instead of TextStyle(...) everywhere, use AppTextStyles.bodyLarge
/// Benefits: Consistent typography, easy brand font changes, single source of truth

class AppTextStyles {
  // ========================================
  // DISPLAY STYLES - For main headers
  // ========================================

  /// Hero title - Large prominent heading (used in hero sections)
  /// Size: 24px | Weight: Bold (800) | Color: White
  static const TextStyle heroTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: Colors.white,
    height: 1.2,
    letterSpacing: 0.3,
  );

  /// Hero subtitle - Subheading in hero sections
  /// Size: 16px | Weight: Medium (500) | Color: White with opacity
  static TextStyle heroSubtitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.white.withOpacity(0.85),
    height: 1.4,
  );

  // ========================================
  // HEADING STYLES - For section headers
  // ========================================

  /// Section title - Main content section heading
  /// Size: 18px | Weight: Bold (800) | Color: Title
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    height: 1.3,
    letterSpacing: 0.2,
  );

  /// Section subtitle - Supporting text for sections
  /// Size: 13px | Weight: Regular (500) | Color: Muted
  static const TextStyle sectionSubtitle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.35,
  );

  /// Card heading - Heading within cards
  /// Size: 16px | Weight: Bold (700) | Color: Title
  static const TextStyle cardHeading = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  // ========================================
  // BODY TEXT STYLES - Main content text
  // ========================================

  /// Body large - Main paragraph text
  /// Size: 15px | Weight: Regular (500) | Color: Primary text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  /// Body medium - Standard body text
  /// Size: 14px | Weight: Regular (500) | Color: Primary text
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  /// Body small - Smaller body text
  /// Size: 13px | Weight: Regular (500) | Color: Secondary text
  static const TextStyle bodySmall = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // ========================================
  // LABEL STYLES - For buttons, tags, chips
  // ========================================

  /// Label large - Large button/action label
  /// Size: 16px | Weight: Bold (700) | Color: Primary
  static const TextStyle labelLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  /// Label medium - Standard label
  /// Size: 14px | Weight: Bold (700) | Color: Primary
  static const TextStyle labelMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  /// Label small - Small label/chip text
  /// Size: 12px | Weight: Semibold (600) | Color: Primary
  static const TextStyle labelSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// Label tiny - Very small label
  /// Size: 11px | Weight: Semibold (600) | Color: Secondary
  static const TextStyle labelTiny = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: 0.2,
  );

  // ========================================
  // SPECIAL STYLES
  // ========================================

  /// Card value - Large number/value display
  /// Size: 20px | Weight: Bold (800) | Color: Primary
  static const TextStyle cardValue = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  /// Card subtitle - Small supporting text in cards
  /// Size: 12px | Weight: Medium (500) | Color: Secondary
  static const TextStyle cardSubtitle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  /// Chip text - For chip/badge labels
  /// Size: 12px | Weight: Semibold (600) | Color: Primary
  static TextStyle chipText = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.2,
  );

  /// Action tile title - For list items with actions
  /// Size: 15px | Weight: Bold (700) | Color: Primary
  static const TextStyle actionTileTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  /// Action tile subtitle - Supporting text for action tiles
  /// Size: 13px | Weight: Regular (500) | Color: Secondary
  static const TextStyle actionTileSubtitle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  // ========================================
  // INTERACTIVE TEXT STYLES
  // ========================================

  /// Button text - Primary button label
  /// Size: 16px | Weight: Bold (700) | Color: White
  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    letterSpacing: 0.3,
  );

  /// Link text - Clickable link text
  /// Size: 14px | Weight: Semibold (600) | Color: Primary
  static const TextStyle linkText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    decoration: TextDecoration.underline,
  );

  /// Disabled text - For disabled interactive elements
  /// Size: 14px | Weight: Medium (500) | Color: Muted
  static const TextStyle disabledText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
  );

  // ========================================
  // UTILITY METHODS for dynamic styling
  // ========================================

  /// Apply color variation to any TextStyle
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  /// Apply opacity to text color
  static TextStyle withOpacity(TextStyle style, double opacity) {
    return style.copyWith(color: style.color?.withOpacity(opacity));
  }

  /// Combine multiple styles
  static TextStyle merge(TextStyle base, TextStyle override) {
    return base.merge(override);
  }
}
