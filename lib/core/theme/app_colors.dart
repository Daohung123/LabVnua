import 'package:flutter/material.dart';

/// Single source of truth for the LabVnua / EduAI color system.
///
/// The visual direction follows DESIGN.md: a restrained iOS-inspired palette,
/// one blue interaction accent, neutral surfaces, and semantic colors only when
/// they communicate status.
abstract final class AppColors {
  // Brand and interaction.
  static const Color primary = Color(0xFF0A84FF);
  static const Color primaryPressed = Color(0xFF0066CC);
  static const Color primarySoft = Color(0xFFEAF4FF);
  static const Color primaryLight = Color(0xFF4DA3FF);
  static const Color primaryDark = primaryPressed;
  static const Color primarySurface = primarySoft;

  // AI is intentionally the only feature-specific accent.
  static const Color ai = Color(0xFF7C5CFC);
  static const Color aiSoft = Color(0xFFF1EEFF);

  // Neutral surfaces.
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFF9FAFB);
  static const Color surfaceElevated = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderStrong = Color(0xFFD0D5DD);
  static const Color divider = Color(0xFFEEF0F3);
  static const Color inputBorder = border;

  // Text and icons.
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF667085);
  static const Color textTertiary = Color(0xFF98A2B3);
  static const Color textMuted = textTertiary;
  static const Color disabled = Color(0xFFD0D5DD);
  static const Color blueText = Color(0xFF355070);

  // Content colors.
  static const Color white = Color(0xFFFFFFFF);
  static const Color white24 = Color(0x3DFFFFFF);
  static const Color white60 = Color(0x99FFFFFF);
  static const Color white70 = Color(0xB3FFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color black12 = Color(0x1F000000);
  static const Color black26 = Color(0x42000000);
  static const Color black38 = Color(0x61000000);
  static const Color black54 = Color(0x8A000000);
  static const Color black87 = Color(0xDE000000);
  static const Color transparent = Color(0x00000000);
  static const Color onPrimary = white;
  static const Color onSurface = textPrimary;

  // Semantic states.
  static const Color success = Color(0xFF22A06B);
  static const Color successLight = Color(0xFFEAF8F2);
  static const Color successBorder = Color(0xFFB7E4D1);

  static const Color warning = Color(0xFFF79009);
  static const Color warningLight = Color(0xFFFFF4E5);
  static const Color warningBorder = Color(0xFFFED7AA);

  static const Color error = Color(0xFFE5484D);
  static const Color errorLight = Color(0xFFFFF0F0);
  static const Color errorBorder = Color(0xFFF5B8BB);

  static const Color info = primary;
  static const Color infoLight = primarySoft;

  // Compatibility aliases. They intentionally resolve to the restrained
  // palette instead of creating a different color identity per feature.
  static const Color scheduleColor = primary;
  static const Color tuitionColor = primary;
  static const Color scoreColor = success;
  static const Color materialsColor = warning;
  static const Color notificationColor = primary;

  // Dark mode tokens, ready for screens that opt into system appearance.
  static const Color darkBackground = Color(0xFF0F1115);
  static const Color darkSurface = Color(0xFF171A21);
  static const Color darkSurfaceAlt = Color(0xFF1D212A);
  static const Color darkBorder = Color(0xFF2B303B);
  static const Color darkTextPrimary = Color(0xFFF5F7FA);
  static const Color darkTextSecondary = Color(0xFFA9B0BC);

  // Overlay helpers.
  static const Color overlay04 = Color(0x0A000000);
  static const Color overlay08 = Color(0x14000000);
  static const Color overlay12 = Color(0x1F000000);
  static const Color overlay20 = Color(0x33000000);
  static const Color overlay30 = Color(0x4D000000);
}
