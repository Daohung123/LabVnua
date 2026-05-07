import 'package:flutter/material.dart';

/// ========================================
/// APP THEME - Centralized Design System
/// ========================================
///
/// This file contains all design tokens for the LabVnua Student App:
/// - Color palette (primary, secondary, accents, semantic colors)
/// - Spacing system (xs to xl)
/// - Border radius presets
/// - Shadow definitions
///
/// Usage: Import this file and use AppColors.primary, AppSpacing.lg, etc.
/// Benefits: Single source of truth, easy maintenance, consistent design

/// ========================================
/// 1. COLOR SYSTEM
/// ========================================
class AppColors {
  // Primary colors - Main brand colors
  static const Color primary = Color(0xff0047A8); // Deep professional blue
  static const Color primaryLight = Color(0xff0F62CC); // Light blue variant
  static const Color primaryDark = Color(0xff003A7A); // Dark blue variant

  // Secondary/Text colors
  static const Color blueText = Color(0xff355070); // Muted blue for text
  static const Color textPrimary = Color(
    0xff111827,
  ); // Dark text (almost black)
  static const Color textSecondary = Color(0xff6B7280); // Gray text
  static const Color textMuted = Color(0xff9CA3AF); // Light gray text

  // Neutral colors - Backgrounds and surfaces
  static const Color background = Color(
    0xffF5F8FC,
  ); // Light blue-gray background
  static const Color surface = Color(0xffFFFFFF); // White surfaces/cards
  static const Color border = Color(0xffE4EAF2); // Light border color
  static const Color divider = Color(0xffE5E7EB); // Divider lines

  // Semantic colors - Status and meaning
  static const Color success = Color(0xff10B981); // Green for success
  static const Color successLight = Color(0xffD1FAE5); // Light green background
  static const Color error = Color(0xffEF4444); // Red for error
  static const Color errorLight = Color(0xffFEE2E2); // Light red background
  static const Color warning = Color(0xffF59E0B); // Amber for warning
  static const Color warningLight = Color(0xffFEF3C7); // Light amber background
  static const Color info = Color(0xff0EA5E9); // Cyan for info
  static const Color infoLight = Color(0xffCFFAFE); // Light cyan background

  // Accent colors - Feature-specific
  static const Color scheduleColor = Color(0xff0EA5E9); // Cyan for schedule
  static const Color tuitionColor = Color(0xff8B5CF6); // Purple for tuition
  static const Color scoreColor = Color(0xff10B981); // Green for scores
  static const Color materialsColor = Color(0xffF59E0B); // Amber for materials
  static const Color notificationColor = Color(
    0xff10B981,
  ); // Green for notifications

  // Overlay colors
  static const Color overlay10 = Color(0x0F000000); // 10% opacity black
  static const Color overlay20 = Color(0x33000000); // 20% opacity black
  static const Color overlay30 = Color(0x4D000000); // 30% opacity black
}

/// ========================================
/// 2. SPACING SYSTEM
/// ========================================
class AppSpacing {
  // Consistent spacing values following 4px grid
  static const double xs = 4; // Extra small - rarely used
  static const double sm = 8; // Small - internal padding in components
  static const double md = 12; // Medium - spacing between elements
  static const double lg = 16; // Large - main padding for screens
  static const double xl = 24; // Extra large - section spacing
  static const double xxl = 32; // Double extra large - hero sections

  // Common combinations
  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);

  // Horizontal & vertical specific
  static const EdgeInsets paddingH16V8 = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: sm,
  );
  static const EdgeInsets paddingH16V16 = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: lg,
  );
  static const EdgeInsets paddingH8V4 = EdgeInsets.symmetric(
    horizontal: sm,
    vertical: xs,
  );

  // Screen padding (standard for all views)
  static const EdgeInsets screenPadding = EdgeInsets.fromLTRB(lg, lg, lg, xxl);
}

/// ========================================
/// 3. BORDER RADIUS SYSTEM
/// ========================================
class AppRadius {
  // Small rounded corners - for buttons, small icons
  static const double sm = 8.0; // Slightly rounded
  // Medium rounded corners - for standard components
  static const double md = 14.0; // Standard cards and containers
  // Large rounded corners - for prominent cards
  static const double lg = 18.0; // Feature tiles and action cards
  // Extra large rounded corners - for hero sections
  static const double xl = 22.0; // Main content cards
  // Extra extra large rounded corners - for hero headers
  static const double xxl = 26.0; // Large hero sections
  // Full rounded - for pills and chips
  static const double full = 999.0; // Completely rounded

  // Convenience BorderRadius objects
  static final BorderRadius circular_sm = BorderRadius.circular(sm);
  static final BorderRadius circular_md = BorderRadius.circular(md);
  static final BorderRadius circular_lg = BorderRadius.circular(lg);
  static final BorderRadius circular_xl = BorderRadius.circular(xl);
  static final BorderRadius circular_xxl = BorderRadius.circular(xxl);
  static final BorderRadius circular_full = BorderRadius.circular(full);
}

/// ========================================
/// 4. SHADOW SYSTEM
/// ========================================
class AppShadows {
  // Light shadow - subtle elevation for cards
  static final BoxShadow light = BoxShadow(
    color: Colors.black.withOpacity(0.04),
    blurRadius: 14,
    offset: const Offset(0, 5),
  );

  // Medium shadow - more prominent elevation
  static final BoxShadow medium = BoxShadow(
    color: Colors.black.withOpacity(0.08),
    blurRadius: 18,
    offset: const Offset(0, 8),
  );

  // Hero shadow - strong elevation for hero sections
  static final BoxShadow hero = BoxShadow(
    color: AppColors.primary.withOpacity(0.25),
    blurRadius: 18,
    offset: const Offset(0, 10),
  );

  // Elevated shadow - pronounced for FAB and popovers
  static final BoxShadow elevated = BoxShadow(
    color: Colors.black.withOpacity(0.15),
    blurRadius: 24,
    offset: const Offset(0, 12),
  );

  // Collections for use with boxShadow property
  static final List<BoxShadow> lightShadow = [light];
  static final List<BoxShadow> mediumShadow = [medium];
  static final List<BoxShadow> heroShadow = [hero];
  static final List<BoxShadow> elevatedShadow = [elevated];
}

/// ========================================
/// 5. BORDER SYSTEM
/// ========================================
class AppBorders {
  // Standard border for cards and components
  static final Border cardBorder = Border.all(
    color: AppColors.border,
    width: 1.0,
  );

  // Light border for subtle divisions
  static final Border lightBorder = Border.all(
    color: AppColors.divider,
    width: 0.8,
  );

  // Color-coded borders for semantic meaning
  static final Border successBorder = Border.all(
    color: AppColors.success,
    width: 1.0,
  );

  static final Border errorBorder = Border.all(
    color: AppColors.error,
    width: 1.0,
  );
}

/// ========================================
/// 6. GRADIENT SYSTEM
/// ========================================
class AppGradients {
  // Hero header gradient - Professional blue gradient
  static const LinearGradient heroGradient = LinearGradient(
    colors: [AppColors.primary, AppColors.primaryLight, AppColors.blueText],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Subtle background gradient
  static const LinearGradient subtleGradient = LinearGradient(
    colors: [Color(0xffF0F7FF), Color(0xffF5F8FC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Success gradient
  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xff10B981), Color(0xff059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

/// ========================================
/// 7. OPACITY SYSTEM
/// ========================================
class AppOpacity {
  // Common opacity values for interactive states
  static const double hovered = 0.08; // Hover state
  static const double pressed = 0.12; // Pressed state
  static const double disabled = 0.4; // Disabled state
  static const double placeholder = 0.6; // Placeholder text

  // Background opacity variations
  static const double bg10 = 0.10; // Light background
  static const double bg12 = 0.12; // Standard background
  static const double bg14 = 0.14; // Slightly stronger background
  static const double bg18 = 0.18; // Medium background
}
