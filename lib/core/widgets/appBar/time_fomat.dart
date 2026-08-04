import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:aqedu/core/theme/app_components.dart';
class TimeFormat extends StatefulWidget {
  const TimeFormat({
    super.key,
    this.showDate = true,
    this.showSeconds = true,
    this.textStyle,
    this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    this.leading,
    this.borderRadius = 16.0,
    this.elevation = 0,
    this.blurSigma = 18,
    this.gradient,
    this.borderColor,
    this.showDot = true,
    this.spacing = 8,
  });

  /// Short helper to use the common default.
  static Widget common() => const TimeFormat();

  final bool showDate;
  final bool showSeconds;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final EdgeInsets padding;
  final Widget? leading;
  final double borderRadius;

  final double elevation;
  final double blurSigma;
  final Gradient? gradient;
  final Color? borderColor;
  final bool showDot;
  final double spacing;

  @override
  State<TimeFormat> createState() => _TimeFormatState();
}

class _TimeFormatState extends State<TimeFormat> {
  late final Stream<DateTime> _timeStream;

  @override
  void initState() {
    super.initState();
    _timeStream = Stream<DateTime>.periodic(
      const Duration(seconds: 1),
      (_) => DateTime.now(),
    ).asBroadcastStream();
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  String _buildText(DateTime t) {
    final date = '${_twoDigits(t.day)}/${_twoDigits(t.month)}/${t.year}';
    final time =
        '${_twoDigits(t.hour)}:${_twoDigits(t.minute)}'
        '${widget.showSeconds ? ':${_twoDigits(t.second)}' : ''}';
    return widget.showDate ? '$date • $time' : time;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final defaultStyle = theme.textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: 0.2,
      color: isDark ? AppColors.white : AppColors.black87,
    );

    final bg =
        widget.backgroundColor ??
        (isDark
            ? AppColors.white.withOpacity(0.08)
            : AppColors.white.withOpacity(0.72));

    final borderColor =
        widget.borderColor ??
        (isDark
            ? AppColors.white.withOpacity(0.12)
            : AppColors.black.withOpacity(0.06));

    final gradient =
        widget.gradient ??
        LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [AppColors.white.withOpacity(0.14), AppColors.white.withOpacity(0.05)]
              : [
                  AppColors.white.withOpacity(0.95),
                  AppColors.white.withOpacity(0.65),
                ],
        );

    return StreamBuilder<DateTime>(
      stream: _timeStream,
      builder: (context, snapshot) {
        final now = snapshot.data ?? DateTime.now();
        final text = _buildText(now);

        return Semantics(
          label: 'Thời gian hiện tại: $text',
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.98, end: 1),
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            builder: (context, scale, child) {
              return Transform.scale(scale: scale, child: child);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                boxShadow: widget.elevation > 0
                    ? [
                        BoxShadow(
                          color: AppColors.black.withOpacity(isDark ? 0.22 : 0.10),
                          blurRadius: widget.elevation * 2.2,
                          offset: Offset(0, widget.elevation),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: AppColors.black.withOpacity(isDark ? 0.18 : 0.06),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: widget.blurSigma,
                    sigmaY: widget.blurSigma,
                  ),
                  child: Container(
                    padding: widget.padding,
                    decoration: BoxDecoration(
                      gradient: gradient,
                      color: bg,
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.leading != null) ...[
                          AnimatedScale(
                            scale: 1,
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeOutBack,
                            child: widget.leading!,
                          ),
                          SizedBox(width: widget.spacing),
                        ] else if (widget.showDot) ...[
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: isDark
                                    ? [
                                        AppColors.success.withOpacity(0.95),
                                        AppColors.primaryLight.withOpacity(0.75),
                                      ]
                                    : [
                                        AppColors.primary.withOpacity(0.95),
                                        AppColors.primaryLight.withOpacity(
                                          0.75,
                                        ),
                                      ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      (isDark
                                              ? AppColors.success
                                              : AppColors.primary)
                                          .withOpacity(0.35),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: widget.spacing),
                        ],
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 350),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          transitionBuilder: (child, animation) {
                            final fade = CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOut,
                            );
                            final slide = Tween<Offset>(
                              begin: const Offset(0, 0.18),
                              end: Offset.zero,
                            ).animate(fade);

                            return FadeTransition(
                              opacity: fade,
                              child: SlideTransition(
                                position: slide,
                                child: child,
                              ),
                            );
                          },
                          child: Text(
                            text,
                            key: ValueKey(text),
                            style: (widget.textStyle ?? defaultStyle)?.copyWith(
                              shadows: [
                                Shadow(
                                  color: AppColors.black.withOpacity(
                                    isDark ? 0.20 : 0.08,
                                  ),
                                  blurRadius: 10,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
