import 'package:aqedu/core/theme/app_text_styles.dart';
import 'package:aqedu/core/theme/app_theme.dart';
import 'package:aqedu/core/widgets/components/app_card.dart';
import 'package:aqedu/features/home/home_view/components/home_models.dart';
import 'package:aqedu/features/home/home_view/components/home_notification_section.dart';
import 'package:aqedu/features/home/home_view/components/home_quick_actions.dart';
import 'package:aqedu/features/home/home_view/components/home_schedule_section.dart';
import 'package:aqedu/features/home/home_view/controllers/home_dashboard_controller.dart';
import 'package:aqedu/features/home/layout/app_layout.dart';
import 'package:aqedu/features/home/home_view/components/home_app_bar.dart';
import 'package:flutter/material.dart';

class HomeStudent extends StatefulWidget {
  const HomeStudent({super.key, this.controller});

  final HomeDashboardController? controller;

  @override
  State<HomeStudent> createState() => _HomeStudentState();
}

class _HomeStudentState extends State<HomeStudent> {
  late HomeDashboardController _controller;
  late Future<HomeDashboardState> _dashboardFuture;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? HomeDashboardController();
    _dashboardFuture = _controller.load();
  }

  @override
  void didUpdateWidget(covariant HomeStudent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _controller = widget.controller ?? HomeDashboardController();
      _dashboardFuture = _controller.load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      appBar: const HomeAppBar(),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          FutureBuilder<HomeDashboardState>(
            future: _dashboardFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const _HomeDashboardLoading();
              }

              final state =
                  snapshot.data ??
                  HomeDashboardState(
                    todaySchedule: const [],
                    scheduleError: snapshot.error,
                    notifications: const [],
                    notificationError: snapshot.error,
                    shortcutPreferences: buildDefaultHomeShortcutPreferences(
                      _controller.catalog,
                    ),
                  );

              return _HomeDashboardContent(
                controller: _controller,
                state: state,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HomeDashboardContent extends StatelessWidget {
  const _HomeDashboardContent({required this.controller, required this.state});

  final HomeDashboardController controller;
  final HomeDashboardState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeScheduleSection(
          schedules: state.todaySchedule,
          hasError: state.hasScheduleError,
        ),
        SizedBox(height: AppSpacing.xl),
        const HomeDeadlineSection(),
        SizedBox(height: AppSpacing.xl),
        HomeQuickActions(
          catalog: controller.catalog,
          preferences: state.shortcutPreferences,
          onPreferencesChanged: controller.saveShortcutPreferences,
        ),
        SizedBox(height: AppSpacing.xl),
        HomeNotificationSection(
          notifications: state.notifications,
          hasError: state.hasNotificationError,
        ),
        SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

class _HomeDashboardLoading extends StatelessWidget {
  const _HomeDashboardLoading();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      borderRadius: AppRadius.xl,
      padding: EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          const SizedBox(
            width: 36,
            height: 36,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          ),
          SizedBox(height: AppSpacing.md),
          Text('Đang tải trang chủ...', style: AppTextStyles.actionTileTitle),
          SizedBox(height: AppSpacing.xs),
          Text(
            'Đang lấy lịch, thông báo và lối tắt của bạn',
            textAlign: TextAlign.center,
            style: AppTextStyles.actionTileSubtitle,
          ),
        ],
      ),
    );
  }
}
