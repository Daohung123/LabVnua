import 'package:flutter/material.dart';
import 'package:aqedu/core/theme/app_theme.dart';
import 'package:aqedu/core/widgets/components/app_card.dart';
import 'package:aqedu/core/widgets/components/app_section_header.dart';
import 'package:aqedu/features/home/screens/components/home_view/home_app_bar.dart';
import 'package:aqedu/features/home/screens/components/home_view/home_hero_header.dart';
import 'package:aqedu/features/home/screens/components/home_view/home_quick_summary.dart';
import 'package:aqedu/features/home/screens/components/home_view/home_quick_actions.dart';
import 'package:aqedu/features/home/screens/components/home_view/home_info_banner.dart';

/// ========================================
/// HOME STUDENT VIEW — Main Dashboard
/// ========================================
///
/// Đã refactor thành các component nhỏ:
/// - HomeAppBar: AppBar tùy chỉnh
/// - HomeHeroHeader: Phần chào mừng với avatar & thời gian
/// - HomeQuickSummary: 3 mục quan trọng (lịch, thông báo, học phí)
/// - HomeQuickActions: Lối tắt nhanh (2x2 grid)
/// - HomeInfoBanner: Thông báo quan trọng
class HomeStudent extends StatelessWidget {
  const HomeStudent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: HomeAppBar(),
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.screenPadding,
          children: [
            HomeHeroHeader(),
            SizedBox(height: AppSpacing.xl),

            HomeQuickSummary(),
            SizedBox(height: AppSpacing.xl),

            HomeQuickActions(),
            SizedBox(height: AppSpacing.xxl),

            AppSectionHeader(
              title: 'Hôm nay',
              subtitle: 'Những thông tin bạn cần xem trước khi bắt đầu',
            ),

            HomeInfoBanner(),
            SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}
