import 'package:flutter/material.dart';

/// ========================================
/// APP ANIMATIONS - Reusable Animation System
/// ========================================
///
/// Centralized animation definitions for consistent motion across the app.
/// Provides duration constants and animation curve presets to create
/// smooth, professional transitions and interactions.
///
/// Usage: Use AppAnimations.durationShort with AnimatedBuilder or transition widgets
/// Benefits: Consistent motion feel, easy to adjust globally, professional micro-interactions

class AppAnimations {
  // ========================================
  // ANIMATION DURATIONS
  // ========================================

  /// Extra short duration - Quick feedback, micro-interactions (100ms)
  /// Used for: Button presses, state changes, quick dismissals
  static const Duration durationExtraShort = Duration(milliseconds: 120);

  /// Short duration - Subtle animations (200ms)
  /// Used for: Icon animations, color transitions, tooltip appears
  static const Duration durationShort = Duration(milliseconds: 200);

  /// Medium duration - Standard transitions (300ms)
  /// Used for: Page transitions, card entrance, FAB animations
  static const Duration durationMedium = Duration(milliseconds: 320);

  /// Long duration - Prominent animations (500ms)
  /// Used for: Hero animations, complex transitions, entrance effects
  static const Duration durationLong = Duration(milliseconds: 320);

  /// Extra long duration - Slow animations (800ms)
  /// Used for: Loading animations, marquee scrolling, slow reveals
  static const Duration durationExtraLong = Duration(milliseconds: 320);

  // ========================================
  // ANIMATION CURVES
  // ========================================

  /// Ease out curve - Starts fast, ends slow (natural deceleration)
  /// Usage: Exit animations, page transitions, dismissals
  static const Curve easeOut = Curves.easeOutCubic;

  /// Ease in curve - Starts slow, ends fast (natural acceleration)
  /// Usage: Entrance animations, fades, scales
  static const Curve easeIn = Curves.easeInCubic;

  /// Ease in out curve - Smooth throughout
  /// Usage: Continuous animations, morphs
  static const Curve easeInOut = Curves.easeInOutCubic;

  /// Linear curve - Constant speed (for rotations, progress)
  /// Usage: Loading spinners, progress indicators
  static const Curve linear = Curves.linear;

  /// Elastic curve - Bouncy, playful feel
  /// Usage: Special interactive elements, delightful micro-interactions
  static const Curve elastic = Curves.easeOutCubic;

  /// Spring curve - Natural physics-based bounce
  /// Usage: FAB entrance, springy list items
  static const Curve springy = Curves.easeOutCubic;

  // ========================================
  // PRESET ANIMATION COMBINATIONS
  // ========================================

  /// Quick enter - Fast entrance with slight ease
  static const AnimationPreset quickEnter = AnimationPreset(
    duration: durationShort,
    curve: easeOut,
  );

  /// Standard transition - Normal page/dialog transition
  static const AnimationPreset standardTransition = AnimationPreset(
    duration: durationMedium,
    curve: easeInOut,
  );

  /// Slow entrance - Prominent entrance animation
  static const AnimationPreset slowEntrance = AnimationPreset(
    duration: durationLong,
    curve: easeOut,
  );

  /// FAB animation - Springy, playful FAB entrance
  static const AnimationPreset fabAnimation = AnimationPreset(
    duration: durationMedium,
    curve: Curves.easeOutCubic,
  );

  /// Loading animation - Continuous rotation
  static const AnimationPreset loadingAnimation = AnimationPreset(
    duration: durationExtraLong,
    curve: linear,
  );
}

/// ========================================
/// ANIMATION PRESET - Reusable animation config
/// ========================================
class AnimationPreset {
  final Duration duration;
  final Curve curve;

  const AnimationPreset({required this.duration, required this.curve});
}

/// ========================================
/// PAGE TRANSITIONS - Custom route transitions
/// ========================================

/// Fade transition - Smooth fade between pages
class FadePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  FadePageRoute({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: AppAnimations.durationMedium,
      );
}

/// Slide transition - Slide from right to left
class SlidePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  SlidePageRoute({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;
          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: AppAnimations.durationMedium,
      );
}

/// Scale & Fade transition - Zoom in while fading
class ScaleFadePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  ScaleFadePageRoute({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return ScaleTransition(
            scale: animation,
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        transitionDuration: AppAnimations.durationLong,
      );
}

/// ========================================
/// ANIMATION UTILITIES
/// ========================================

/// Builder for staggered list item animations
class StaggeredListAnimationBuilder extends StatelessWidget {
  final List<Widget> children;
  final Duration initialDelay;
  final Duration itemDelay;

  const StaggeredListAnimationBuilder({
    super.key,
    required this.children,
    this.initialDelay = const Duration(milliseconds: 100),
    this.itemDelay = const Duration(milliseconds: 50),
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: children.length,
      itemBuilder: (context, index) {
        return _StaggeredItem(
          delay: initialDelay + (itemDelay * index),
          child: children[index],
        );
      },
    );
  }
}

/// Single staggered item widget
class _StaggeredItem extends StatefulWidget {
  final Duration delay;
  final Widget child;

  const _StaggeredItem({required this.delay, required this.child});

  @override
  State<_StaggeredItem> createState() => _StaggeredItemState();
}

class _StaggeredItemState extends State<_StaggeredItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.durationLong,
      vsync: this,
    );

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut)),
        child: widget.child,
      ),
    );
  }
}

/// ========================================
/// SCALE & OPACITY ANIMATION
/// ========================================

/// Animated button with scale and opacity feedback
class AnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Duration duration;
  final Curve curve;

  const AnimatedButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.duration = AppAnimations.durationShort,
    this.curve = Curves.easeInOut,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onPressed,
      child: ScaleTransition(
        scale: Tween<double>(
          begin: 1.0,
          end: 0.95,
        ).animate(CurvedAnimation(parent: _controller, curve: widget.curve)),
        child: widget.child,
      ),
    );
  }
}
