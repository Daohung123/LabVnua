import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Deprecated: Use AppContainer or AppCard instead
/// This widget is kept for backward compatibility.
@Deprecated('Use AppContainer.elevated() or AppCard variants instead')
class ContainerMod1 extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;

  const ContainerMod1({
    super.key,
    required this.child,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            width: width,
            height: height * 0.95,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Center(child: child),
          ),
        ),
      ],
    );
  }
}
