import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'app_text_styles.dart';

/// ========================================
/// APP TEXT WIDGETS - Reusable Text Components
/// ========================================
///
/// Semantic text components following the app's typography system.
/// Use these instead of raw Text() widgets to maintain consistency.
///
/// Usage:
/// ```
/// AppText.heroTitle('Welcome back!')
/// AppText.bodyText('Your schedule for today...')
/// ```

class AppText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow overflow;
  final Color? color;
  final TextDecoration? decoration;

  const AppText(
    this.text, {
    super.key,
    this.style = AppTextStyles.bodyMedium,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow = TextOverflow.clip,
    this.color,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle finalStyle = style;
    if (color != null) {
      finalStyle = finalStyle.copyWith(color: color);
    }
    if (decoration != null) {
      finalStyle = finalStyle.copyWith(decoration: decoration);
    }

    return Text(
      text,
      style: finalStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  /// Hero title - Large prominent heading (24px, bold)
  factory AppText.heroTitle(
    String text, {
    TextAlign textAlign = TextAlign.start,
    Color? color,
    int? maxLines,
  }) => AppText(
    text,
    style: AppTextStyles.heroTitle.copyWith(color: color),
    textAlign: textAlign,
    maxLines: maxLines,
  );

  /// Hero subtitle - Subheading in hero sections (16px, medium)
  factory AppText.heroSubtitle(
    String text, {
    TextAlign textAlign = TextAlign.start,
    Color? color,
    int? maxLines,
  }) => AppText(
    text,
    style: AppTextStyles.heroSubtitle.copyWith(color: color),
    textAlign: textAlign,
    maxLines: maxLines,
  );

  /// Section title - Main content section heading (18px, bold)
  factory AppText.sectionTitle(
    String text, {
    TextAlign textAlign = TextAlign.start,
    Color? color,
    int? maxLines,
  }) => AppText(
    text,
    style: AppTextStyles.sectionTitle.copyWith(color: color),
    textAlign: textAlign,
    maxLines: maxLines,
  );

  /// Section subtitle - Supporting text for sections (13px, regular)
  factory AppText.sectionSubtitle(
    String text, {
    TextAlign textAlign = TextAlign.start,
    Color? color,
    int? maxLines,
  }) => AppText(
    text,
    style: AppTextStyles.sectionSubtitle.copyWith(color: color),
    textAlign: textAlign,
    maxLines: maxLines,
  );

  /// Card heading - Heading within cards (16px, bold)
  factory AppText.cardHeading(
    String text, {
    TextAlign textAlign = TextAlign.start,
    Color? color,
  }) => AppText(
    text,
    style: AppTextStyles.cardHeading.copyWith(color: color),
    textAlign: textAlign,
  );

  /// Body large - Main paragraph text (15px, regular)
  factory AppText.bodyLarge(
    String text, {
    TextAlign textAlign = TextAlign.start,
    Color? color,
    int? maxLines,
    TextOverflow overflow = TextOverflow.ellipsis,
  }) => AppText(
    text,
    style: AppTextStyles.bodyLarge.copyWith(color: color),
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: overflow,
  );

  /// Body medium - Standard body text (14px, regular)
  factory AppText.bodyMedium(
    String text, {
    TextAlign textAlign = TextAlign.start,
    Color? color,
    int? maxLines,
    TextOverflow overflow = TextOverflow.ellipsis,
  }) => AppText(
    text,
    style: AppTextStyles.bodyMedium.copyWith(color: color),
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: overflow,
  );

  /// Body small - Smaller body text (13px, regular)
  factory AppText.bodySmall(
    String text, {
    TextAlign textAlign = TextAlign.start,
    Color? color,
    int? maxLines,
    TextOverflow overflow = TextOverflow.ellipsis,
  }) => AppText(
    text,
    style: AppTextStyles.bodySmall.copyWith(color: color),
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: overflow,
  );

  /// Label large - Large button/action label (16px, bold)
  factory AppText.labelLarge(
    String text, {
    TextAlign textAlign = TextAlign.start,
    Color? color,
  }) => AppText(
    text,
    style: AppTextStyles.labelLarge.copyWith(color: color),
    textAlign: textAlign,
  );

  /// Label medium - Standard label (14px, bold)
  factory AppText.labelMedium(
    String text, {
    TextAlign textAlign = TextAlign.start,
    Color? color,
  }) => AppText(
    text,
    style: AppTextStyles.labelMedium.copyWith(color: color),
    textAlign: textAlign,
  );

  /// Label small - Small label/chip text (12px, semibold)
  factory AppText.labelSmall(
    String text, {
    TextAlign textAlign = TextAlign.start,
    Color? color,
  }) => AppText(
    text,
    style: AppTextStyles.labelSmall.copyWith(color: color),
    textAlign: textAlign,
  );

  /// Card value - Large number/value display (20px, bold)
  factory AppText.cardValue(
    String text, {
    TextAlign textAlign = TextAlign.start,
    Color? color,
  }) => AppText(
    text,
    style: AppTextStyles.cardValue.copyWith(color: color),
    textAlign: textAlign,
  );

  /// Link text - Clickable link text (14px, semibold, underline)
  factory AppText.link(
    String text, {
    TextAlign textAlign = TextAlign.start,
    Color? color,
    VoidCallback? onTap,
  }) => AppText(
    text,
    style: AppTextStyles.linkText.copyWith(
      color: color,
      decoration: TextDecoration.underline,
    ),
    textAlign: textAlign,
  );

  /// Disabled text - For disabled interactive elements (14px, muted)
  factory AppText.disabled(
    String text, {
    TextAlign textAlign = TextAlign.start,
    Color? color,
  }) => AppText(
    text,
    style: AppTextStyles.disabledText.copyWith(color: color),
    textAlign: textAlign,
  );

  /// Hint text - Placeholder/hint text
  factory AppText.hint(String text, {TextAlign textAlign = TextAlign.start}) =>
      AppText(
        text,
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
        textAlign: textAlign,
      );

  /// Action tile title - For list items (15px, bold)
  factory AppText.actionTileTitle(
    String text, {
    TextAlign textAlign = TextAlign.start,
    Color? color,
  }) => AppText(
    text,
    style: AppTextStyles.actionTileTitle.copyWith(color: color),
    textAlign: textAlign,
  );

  /// Action tile subtitle - Supporting text for action tiles (13px, regular)
  factory AppText.actionTileSubtitle(
    String text, {
    TextAlign textAlign = TextAlign.start,
    Color? color,
  }) => AppText(
    text,
    style: AppTextStyles.actionTileSubtitle.copyWith(color: color),
    textAlign: textAlign,
  );
}

/// ========================================
/// RICH TEXT BUILDER - For styled inline text
/// ========================================

class AppRichText extends StatelessWidget {
  final List<AppTextSpan> spans;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow overflow;

  const AppRichText({
    super.key,
    required this.spans,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow = TextOverflow.clip,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      text: TextSpan(children: spans.map((span) => span.toTextSpan()).toList()),
    );
  }
}

/// Text span model
class AppTextSpan {
  final String text;
  final TextStyle? style;
  final GestureRecognizer? recognizer;

  AppTextSpan({required this.text, this.style, this.recognizer});

  TextSpan toTextSpan() =>
      TextSpan(text: text, style: style, recognizer: recognizer);
}

/// ========================================
/// BADGE TEXT - Labeled badge component
/// ========================================

class AppBadgeText extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final TextStyle? textStyle;
  final EdgeInsets padding;
  final double borderRadius;
  final Border? border;

  const AppBadgeText({
    super.key,
    required this.label,
    this.backgroundColor = AppColors.primary,
    this.textColor = Colors.white,
    this.textStyle,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.borderRadius = AppRadius.full,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
      ),
      child: Text(
        label,
        style:
            textStyle ??
            AppTextStyles.labelSmall.copyWith(color: textColor, fontSize: 11),
      ),
    );
  }

  /// Success badge
  factory AppBadgeText.success(String label) => AppBadgeText(
    label: label,
    backgroundColor: AppColors.success,
    textColor: Colors.white,
  );

  /// Error badge
  factory AppBadgeText.error(String label) => AppBadgeText(
    label: label,
    backgroundColor: AppColors.error,
    textColor: Colors.white,
  );

  /// Warning badge
  factory AppBadgeText.warning(String label) => AppBadgeText(
    label: label,
    backgroundColor: AppColors.warning,
    textColor: Colors.white,
  );

  /// Info badge
  factory AppBadgeText.info(String label) => AppBadgeText(
    label: label,
    backgroundColor: AppColors.info,
    textColor: Colors.white,
  );
}
