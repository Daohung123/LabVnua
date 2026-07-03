import 'package:aqedu/features/home/home_view/components/home_models.dart';
import 'package:aqedu/features/home/home_view/components/home_shortcut_catalog.dart';
import 'package:aqedu/features/home/home_view/services/home_shortcut_service.dart';
import 'package:aqedu/features/notification/controllers/ctrl_noti_student.dart';
import 'package:aqedu/features/notification/models/notification_student.dart';
import 'package:aqedu/features/schedure/controllers/ctrl_schedure.dart';
import 'package:aqedu/features/schedure/models/Schedure_Student.dart';

abstract class HomeDashboardDataSource {
  Future<List<ThoiKhoaBieu>> loadTodaySchedule();

  Future<List<NotificationItem>> loadNotifications();

  Future<List<HomeShortcutPreference>> loadShortcutPreferences();

  Future<void> saveShortcutPreferences(
    List<HomeShortcutPreference> preferences,
  );
}

class DefaultHomeDashboardDataSource implements HomeDashboardDataSource {
  DefaultHomeDashboardDataSource({
    HomeShortcutService? shortcutService,
    List<HomeShortcutDefinition>? catalog,
  }) : _shortcutService = shortcutService ?? HomeShortcutService(),
       _catalog = catalog ?? kHomeShortcutCatalog;

  final HomeShortcutService _shortcutService;
  final List<HomeShortcutDefinition> _catalog;

  @override
  Future<List<ThoiKhoaBieu>> loadTodaySchedule() async {
    final controller = await CtrlSchedure.create();
    return controller.getTkbToday();
  }

  @override
  Future<List<NotificationItem>> loadNotifications() {
    return CtrlNotiStudent().getNotification();
  }

  @override
  Future<List<HomeShortcutPreference>> loadShortcutPreferences() async {
    final profileId = await _shortcutService.resolveProfileId();
    final stored = await _shortcutService.loadPreferences(profileId);
    final normalized = normalizeHomeShortcutPreferences(_catalog, stored);
    if (_preferencesChanged(stored, normalized)) {
      await _shortcutService.savePreferences(profileId, normalized);
    }
    return normalized;
  }

  @override
  Future<void> saveShortcutPreferences(
    List<HomeShortcutPreference> preferences,
  ) async {
    final profileId = await _shortcutService.resolveProfileId();
    final normalized = normalizeHomeShortcutPreferences(_catalog, preferences);
    await _shortcutService.savePreferences(profileId, normalized);
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
    var todaySchedule = <ThoiKhoaBieu>[];
    Object? scheduleError;
    var notifications = <NotificationItem>[];
    Object? notificationError;
    var shortcuts = buildDefaultHomeShortcutPreferences(catalog);
    Object? shortcutError;

    try {
      todaySchedule = await _dataSource.loadTodaySchedule();
      todaySchedule = todaySchedule.where(_isDisplayableSchedule).toList()
        ..sort((a, b) => a.tietBatDau.compareTo(b.tietBatDau));
    } catch (error) {
      scheduleError = error;
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
    }

    try {
      shortcuts = normalizeHomeShortcutPreferences(
        catalog,
        await _dataSource.loadShortcutPreferences(),
      );
    } catch (error) {
      shortcutError = error;
    }

    return HomeDashboardState(
      todaySchedule: todaySchedule,
      scheduleError: scheduleError,
      notifications: notifications,
      notificationError: notificationError,
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

  bool _isDisplayableSchedule(ThoiKhoaBieu item) {
    return item.soTiet > 0 && item.tenMon.trim().isNotEmpty;
  }
}
