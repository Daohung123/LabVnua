import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_animations.dart';
import 'dart:math';

/// ========================================
/// AI FAB BUTTON - Floating Action Button with AI Assistance
/// ========================================
///
/// A modern, animated floating action button that provides AI assistant access.
/// Features:
/// - Smooth entrance animation
/// - Contextual icons based on current tab
/// - Beautiful press animation feedback
/// - Accessible and user-friendly
///
/// Usage:
/// ```
/// Scaffold(
///   floatingActionButton: AIFabButton(
///     onPressed: () => _openAIAssistant(context),
///     heroTag: 'ai-fab',
///   ),
/// )
/// ```
///
/// Benefits:
/// - Unified AI access point across entire app
/// - Smooth, professional animations
/// - Consistent styling with app theme

class AIFabButton extends StatefulWidget {
  /// Callback when FAB is pressed
  final VoidCallback onPressed;

  /// Hero tag for FAB animation (must be unique per screen)
  final Object heroTag;

  /// Tooltip shown on long press
  final String tooltip;

  /// Size of the FAB
  final double size;

  /// Icon to display (default: AI/sparkle icon)
  final IconData? icon;

  /// Icon size
  final double iconSize;

  /// FAB color (default: primary blue)
  final Color? backgroundColor;

  /// Icon color (default: white)
  final Color? foregroundColor;

  /// Enable/disable the FAB
  final bool enabled;

  const AIFabButton({
    super.key,
    required this.onPressed,
    this.heroTag = 'ai-fab',
    this.tooltip = 'AI Assistant',
    this.size = 56,
    this.icon,
    this.iconSize = 24,
    this.backgroundColor,
    this.foregroundColor = Colors.white,
    this.enabled = true,
  });

  @override
  State<AIFabButton> createState() => _AIFabButtonState();
}

class _AIFabButtonState extends State<AIFabButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize animation controller for entrance effect
    _controller = AnimationController(
      duration: AppAnimations.durationMedium,
      vsync: this,
    );

    // Scale animation: from 0 to 1
    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut, // Springy effect
      ),
    );

    // Rotation animation: slight rotation
    _rotationAnimation = Tween<double>(
      begin: -0.1,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Start animation when widget builds
    Future.delayed(const Duration(milliseconds: 300), () {
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
    return ScaleTransition(
      scale: _scaleAnimation,
      child: RotationTransition(
        turns: _rotationAnimation,
        child: FloatingActionButton(
          // Hero animation for smooth transition
          heroTag: widget.heroTag,
          // Styling
          backgroundColor: widget.backgroundColor ?? AppColors.primary,
          foregroundColor: widget.foregroundColor,
          elevation: 8,
          // Press callback
          onPressed: widget.enabled ? widget.onPressed : null,
          // Shape
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          // Child content
          child: Tooltip(
            message: widget.tooltip,
            child: Icon(
              widget.icon ?? Icons.auto_awesome, // AI sparkle icon
              size: widget.iconSize,
            ),
          ),
        ),
      ),
    );
  }
}

/// ========================================
/// CONTEXT-AWARE FAB - FAB that changes based on current screen
/// ========================================

class ContextAwareFabButton extends StatelessWidget {
  /// Current tab index (0-4)
  final int currentTabIndex;

  /// Callback when FAB is pressed
  final VoidCallback onFabPressed;

  /// Optional custom hero tag
  final String? heroTag;

  const ContextAwareFabButton({
    super.key,
    required this.currentTabIndex,
    required this.onFabPressed,
    this.heroTag,
  });

  /// Get icon based on current tab
  IconData _getIconForTab(int index) {
    switch (index) {
      case 0: // Home
        return Icons.auto_awesome;
      case 1: // Study
        return Icons.school_outlined;
      case 2: // Chat
        return Icons.chat_bubble_outline;
      case 3: // Other
        return Icons.apps_outlined;
      case 4: // Settings
        return Icons.settings_suggest_outlined;
      default:
        return Icons.auto_awesome;
    }
  }

  /// Get tooltip based on current tab
  String _getTooltipForTab(int index) {
    switch (index) {
      case 0:
        return 'AI Assistant - Home';
      case 1:
        return 'AI Assistant - Study Help';
      case 2:
        return 'Start AI Chat';
      case 3:
        return 'AI Assistant';
      case 4:
        return 'AI Settings';
      default:
        return 'AI Assistant';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AIFabButton(
      onPressed: onFabPressed,
      heroTag: heroTag ?? 'context-fab-$currentTabIndex',
      icon: _getIconForTab(currentTabIndex),
      tooltip: _getTooltipForTab(currentTabIndex),
    );
  }
}

/// ========================================
/// MINI FAB - Smaller FAB for secondary actions
/// ========================================

class MiniFabButton extends StatelessWidget {
  /// Callback when FAB is pressed
  final VoidCallback onPressed;

  /// Icon to display
  final IconData icon;

  /// FAB color
  final Color? backgroundColor;

  /// Icon color
  final Color? foregroundColor;

  /// Label text (shown next to icon)
  final String? label;

  /// Tooltip
  final String tooltip;

  const MiniFabButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.backgroundColor,
    this.foregroundColor = Colors.white,
    this.label,
    this.tooltip = '',
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      onPressed: onPressed,
      backgroundColor: backgroundColor ?? AppColors.primary,
      foregroundColor: foregroundColor,
      tooltip: tooltip,
      child: Icon(icon),
    );
  }
}

/// ========================================
/// FLOATING SPEED DIAL - Multiple quick actions
/// ========================================

class FABSpeedDial extends StatefulWidget {
  /// List of actions to show
  final List<FABSpeedDialAction> actions;

  /// Child FAB icon
  final IconData icon;

  /// Hero tag
  final Object heroTag;

  /// Callback when main FAB is pressed (toggles menu)
  final VoidCallback? onMainFabPressed;

  const FABSpeedDial({
    super.key,
    required this.actions,
    this.icon = Icons.add,
    this.heroTag = 'speed-dial',
    this.onMainFabPressed,
  });

  @override
  State<FABSpeedDial> createState() => _FABSpeedDialState();
}

class _FABSpeedDialState extends State<FABSpeedDial>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.durationMedium,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isOpen ? _controller.reverse() : _controller.forward();
      _isOpen = !_isOpen;
    });
    widget.onMainFabPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background overlay (when menu is open)
        if (_isOpen)
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggleMenu,
              child: Container(color: Colors.transparent),
            ),
          ),
        // Action buttons
        ..._buildActionButtons(),
        // Main FAB
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            heroTag: widget.heroTag,
            backgroundColor: AppColors.primary,
            onPressed: _toggleMenu,
            child: RotationTransition(
              turns: Tween<double>(begin: 0, end: 0.125).animate(_controller),
              child: Icon(widget.icon),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildActionButtons() {
    return List.generate(widget.actions.length, (index) {
      final action = widget.actions[index];
      final angle = (index * 90.0) * 3.14159 / 180.0;

      return Positioned(
        bottom: 16 + (60 * (index + 1) * _controller.value * 0.1),
        right: 16 + (50 * sin(angle) * _controller.value),
        child: ScaleTransition(
          scale: _controller,
          child: FloatingActionButton.small(
            backgroundColor: action.backgroundColor ?? AppColors.primary,
            onPressed: () {
              action.onPressed();
              _toggleMenu();
            },
            tooltip: action.label,
            child: Icon(action.icon, size: 20),
          ),
        ),
      );
    });
  }
}

/// Speed dial action
class FABSpeedDialAction {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;

  FABSpeedDialAction({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
  });
}
