import 'package:flutter/material.dart';

import 'app_colors.dart';

export 'app_colors.dart';

/// Spacing tokens based on a 4 px grid, with 8 px as the primary rhythm.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double sm10 = 10;
  static const double md = 12;
  static const double md14 = 14;
  static const double lg = 16;
  static const double lg20 = 20;
  static const double lg22 = 22;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxl40 = 40;
  static const double xxl48 = 48;
  static const double xxl56 = 56;

  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);
  static const EdgeInsets paddingH16V8 = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: sm,
  );
  static const EdgeInsets paddingH16V16 = EdgeInsets.all(lg);
  static const EdgeInsets paddingH8V4 = EdgeInsets.symmetric(
    horizontal: sm,
    vertical: xs,
  );
  static const EdgeInsets screenPadding = EdgeInsets.fromLTRB(lg, lg, lg, xxl);
}

/// Corner radii are soft but deliberately restrained.
abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 24;
  static const double full = 999;

  static final BorderRadius circular_sm = BorderRadius.circular(sm);
  static final BorderRadius circular_md = BorderRadius.circular(md);
  static final BorderRadius circular_lg = BorderRadius.circular(lg);
  static final BorderRadius circular_xl = BorderRadius.circular(xl);
  static final BorderRadius circular_xxl = BorderRadius.circular(xxl);
  static final BorderRadius circular_full = BorderRadius.circular(full);
}

abstract final class AppShadows {
  static const BoxShadow low = BoxShadow(
    color: Color(0x0F101828),
    blurRadius: 3,
    offset: Offset(0, 1),
  );
  static const BoxShadow medium = BoxShadow(
    color: Color(0x14101828),
    blurRadius: 18,
    offset: Offset(0, 6),
  );
  static const BoxShadow overlay = BoxShadow(
    color: Color(0x24101828),
    blurRadius: 40,
    offset: Offset(0, 16),
  );

  // Backward-compatible aliases.
  static const BoxShadow light = low;
  static const BoxShadow hero = medium;
  static const BoxShadow elevated = overlay;
  static const List<BoxShadow> lightShadow = [low];
  static const List<BoxShadow> mediumShadow = [medium];
  static const List<BoxShadow> heroShadow = [medium];
  static const List<BoxShadow> elevatedShadow = [overlay];
}

abstract final class AppBorders {
  static const Border cardBorder = Border.fromBorderSide(
    BorderSide(color: AppColors.border),
  );
  static const Border lightBorder = Border.fromBorderSide(
    BorderSide(color: AppColors.divider),
  );
  static const Border successBorder = Border.fromBorderSide(
    BorderSide(color: AppColors.successBorder),
  );
  static const Border errorBorder = Border.fromBorderSide(
    BorderSide(color: AppColors.errorBorder),
  );
}

/// Gradients remain for compatibility with legacy widgets. New UI should use
/// solid surfaces; therefore these gradients are intentionally very subtle.
abstract final class AppGradients {
  static const LinearGradient heroGradient = LinearGradient(
    colors: [AppColors.primary, AppColors.primaryPressed],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient subtleGradient = LinearGradient(
    colors: [AppColors.surface, AppColors.surfaceAlt],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient successGradient = LinearGradient(
    colors: [AppColors.success, AppColors.success],
  );
}

abstract final class AppOpacity {
  static const double hovered = 0.08;
  static const double pressed = 0.12;
  static const double disabled = 0.4;
  static const double placeholder = 0.6;
  static const double bg10 = 0.10;
  static const double bg12 = 0.12;
  static const double bg14 = 0.14;
  static const double bg18 = 0.18;
}

/// Application-wide Material 3 configuration.
abstract final class AppTheme {
  static ThemeData get lightTheme => _buildLightTheme();
  static ThemeData get darkTheme => _buildDarkTheme();

  static ThemeData _buildLightTheme() {
    const colorScheme = ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primarySoft,
      onPrimaryContainer: AppColors.primaryPressed,
      secondary: AppColors.primary,
      onSecondary: AppColors.onPrimary,
      secondaryContainer: AppColors.primarySoft,
      onSecondaryContainer: AppColors.primaryPressed,
      error: AppColors.error,
      onError: AppColors.white,
      errorContainer: AppColors.errorLight,
      onErrorContainer: AppColors.error,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      outline: AppColors.border,
      outlineVariant: AppColors.divider,
      shadow: AppColors.overlay20,
      scrim: AppColors.overlay30,
    );

    return _baseTheme(colorScheme).copyWith(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.background,
      cardColor: AppColors.surface,
      dividerColor: AppColors.divider,
      textTheme: _textTheme(
        AppColors.textPrimary,
        AppColors.textSecondary,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: AppColors.transparent,
        titleTextStyle: TextStyle(
          fontSize: 20,
          height: 1.4,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        iconTheme: IconThemeData(color: AppColors.textPrimary, size: 24),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        surfaceTintColor: AppColors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shadowColor: AppColors.overlay08,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      inputDecorationTheme: _inputDecorationTheme(
        fillColor: AppColors.surface,
        textColor: AppColors.textPrimary,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textTertiary,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 68,
        elevation: 0,
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.transparent,
        indicatorColor: AppColors.primarySoft,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          return IconThemeData(
            size: 24,
            color: states.contains(WidgetState.selected)
                ? AppColors.primary
                : AppColors.textTertiary,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          return TextStyle(
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w600
                : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? AppColors.primary
                : AppColors.textTertiary,
          );
        }),
      ),
      navigationRailTheme: const NavigationRailThemeData(
        elevation: 0,
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primarySoft,
        selectedIconTheme: IconThemeData(color: AppColors.primary),
        unselectedIconTheme: IconThemeData(color: AppColors.textTertiary),
        selectedLabelTextStyle: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelTextStyle: TextStyle(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.transparent,
        modalBackgroundColor: AppColors.surface,
        modalBarrierColor: AppColors.overlay30,
        showDragHandle: true,
        dragHandleColor: AppColors.borderStrong,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          height: 1.4,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        contentTextStyle: const TextStyle(
          fontSize: 14,
          height: 1.5,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: TextStyle(
          color: AppColors.white,
          fontSize: 14,
          height: 1.4,
        ),
        actionTextColor: AppColors.primaryLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: AppColors.textSecondary,
        textColor: AppColors.textPrimary,
        contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        minVerticalPadding: AppSpacing.sm,
        minLeadingWidth: 24,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceAlt,
        selectedColor: AppColors.primarySoft,
        disabledColor: AppColors.surfaceAlt,
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        labelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        secondaryLabelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryPressed,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.primarySoft,
        circularTrackColor: AppColors.primarySoft,
      ),
    );
  }

  static ThemeData _buildDarkTheme() {
    const colorScheme = ColorScheme.dark(
      primary: AppColors.primaryLight,
      onPrimary: AppColors.darkBackground,
      primaryContainer: Color(0xFF153B63),
      onPrimaryContainer: Color(0xFFD6EAFF),
      secondary: AppColors.primaryLight,
      onSecondary: AppColors.darkBackground,
      error: Color(0xFFFF7A7E),
      onError: AppColors.darkBackground,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
      outline: AppColors.darkBorder,
      outlineVariant: AppColors.darkBorder,
    );

    return _baseTheme(colorScheme).copyWith(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      canvasColor: AppColors.darkBackground,
      cardColor: AppColors.darkSurface,
      dividerColor: AppColors.darkBorder,
      textTheme: _textTheme(
        AppColors.darkTextPrimary,
        AppColors.darkTextSecondary,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.darkTextPrimary,
        surfaceTintColor: AppColors.transparent,
        titleTextStyle: TextStyle(
          fontSize: 20,
          height: 1.4,
          fontWeight: FontWeight.w600,
          color: AppColors.darkTextPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        surfaceTintColor: AppColors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: const BorderSide(color: AppColors.darkBorder),
        ),
      ),
      inputDecorationTheme: _inputDecorationTheme(
        fillColor: AppColors.darkSurface,
        textColor: AppColors.darkTextPrimary,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: AppColors.primaryLight,
        unselectedItemColor: AppColors.darkTextSecondary,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 68,
        elevation: 0,
        backgroundColor: AppColors.darkSurface,
        surfaceTintColor: AppColors.transparent,
        indicatorColor: const Color(0xFF153B63),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          return IconThemeData(
            size: 24,
            color: states.contains(WidgetState.selected)
                ? AppColors.primaryLight
                : AppColors.darkTextSecondary,
          );
        }),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.darkSurface,
        surfaceTintColor: AppColors.transparent,
        modalBackgroundColor: AppColors.darkSurface,
        showDragHandle: true,
        dragHandleColor: AppColors.darkBorder,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkBorder,
        thickness: 1,
      ),
    );
  }

  static ThemeData _baseTheme(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      visualDensity: VisualDensity.standard,
      splashFactory: InkSparkle.splashFactory,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: _filledButtonStyle(),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: _filledButtonStyle(),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size(44, 50)),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: AppSpacing.lg20),
          ),
          elevation: const WidgetStatePropertyAll(0),
          foregroundColor: const WidgetStatePropertyAll(AppColors.textPrimary),
          side: const WidgetStatePropertyAll(
            BorderSide(color: AppColors.border),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
          textStyle: const WidgetStatePropertyAll(
            TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size(44, 44)),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.textTertiary;
            }
            return AppColors.primary;
          }),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
          textStyle: const WidgetStatePropertyAll(
            TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  static ButtonStyle _filledButtonStyle() {
    return ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(Size(44, 50)),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: AppSpacing.lg20),
      ),
      elevation: const WidgetStatePropertyAll(0),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        return states.contains(WidgetState.disabled)
            ? AppColors.textTertiary
            : AppColors.onPrimary;
      }),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.disabled;
        }
        if (states.contains(WidgetState.pressed)) {
          return AppColors.primaryPressed;
        }
        return AppColors.primary;
      }),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      textStyle: const WidgetStatePropertyAll(
        TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }

  static InputDecorationTheme _inputDecorationTheme({
    required Color fillColor,
    required Color textColor,
  }) {
    OutlineInputBorder border(Color color, [double width = 1]) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      isDense: false,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md14,
      ),
      labelStyle: TextStyle(
        color: textColor.withValues(alpha: 0.72),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      hintStyle: const TextStyle(
        color: AppColors.textTertiary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      helperStyle: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 12,
        height: 1.35,
      ),
      errorStyle: const TextStyle(
        color: AppColors.error,
        fontSize: 12,
        height: 1.35,
      ),
      border: border(AppColors.border),
      enabledBorder: border(AppColors.border),
      focusedBorder: border(AppColors.primary, 1.5),
      errorBorder: border(AppColors.error),
      focusedErrorBorder: border(AppColors.error, 1.5),
      disabledBorder: border(AppColors.divider),
    );
  }

  static TextTheme _textTheme(Color primary, Color secondary) {
    return TextTheme(
      displaySmall: TextStyle(
        fontSize: 32,
        height: 1.25,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        height: 1.34,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        height: 1.4,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      titleMedium: TextStyle(
        fontSize: 17,
        height: 1.42,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      titleSmall: TextStyle(
        fontSize: 15,
        height: 1.35,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        height: 1.5,
        fontWeight: FontWeight.w400,
        color: primary,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        height: 1.43,
        fontWeight: FontWeight.w400,
        color: primary,
      ),
      bodySmall: TextStyle(
        fontSize: 13,
        height: 1.38,
        fontWeight: FontWeight.w400,
        color: secondary,
      ),
      labelLarge: TextStyle(
        fontSize: 15,
        height: 1.34,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      labelMedium: TextStyle(
        fontSize: 13,
        height: 1.38,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      labelSmall: TextStyle(
        fontSize: 12,
        height: 1.34,
        fontWeight: FontWeight.w500,
        color: secondary,
      ),
    );
  }
}
