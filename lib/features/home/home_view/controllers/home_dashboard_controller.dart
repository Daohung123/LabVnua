import 'package:aqedu/config/sync_data.dart' as sync_data;
import 'package:aqedu/core/di/app_dependencies.dart';
import 'package:aqedu/core/logging/app_log.dart';
import 'package:aqedu/features/home/home_view/components/home_models.dart';
import 'package:aqedu/features/home/home_view/components/home_shortcut_catalog.dart';
import 'package:aqedu/features/home/home_view/services/home_shortcut_service.dart';
import 'package:aqedu/features/notification/controllers/ctrl_noti_student.dart';
import 'package:aqedu/features/notification/models/notification_student.dart';
import 'package:aqedu/features/schedure/controllers/ctrl_schedure.dart';
import 'package:aqedu/features/schedure/models/schedure_student.dart';
import 'package:aqedu/features/task/domain/entities/local_task.dart';
import 'package:aqedu/features/task/presentation/controllers/local_task_controller.dart';

abstract class HomeDashboardDataSource {
  Future<List<ThoiKhoaBieu>> loadTodaySchedule();

  Future<List<NotificationItem>> loadNotifications();

  Future<List<LocalTask>> loadUpcomingTasks();

  Future<List<HomeShortcutPreference>> loadShortcutPreferences();

  Future<void> saveShortcutPreferences(
    List<HomeShortcutPreference> preferences,
  );

  Future<sync_data.SyncDataResult> syncData();
}

class DefaultHomeDashboardDataSource implements HomeDashboardDataSource {
  DefaultHomeDashboardDataSource({
    HomeShortcutService? shortcutService,
    LocalTaskController? taskController,
    List<HomeShortcutDefinition>? catalog,
  }) : _shortcutService = shortcutService ?? HomeShortcutService(),
       _taskController =
           taskController ?? AppDependencies.instance.localTaskController(),
       _catalog = catalog ?? kHomeShortcutCatalog;

  final HomeShortcutService _shortcutService;
  final LocalTaskController _taskController;
  final List<HomeShortcutDefinition> _catalog;

  @override
  Future<List<ThoiKhoaBieu>> loadTodaySchedule() async {
    AppLog.ungDung(
      'Bắt đầu tải lịch học hôm nay cho trang chủ',
      khuVuc: 'Trang chủ',
    );
    final controller = await CtrlSchedure.create();
    final result = await controller.getTkbToday();
    AppLog.ungDung(
      'Tải lịch học hôm nay cho trang chủ hoàn tất',
      khuVuc: 'Trang chủ',
      duLieu: {'so_luong': result.length},
    );
    return result;
  }

  @override
  Future<List<NotificationItem>> loadNotifications() {
    AppLog.thongBao('Bắt đầu tải thông báo cho trang chủ', khuVuc: 'Trang chủ');
    return CtrlNotiStudent().getNotification();
  }

  @override
  Future<List<LocalTask>> loadUpcomingTasks() {
    AppLog.ungDung(
      'Bắt đầu tải công việc sắp tới cho trang chủ',
      khuVuc: 'Trang chủ',
    );
    return _taskController.loadUpcomingTasks();
  }

  @override
  Future<List<HomeShortcutPreference>> loadShortcutPreferences() async {
    AppLog.coSoDuLieu(
      'Bắt đầu tải cấu hình lối tắt trang chủ',
      khuVuc: 'Trang chủ',
    );
    final profileId = await _shortcutService.resolveProfileId();
    final stored = await _shortcutService.loadPreferences(profileId);
    final normalized = normalizeHomeShortcutPreferences(_catalog, stored);
    if (_preferencesChanged(stored, normalized)) {
      await _shortcutService.savePreferences(profileId, normalized);
    }
    AppLog.coSoDuLieu(
      'Tải cấu hình lối tắt trang chủ hoàn tất',
      khuVuc: 'Trang chủ',
      duLieu: {
        'so_luong': normalized.length,
        'da_chuan_hoa': _preferencesChanged(stored, normalized),
      },
    );
    return normalized;
  }

  @override
  Future<void> saveShortcutPreferences(
    List<HomeShortcutPreference> preferences,
  ) async {
    final profileId = await _shortcutService.resolveProfileId();
    final normalized = normalizeHomeShortcutPreferences(_catalog, preferences);
    await _shortcutService.savePreferences(profileId, normalized);
    AppLog.coSoDuLieu(
      'Đã lưu cấu hình lối tắt trang chủ',
      khuVuc: 'Trang chủ',
      duLieu: {
        'so_luong': normalized.length,
        'so_luong_bat': normalized.where((item) => item.enabled).length,
      },
    );
  }

  @override
  Future<sync_data.SyncDataResult> syncData() {
    return sync_data.syncData();
  }

  bool _preferencesChanged(
    List<HomeShortcutPreference> stored,
    List<HomeShortcutPreference> normalized,
  ) {
    if (stored.length != normalized.length) return true;
    final storedByKey = {for (final item in stored) item.key: item};
    for (final item in normalized) {
      final storedItem = storedByKey[item.key];
      if (storedItem == null) return true;
      if (storedItem.sortOrder != item.sortOrder ||
          storedItem.enabled != item.enabled) {
        return true;
      }
    }
    return false;
  }
}

class HomeDashboardController {
  HomeDashboardController({
    HomeDashboardDataSource? dataSource,
    List<HomeShortcutDefinition>? catalog,
  }) : catalog = catalog ?? kHomeShortcutCatalog,
       _dataSource =
           dataSource ??
           DefaultHomeDashboardDataSource(
             catalog: catalog ?? kHomeShortcutCatalog,
           );

  final HomeDashboardDataSource _dataSource;
  final List<HomeShortcutDefinition> catalog;

  Future<HomeDashboardState> load() async {
    AppLog.ungDung(
      'Bắt đầu tải dữ liệu tổng hợp trang chủ',
      khuVuc: 'Trang chủ',
    );
    var todaySchedule = <ThoiKhoaBieu>[];
    Object? scheduleError;
    var notifications = <NotificationItem>[];
    Object? notificationError;
    var upcomingTasks = <LocalTask>[];
    Object? taskError;
    var shortcuts = buildDefaultHomeShortcutPreferences(catalog);
    Object? shortcutError;

    try {
      todaySchedule = await _dataSource.loadTodaySchedule();
      todaySchedule = todaySchedule.where(_isDisplayableSchedule).toList()
        ..sort((a, b) => a.tietBatDau.compareTo(b.tietBatDau));
    } catch (error) {
      scheduleError = error;
      AppLog.loi(
        'Tải lịch học trang chủ gặp lỗi',
        khuVuc: 'Trang chủ',
        loi: error,
      );
    }

    try {
      notifications = await _dataSource.loadNotifications();
      notifications.sort((a, b) {
        final left = a.ngayGui ?? DateTime.fromMillisecondsSinceEpoch(0);
        final right = b.ngayGui ?? DateTime.fromMillisecondsSinceEpoch(0);
        return right.compareTo(left);
      });
    } catch (error) {
      notificationError = error;
      AppLog.loi(
        'Tải thông báo trang chủ gặp lỗi',
        khuVuc: 'Trang chủ',
        loi: error,
      );
    }

    try {
      upcomingTasks = await _dataSource.loadUpcomingTasks();
    } catch (error) {
      taskError = error;
      AppLog.loi(
        'Tải công việc sắp tới trang chủ gặp lỗi',
        khuVuc: 'Trang chủ',
        loi: error,
      );
    }

    try {
      shortcuts = normalizeHomeShortcutPreferences(
        catalog,
        await _dataSource.loadShortcutPreferences(),
      );
    } catch (error) {
      shortcutError = error;
      AppLog.loi(
        'Tải cấu hình lối tắt trang chủ gặp lỗi',
        khuVuc: 'Trang chủ',
        loi: error,
      );
    }

    AppLog.ungDung(
      'Tải dữ liệu tổng hợp trang chủ hoàn tất',
      khuVuc: 'Trang chủ',
      duLieu: {
        'lich_hoc': todaySchedule.length,
        'thong_bao': notifications.length,
        'cong_viec': upcomingTasks.length,
        'loi_tat': shortcuts.length,
        'co_loi':
            scheduleError != null ||
            notificationError != null ||
            taskError != null ||
            shortcutError != null,
      },
    );

    return HomeDashboardState(
      todaySchedule: todaySchedule,
      scheduleError: scheduleError,
      notifications: notifications,
      notificationError: notificationError,
      upcomingTasks: upcomingTasks,
      taskError: taskError,
      shortcutPreferences: shortcuts,
      shortcutError: shortcutError,
    );
  }

  Future<List<HomeShortcutPreference>> saveShortcutPreferences(
    List<HomeShortcutPreference> preferences,
  ) async {
    final normalized = normalizeHomeShortcutPreferences(catalog, preferences);
    await _dataSource.saveShortcutPreferences(normalized);
    return normalized;
  }

  Future<sync_data.SyncDataResult> syncData() {
    return _dataSource.syncData();
  }

  bool _isDisplayableSchedule(ThoiKhoaBieu item) {
    return item.soTiet > 0 && item.tenMon.trim().isNotEmpty;
  }
}
