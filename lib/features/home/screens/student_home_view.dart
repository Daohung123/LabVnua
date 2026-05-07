import 'package:aqedu/features/home/screens/student_chat_view.dart';
import 'package:aqedu/features/schedure/screens/study_view_day_month.dart';
import 'package:aqedu/features/score_data/screens/view_score_student.dart';
import 'package:flutter/material.dart';
import 'package:aqedu/core/widgets/appBar/avt.dart';
import 'package:aqedu/core/widgets/appBar/name_user.dart';
import 'package:aqedu/core/widgets/appBar/notification.dart';
import 'package:aqedu/core/widgets/appBar/scan.dart';
import 'package:aqedu/core/widgets/appBar/time_fomat.dart';
import 'package:aqedu/features/schedure/screens/components/schedure.dart';
import 'package:aqedu/core/widgets/study_tool/study_tool.dart';
import 'package:aqedu/core/theme/app_theme.dart';
import 'package:aqedu/core/theme/app_text_styles.dart';
import 'package:aqedu/core/widgets/components/app_card.dart';
import 'package:aqedu/core/widgets/components/app_section_header.dart';

/// ========================================
/// HOME STUDENT VIEW - Main Dashboard
/// ========================================
///
/// The primary dashboard screen for students featuring:
/// - Hero welcome header with gradient
/// - Quick summary cards (schedule, notifications, education status)
/// - Quick action shortcuts
/// - Today's information banner
/// - Schedule (Thời khóa biểu) section
/// - Study tools section
///
/// This screen now uses the centralized design system:
/// - AppColors for consistent color theming
/// - AppSpacing for consistent spacing
/// - AppCard component for unified card styling
/// - AppTextStyles for consistent typography
///
/// Benefits:
/// - Maintains state better across tab switches
/// - Professional, modern appearance
/// - Easy to maintain and update globally
/// - Fully documented with clear comments

class HomeStudent extends StatelessWidget {
  const HomeStudent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Background color uses centralized AppColors
      backgroundColor: AppColors.background,

      /// Custom AppBar with notification and scan buttons
      appBar: _buildAppBar(),

      /// Main content using ListView for vertical scrolling
      body: SafeArea(
        child: ListView(
          /// Standard screen padding from theme system
          padding: AppSpacing.screenPadding,
          children: [
            /// 1. Hero welcome header with gradient
            _buildHeroHeader(),
            SizedBox(height: AppSpacing.xl),

            /// 2. Quick summary cards (3-column grid)
            _buildQuickSummary(),
            SizedBox(height: AppSpacing.xl),

            /// 3. Quick action shortcuts
            _buildQuickActions(),
            SizedBox(height: AppSpacing.xxl),

            /// 4. Today's section header
            AppSectionHeader(
              title: 'Hôm nay',
              subtitle: 'Những thông tin bạn cần xem trước khi bắt đầu',
            ),

            /// 5. Information banner
            _buildInfoBanner(),
            SizedBox(height: AppSpacing.xl),

            /// 6. Schedule section
            AppSectionHeader(
              title: 'Thời khóa biểu',
              subtitle: 'Theo dõi lịch học và lịch làm việc trong ngày',
            ),

            /// Schedule widget inside a modernized card
            AppCard(
              borderRadius: AppRadius.xl,
              padding: EdgeInsets.all(AppSpacing.lg),
              child: const Schedure(),
            ),
            SizedBox(height: AppSpacing.xl),

            /// 7. Study tools section
            AppSectionHeader(
              title: 'Công cụ học tập',
              subtitle: 'Các tiện ích hỗ trợ sinh viên trong quá trình học',
            ),

            /// Study tools widget inside a modernized card
            AppCard(
              borderRadius: AppRadius.xl,
              padding: EdgeInsets.all(AppSpacing.lg),
              child: const StudyTool(),
            ),
          ],
        ),
      ),
    );
  }

  /// ========================================
  /// APP BAR - Top navigation bar
  /// ========================================
  ///
  /// Displays home title with notification and QR scan buttons.
  /// Uses primary blue color from centralized theme.
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      /// No shadow for flat modern design
      elevation: 0,

      /// Centered alignment
      centerTitle: false,

      /// Primary blue color from theme
      backgroundColor: AppColors.primary,

      /// Transparent tint for clean look
      surfaceTintColor: Colors.transparent,

      /// Spacing from left edge
      titleSpacing: AppSpacing.lg,

      /// Title using headline style
      title: Text(
        'Trang chủ',
        style: AppTextStyles.heroTitle.copyWith(
          fontSize: 20,
          letterSpacing: 0.2,
        ),
      ),

      /// Action buttons (notification + QR scan)
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [Noti(), SizedBox(width: 4), Scan(), SizedBox(width: 8)],
          ),
        ),
      ],
    );
  }

  /// ========================================
  /// HERO HEADER - Welcome section
  /// ========================================
  ///
  /// Large gradient header featuring:
  /// - User avatar
  /// - User greeting
  /// - Status chips (active, synced)
  /// - Current time
  ///
  /// Uses the professional blue gradient from AppGradients
  Widget _buildHeroHeader() {
    return Container(
      /// Padding inside header
      padding: EdgeInsets.all(AppSpacing.lg),

      /// Gradient background + shadow
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        gradient: AppGradients.heroGradient,
        boxShadow: AppShadows.heroShadow,
      ),

      /// Main content
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Row: Avatar + User info
          Row(
            children: [
              /// User avatar in circular container
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
                child: const Avatar(),
              ),

              SizedBox(width: AppSpacing.lg),

              /// User greeting + time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// User name
                    const NameUser(),

                    SizedBox(height: AppSpacing.sm),

                    /// Greeting message
                    Text(
                      'Chúc bạn học tập hiệu quả hôm nay',
                      style: AppTextStyles.heroSubtitle,
                    ),

                    SizedBox(height: AppSpacing.lg),

                    /// Current time display
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

          /// Status chips (active, synced)
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

  /// ========================================
  /// CHIP WIDGET - Status badge
  /// ========================================
  ///
  /// Small rounded badge showing status information.
  /// Used for "active", "synced", etc.
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
        style: AppTextStyles.chipText.copyWith(
          fontSize: 11.5,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  /// ========================================
  /// QUICK SUMMARY - 3-card stats row
  /// ========================================
  ///
  /// Displays three key metrics:
  /// - Schedule (today)
  /// - Notifications (new count)
  /// - Education status (open/closed)
  ///
  /// Each card has an icon, value, and label.
  Widget _buildQuickSummary() {
    return Row(
      children: [
        /// Card 1: Schedule
        Expanded(
          child: _summaryCard(
            icon: Icons.calendar_month_outlined,
            title: 'Lịch học',
            value: 'Hôm nay',
            color: AppColors.scheduleColor,
          ),
        ),

        SizedBox(width: AppSpacing.lg),

        /// Card 2: Notifications
        Expanded(
          child: _summaryCard(
            icon: Icons.notifications_active_outlined,
            title: 'Thông báo',
            value: '3 mới',
            color: AppColors.notificationColor,
          ),
        ),

        SizedBox(width: AppSpacing.lg),

        /// Card 3: Education (học vụ)
        Expanded(
          child: _summaryCard(
            icon: Icons.school_outlined,
            title: 'Học tập',
            value: 'Mở',
            color: AppColors.tuitionColor,
          ),
        ),
      ],
    );
  }

  /// ========================================
  /// SUMMARY CARD - Metric display
  /// ========================================
  ///
  /// Individual summary card component.
  /// Shows icon, metric value, and label with semantic color.
  Widget _summaryCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      /// Inner padding
      padding: EdgeInsets.all(AppSpacing.lg),

      /// Card styling from theme
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.lightShadow,
      ),

      /// Main content
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Icon container with semantic color
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(AppOpacity.bg14),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(icon, color: color, size: 22),
          ),

          SizedBox(height: AppSpacing.lg),

          /// Metric value (large, bold)
          Text(value, style: AppTextStyles.cardValue),

          SizedBox(height: AppSpacing.sm),

          /// Metric label
          Text(title, style: AppTextStyles.cardSubtitle),
        ],
      ),
    );
  }

  /// ========================================
  /// QUICK ACTIONS - Shortcut buttons
  /// ========================================
  ///
  /// 2x2 grid of quick access buttons:
  /// - Daily schedule
  /// - View grades
  /// - Tuition info
  /// - Learning materials
  ///
  /// Uses AppCard for consistent styling.
  Widget _buildQuickActions() {
    return AppCard(
      borderRadius: AppRadius.xl,
      padding: EdgeInsets.all(AppSpacing.lg),

      /// Main content
      child: LayoutBuilder(
        builder: (context, constraints) {
          /// Calculate width for 2-column layout with spacing
          final width = (constraints.maxWidth - AppSpacing.md) / 2;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Text('Lối tắt', style: AppTextStyles.sectionTitle),

              SizedBox(height: AppSpacing.sm),

              /// Subtitle
              Text(
                'Truy cập nhanh những chức năng bạn dùng nhiều nhất',
                style: AppTextStyles.sectionSubtitle,
              ),

              SizedBox(height: AppSpacing.lg),

              /// 2x2 grid of shortcuts
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                children: [
                  _shortcut(
                    context,
                    width,
                    Icons.today_outlined,
                    'TKB ngày',
                    AppColors.scheduleColor,
                    StudyViewDayMoth(),
                  ),
                  _shortcut(
                    context,
                    width,
                    Icons.grade_outlined,
                    'Xem điểm',
                    AppColors.scoreColor,
                    ScoreView(),
                  ),
                  _shortcut(
                    context,
                    width,
                    Icons.payments_outlined,
                    'Học phí',
                    AppColors.tuitionColor,
                    ScoreView(),
                  ),
                  _shortcut(
                    context,
                    width,
                    Icons.menu_book_outlined,
                    'Học liệu',
                    AppColors.materialsColor,
                    Chat(),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  /// ========================================
  /// SHORTCUT - Individual action button
  /// ========================================
  ///
  /// Clickable shortcut button with icon and label.
  /// Uses semantic color coding for visual meaning.
  Widget _shortcut(
    BuildContext context,
    double width,
    IconData icon,
    String label,
    Color color,
    Object NextPage,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.lg),

      /// On tap handler (placeholder for now)
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NextPage as Widget),
        );
      },

      /// Button container
      child: Container(
        width: width,
        padding: EdgeInsets.all(AppSpacing.lg),

        /// Styling with semantic color
        decoration: BoxDecoration(
          color: color.withOpacity(AppOpacity.bg10),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: color.withOpacity(AppOpacity.bg12)),
        ),

        /// Content: icon + label
        child: Row(
          children: [
            /// Icon container
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(AppOpacity.bg18),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(icon, color: color, size: 22),
            ),

            SizedBox(width: AppSpacing.lg),

            /// Label text
            Expanded(child: Text(label, style: AppTextStyles.actionTileTitle)),
          ],
        ),
      ),
    );
  }

  /// ========================================
  /// INFO BANNER - Alert/notification area
  /// ========================================
  ///
  /// Displays important information banner.
  /// Currently shows "No urgent notifications".
  /// Uses info color semantic styling.
  Widget _buildInfoBanner() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),

      /// Light info background with border
      decoration: BoxDecoration(
        color: AppColors.infoLight,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.info.withOpacity(0.3)),
      ),

      /// Banner content
      child: Row(
        children: [
          /// Info icon
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

          /// Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title
                Text(
                  'Không có thông báo khẩn',
                  style: AppTextStyles.actionTileTitle,
                ),

                SizedBox(height: AppSpacing.sm),

                /// Subtitle
                Text(
                  'Bạn có thể kiểm tra lịch học và học phí ngay bên dưới.',
                  style: AppTextStyles.actionTileSubtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
