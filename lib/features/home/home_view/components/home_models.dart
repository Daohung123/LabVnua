import 'package:aqedu/features/notification/models/notification_student.dart';
import 'package:aqedu/features/schedure/models/schedure_student.dart';
import 'package:aqedu/features/task/domain/entities/local_task.dart';
import 'package:flutter/material.dart';

const int kHomeMaxEnabledShortcuts = 8;

const List<String> kDefaultHomeShortcutKeys = [
  'schedule',
  'scores',
  'tuition',
  'ai',
];

class HomeShortcutDefinition {
  const HomeShortcutDefinition({
    required this.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.builder,
  });

  final String key;
  final String label;
  final IconData icon;
  final Color color;
  final WidgetBuilder builder;
}

class HomeShortcutPreference {
  const HomeShortcutPreference({
    required this.key,
    required this.sortOrder,
    required this.enabled,
  });

  final String key;
  final int sortOrder;
  final bool enabled;

  HomeShortcutPreference copyWith({int? sortOrder, bool? enabled}) {
    return HomeShortcutPreference(
      key: key,
      sortOrder: sortOrder ?? this.sortOrder,
      enabled: enabled ?? this.enabled,
    );
  }
}

class HomeDashboardState {
  const HomeDashboardState({
    required this.todaySchedule,
    required this.notifications,
    required this.upcomingTasks,
    required this.shortcutPreferences,
    this.scheduleError,
    this.notificationError,
    this.taskError,
    this.shortcutError,
  });

  final List<ThoiKhoaBieu> todaySchedule;
  final Object? scheduleError;
  final List<NotificationItem> notifications;
  final Object? notificationError;
  final List<LocalTask> upcomingTasks;
  final Object? taskError;
  final List<HomeShortcutPreference> shortcutPreferences;
  final Object? shortcutError;

  bool get hasScheduleError => scheduleError != null;
  bool get hasNotificationError => notificationError != null;
  bool get hasTaskError => taskError != null;
}

List<HomeShortcutPreference> buildDefaultHomeShortcutPreferences(
  List<HomeShortcutDefinition> catalog,
) {
  return catalog.map((definition) {
    final defaultIndex = kDefaultHomeShortcutKeys.indexOf(definition.key);
    final isDefault = defaultIndex >= 0;
    return HomeShortcutPreference(
      key: definition.key,
      sortOrder: isDefault
          ? defaultIndex
          : catalog.length + catalog.indexOf(definition),
      enabled: isDefault,
    );
  }).toList()..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
}

List<HomeShortcutPreference> normalizeHomeShortcutPreferences(
  List<HomeShortcutDefinition> catalog,
  List<HomeShortcutPreference> stored,
) {
  final storedByKey = {
    for (final preference in stored) preference.key: preference,
  };
  final defaults = buildDefaultHomeShortcutPreferences(catalog);
  final defaultByKey = {
    for (final preference in defaults) preference.key: preference,
  };

  final merged = <HomeShortcutPreference>[];
  for (final definition in catalog) {
    final storedPreference = storedByKey[definition.key];
    final defaultPreference = defaultByKey[definition.key]!;
    merged.add(
      HomeShortcutPreference(
        key: definition.key,
        sortOrder: storedPreference?.sortOrder ?? defaultPreference.sortOrder,
        enabled: storedPreference?.enabled ?? defaultPreference.enabled,
      ),
    );
  }

  merged.sort((a, b) {
    final orderCompare = a.sortOrder.compareTo(b.sortOrder);
    if (orderCompare != 0) return orderCompare;
    return a.key.compareTo(b.key);
  });

  var enabledCount = 0;
  final capped = <HomeShortcutPreference>[];
  for (var index = 0; index < merged.length; index++) {
    final preference = merged[index];
    final enabled =
        preference.enabled && enabledCount < kHomeMaxEnabledShortcuts;
    if (enabled) enabledCount++;
    capped.add(
      HomeShortcutPreference(
        key: preference.key,
        sortOrder: index,
        enabled: enabled,
      ),
    );
  }
  return capped;
}

List<HomeShortcutDefinition> enabledHomeShortcutDefinitions(
  List<HomeShortcutDefinition> catalog,
  List<HomeShortcutPreference> preferences,
) {
  final catalogByKey = {
    for (final definition in catalog) definition.key: definition,
  };
  final normalized = normalizeHomeShortcutPreferences(catalog, preferences);
  return normalized
      .where((preference) => preference.enabled)
      .map((preference) => catalogByKey[preference.key])
      .whereType<HomeShortcutDefinition>()
      .toList();
}
