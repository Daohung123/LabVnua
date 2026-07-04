import 'package:aqedu/core/logging/app_log.dart';
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
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    AppLog.vongDoi('Màn hình trang chủ được mở', khuVuc: 'Trang chủ');
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

  Future<void> _syncDashboardData() async {
    if (_isSyncing) {
      AppLog.thaoTacNguoiDung(
        'Người dùng bấm đồng bộ khi tiến trình đang chạy',
        khuVuc: 'Trang chủ',
        ketQua: 'Bỏ qua thao tác trùng.',
      );
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    AppLog.thaoTacNguoiDung(
      'Người dùng bấm nút đồng bộ dữ liệu',
      khuVuc: 'Trang chủ',
    );
    setState(() => _isSyncing = true);

    try {
      final result = await _controller.syncData();
      if (!mounted) return;

      setState(() {
        _dashboardFuture = _controller.load();
        _isSyncing = false;
      });
      AppLog.dongBo(
        'Đồng bộ dữ liệu từ trang chủ hoàn tất',
        khuVuc: 'Trang chủ',
        duLieu: {
          'tong_so_nhom': result.total,
          'thanh_cong': result.success,
          'that_bai': result.failed,
        },
      );

      messenger.showSnackBar(
        SnackBar(
          content: Text(
            result.hasFailures
                ? 'Đồng bộ ${result.success}/${result.total} nhóm dữ liệu. Một số nguồn chưa cập nhật được.'
                : 'Đã đồng bộ ${result.success}/${result.total} nhóm dữ liệu vào SQLite.',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      setState(() => _isSyncing = false);
      AppLog.loi(
        'Đồng bộ dữ liệu từ trang chủ gặp lỗi',
        khuVuc: 'Trang chủ',
        loi: error,
      );
      messenger.showSnackBar(
        SnackBar(content: Text('Không thể đồng bộ dữ liệu: $error')),
      );
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
                    upcomingTasks: const [],
                    taskError: snapshot.error,
                    shortcutPreferences: buildDefaultHomeShortcutPreferences(
                      _controller.catalog,
                    ),
                  );

              return _HomeDashboardContent(
                controller: _controller,
                state: state,
                isSyncing: _isSyncing,
                onSync: _syncDashboardData,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HomeDashboardContent extends StatelessWidget {
  const _HomeDashboardContent({
    required this.controller,
    required this.state,
    required this.isSyncing,
    required this.onSync,
  });

  final HomeDashboardController controller;
  final HomeDashboardState state;
  final bool isSyncing;
  final VoidCallback onSync;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _HomeSyncButton(isSyncing: isSyncing, onSync: onSync),
        SizedBox(height: AppSpacing.xl),
        HomeScheduleSection(
          schedules: state.todaySchedule,
          hasError: state.hasScheduleError,
        ),
        SizedBox(height: AppSpacing.xl),
        HomeDeadlineSection(
          tasks: state.upcomingTasks,
          hasError: state.hasTaskError,
        ),
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

class _HomeSyncButton extends StatelessWidget {
  const _HomeSyncButton({required this.isSyncing, required this.onSync});

  final bool isSyncing;
  final VoidCallback onSync;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      borderRadius: AppRadius.xl,
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(Icons.sync_rounded, color: AppColors.primary),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Đồng bộ dữ liệu', style: AppTextStyles.sectionTitle),
                SizedBox(height: AppSpacing.xs),
                Text(
                  'Lưu dữ liệu từ VNUA vào SQLite để dùng offline',
                  style: AppTextStyles.actionTileSubtitle,
                ),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.md),
          FilledButton.icon(
            key: const Key('home-sync-data-button'),
            onPressed: isSyncing ? null : onSync,
            icon: isSyncing
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.cloud_sync_rounded, size: 18),
            label: Text(isSyncing ? 'Đang đồng bộ' : 'Đồng bộ'),
          ),
        ],
      ),
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
