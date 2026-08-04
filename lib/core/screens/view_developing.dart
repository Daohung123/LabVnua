import 'package:aqedu/core/theme/app_components.dart';
import 'package:flutter/material.dart';

/// Standard placeholder for features that are visible in the product map but
/// are not ready for production use yet.
class DevelopingView extends StatelessWidget {
  const DevelopingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tính năng đang phát triển')),
      body: SafeArea(
        child: AppStateView.empty(
          icon: Icons.construction_rounded,
          title: 'Tính năng đang được hoàn thiện',
          message:
              'Nội dung này chưa sẵn sàng. Bạn có thể quay lại và tiếp tục sử dụng các chức năng khác.',
          actionLabel: 'Quay lại',
          onAction: () => Navigator.of(context).maybePop(),
        ),
      ),
    );
  }
}

/// Kept for compatibility with older imports. The previous bouncing animation
/// was intentionally removed to follow the calm motion direction in DESIGN.md.
class CustomBouncingDots extends StatelessWidget {
  const CustomBouncingDots({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(strokeWidth: 2.5),
    );
  }
}
