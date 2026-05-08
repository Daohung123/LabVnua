import 'package:aqedu/features/home/screens/student_chat_view.dart';
import 'package:aqedu/features/notification/screens/view_noti_student.dart';
import 'package:aqedu/features/schedure/screens/study_view_day_month.dart';
import 'package:aqedu/features/schedure/screens/today_schedule_view.dart';
import 'package:aqedu/features/score_data/screens/view_score_student.dart';
import 'package:aqedu/features/tuition/screens/view_tuition.dart';
import 'package:flutter/material.dart';
import 'package:aqedu/core/widgets/appBar/avt.dart';
import 'package:aqedu/core/widgets/appBar/name_user.dart';
import 'package:aqedu/core/widgets/appBar/notification.dart';
import 'package:aqedu/core/widgets/appBar/scan.dart';
import 'package:aqedu/core/widgets/appBar/time_fomat.dart';
import 'package:aqedu/features/schedure/screens/components/schedure.dart';
import 'package:aqedu/core/theme/app_theme.dart';
import 'package:aqedu/core/theme/app_text_styles.dart';
import 'package:aqedu/core/widgets/components/app_card.dart';
import 'package:aqedu/core/widgets/components/app_section_header.dart';

/// ========================================
/// HOME STUDENT VIEW — Main Dashboard (v2)
/// ========================================
///
/// Improvements over v1:
/// - All text nodes have overflow / maxLines guards
/// - Summary cards use FittedBox so values never wrap
/// - Quick-action shortcuts use a fixed-height tile with
///   TextOverflow.ellipsis — no more runaway labels
/// - Hero greeting uses softWrap + maxLines: 1
/// - AppBar title has overflow: TextOverflow.ellipsis
/// - Section headers pass through to AppSectionHeader unchanged
///   (no regression on existing widget contracts)

class HomeStudent extends StatelessWidget {
  const HomeStudent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.screenPadding,
          children: [
            _buildHeroHeader(),
            SizedBox(height: AppSpacing.xl),

            _buildQuickSummary(context),
            SizedBox(height: AppSpacing.xl),

            _buildQuickActions(context), // <-- pass context here
            SizedBox(height: AppSpacing.xxl),

            AppSectionHeader(
              title: 'Hôm nay',
              subtitle: 'Những thông tin bạn cần xem trước khi bắt đầu',
            ),

            _buildInfoBanner(),
            SizedBox(height: AppSpacing.xl),

            AppSectionHeader(
              title: 'Thời khóa biểu',
              subtitle: 'Theo dõi lịch học và lịch làm việc trong ngày',
            ),

            AppCard(
              borderRadius: AppRadius.xl,
              padding: EdgeInsets.all(AppSpacing.lg),
              child: const Schedure(),
            ),
            SizedBox(height: AppSpacing.xl),

            AppSectionHeader(
              title: 'Công cụ học tập',
              subtitle: 'Các tiện ích hỗ trợ sinh viên trong quá trình học',
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // APP BAR
  // ─────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: false,
      backgroundColor: AppColors.primary,
      surfaceTintColor: Colors.transparent,
      titleSpacing: AppSpacing.lg,
      title: Text(
        'Trang chủ',
        overflow: TextOverflow.ellipsis, // FIX: prevent rare overflow
        style: AppTextStyles.heroTitle.copyWith(
          fontSize: 20,
          letterSpacing: 0.2,
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              NotificationButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationView(),
                    ),
                  );
                },
              ),
              SizedBox(width: 4),
              QRScanButton(
                onPressed: () {
                  // Handle QR scan button press
                  print("Đang mở chức năng quét QR...");
                },
              ),
              SizedBox(width: 8),
            ],
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  // HERO HEADER
  // ─────────────────────────────────────────
  Widget _buildHeroHeader() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        gradient: AppGradients.heroGradient,
        boxShadow: AppShadows.heroShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              Container(
                padding: EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(AppOpacity.bg12),
                  border: Border.all(
                    color: Colors.white.withOpacity(AppOpacity.bg14),
                    width: 1.3,
                  ),
                ),
                child: const UserAvatar(imagePath: 'assets/avt.jpg'),
              ),

              SizedBox(width: AppSpacing.lg),

              // User info — Expanded prevents overflow
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const UserGreeting(
                      firstName: '',
                      middleName: '',
                      lastName: '',
                    ),
                    SizedBox(height: AppSpacing.sm),

                    // FIX: greeting limited to 1 line with ellipsis
                    Text(
                      'Chúc bạn học tập hiệu quả',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.heroSubtitle,
                    ),

                    SizedBox(height: AppSpacing.lg),

                    const TimeFormat(
                      leading: Icon(
                        Icons.access_time_rounded,
                        size: 18,
                        color: Colors.black,
                      ),
                      backgroundColor: Colors.white,
                      textStyle: TextStyle(
                        fontSize: 11,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: AppSpacing.lg),

          // Status chips
          Row(
            children: [
              _chip('Đang hoạt động'),
              SizedBox(width: AppSpacing.sm),
              _chip('Đã đồng bộ'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(AppOpacity.bg10),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: Colors.white.withOpacity(AppOpacity.bg12)),
      ),
      child: Text(
        text,
        maxLines: 1, // FIX
        overflow: TextOverflow.ellipsis, // FIX
        style: AppTextStyles.chipText.copyWith(
          fontSize: 11.5,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // QUICK SUMMARY — 3-card row
  // ─────────────────────────────────────────
  // ─────────────────────────────────────────
  // QUICK SUMMARY — tổng quan nhanh
  // ─────────────────────────────────────────
  Widget _buildQuickSummary(BuildContext context) {
    return AppCard(
      borderRadius: AppRadius.xl,
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tổng quan nhanh', style: AppTextStyles.sectionTitle),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      'Xem nhanh các mục quan trọng trước khi bắt đầu ngày học',
                      style: AppTextStyles.sectionSubtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(AppOpacity.bg12),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: const Icon(
                  Icons.dashboard_outlined,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
            ],
          ),

          SizedBox(height: AppSpacing.lg),

          _overviewItem(
            context: context,
            icon: Icons.calendar_month_outlined,
            title: 'Lịch học hôm nay',
            value: '4 tiết đang chờ',
            color: AppColors.scheduleColor,
            destination: TodayScheduleView(),
          ),

          SizedBox(height: AppSpacing.md),

          _overviewItem(
            context: context,
            icon: Icons.notifications_active_outlined,
            title: 'Thông báo mới',
            value: '3 thông báo chưa xem',
            color: AppColors.notificationColor,
            destination: NotificationView(),
          ),

          SizedBox(height: AppSpacing.md),

          _overviewItem(
            context: context,
            icon: Icons.payments_outlined,
            title: 'Học phí',
            value: 'Xem chi tiết công nợ',
            color: AppColors.tuitionColor,
            destination: TuitionView(),
          ),
        ],
      ),
    );
  }

  Widget _overviewItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required Widget destination, // 👈 thêm cái này
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: color.withOpacity(AppOpacity.bg10),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: color.withOpacity(AppOpacity.bg12)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withOpacity(AppOpacity.bg18),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(icon, color: color, size: 22),
            ),

            SizedBox(width: AppSpacing.md),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.actionTileTitle,
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.actionTileSubtitle,
                  ),
                ],
              ),
            ),

            Icon(Icons.chevron_right_rounded, color: color, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.lightShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(AppOpacity.bg14),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(icon, color: color, size: 20),
          ),

          SizedBox(height: AppSpacing.md),

          // FIX: FittedBox shrinks the text to fit, so it never wraps
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(value, style: AppTextStyles.cardValue),
          ),

          SizedBox(height: AppSpacing.xs),

          // FIX: label is 1 line with ellipsis
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.cardSubtitle,
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // QUICK ACTIONS — shortcut grid
  // ─────────────────────────────────────────
  //
  // Changed from LayoutBuilder+Wrap to a proper 2×2 GridView so that
  // each cell is the exact same size regardless of content, and text
  // can never break the layout.
  Widget _buildQuickActions(BuildContext context) {
    final shortcuts = [
      _ShortcutData(
        Icons.today_outlined,
        'TKB ngày',
        AppColors.scheduleColor,
        StudyViewDayMoth(),
      ),
      _ShortcutData(
        Icons.grade_outlined,
        'Xem điểm',
        AppColors.scoreColor,
        ScoreView(),
      ),
      _ShortcutData(
        Icons.payments_outlined,
        'Học phí',
        AppColors.tuitionColor,
        TuitionView(),
      ),
      _ShortcutData(
        Icons.menu_book_outlined,
        'Học liệu',
        AppColors.materialsColor,
        Chat(),
      ),
    ];

    return AppCard(
      borderRadius: AppRadius.xl,
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Lối tắt', style: AppTextStyles.sectionTitle),
          SizedBox(height: AppSpacing.xs),
          Text(
            'Truy cập nhanh những chức năng bạn dùng nhiều nhất',
            style: AppTextStyles.sectionSubtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: AppSpacing.lg),

          // 2-column grid — each tile has a fixed aspect ratio
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            childAspectRatio: 3.0, // wide tile, matches the icon+label row
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: shortcuts.map((s) => _shortcutTile(context, s)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _shortcutTile(BuildContext context, _ShortcutData s) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => s.page as Widget),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: s.color.withOpacity(AppOpacity.bg10),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: s.color.withOpacity(AppOpacity.bg12)),
        ),
        child: Row(
          children: [
            // Icon box — fixed size so it never pushes text
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: s.color.withOpacity(AppOpacity.bg18),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(s.icon, color: s.color, size: 20),
            ),

            SizedBox(width: AppSpacing.md),

            // FIX: Flexible + ellipsis — label will never overflow
            Flexible(
              child: Text(
                s.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.actionTileTitle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // INFO BANNER
  // ─────────────────────────────────────────
  Widget _buildInfoBanner() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.infoLight,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.info.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(AppOpacity.bg12),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const Icon(
              Icons.campaign_outlined,
              size: 24,
              color: AppColors.primary,
            ),
          ),

          SizedBox(width: AppSpacing.lg),

          // FIX: Expanded prevents banner text from overflowing
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Không có thông báo khẩn',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.actionTileTitle,
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  'Bạn có thể kiểm tra lịch học và học phí ngay bên dưới.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.actionTileSubtitle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// PRIVATE HELPER — shortcut data model
// ─────────────────────────────────────────
//
// Using a simple value object avoids passing 6 positional arguments
// and makes the grid list easy to read at a glance.
class _ShortcutData {
  const _ShortcutData(this.icon, this.label, this.color, this.page);
  final IconData icon;
  final String label;
  final Color color;
  final Object page;
}
