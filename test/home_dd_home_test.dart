import 'dart:async';

import 'package:aqedu/features/home/home_view/components/home_models.dart';
import 'package:aqedu/features/home/home_view/components/home_quick_actions.dart';
import 'package:aqedu/features/home/home_view/components/home_shortcut_catalog.dart';
import 'package:aqedu/features/home/home_view/controllers/home_dashboard_controller.dart';
import 'package:aqedu/features/home/home_view/screens/student_home_view.dart';
import 'package:aqedu/features/notification/models/notification_student.dart';
import 'package:aqedu/features/schedure/models/Schedure_Student.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DD_HOME dashboard', () {
    testWidgets(
      'shows loaded schedule, deadline empty state, and notification',
      (tester) async {
        await _pumpHome(
          tester,
          FakeHomeDashboardDataSource(
            schedules: [
              _schedule('Trí tuệ nhân tạo', startPeriod: 6),
              _schedule('Cơ sở dữ liệu', startPeriod: 1),
            ],
            notifications: [
              NotificationItem(
                id: 'n1',
                tieuDe: 'Thông báo đào tạo',
                noiDung: '<p>Nội dung mới</p>',
                ngayGui: DateTime(2026, 7, 3),
                isDaDoc: false,
              ),
            ],
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Lịch hôm nay'), findsOneWidget);
        expect(find.text('Cơ sở dữ liệu'), findsOneWidget);
        expect(find.text('Trí tuệ nhân tạo'), findsOneWidget);
        expect(find.text('Chưa có nguồn deadline chính thức'), findsOneWidget);
        expect(find.text('1 thông báo chưa đọc'), findsOneWidget);
        expect(find.text('Thông báo đào tạo'), findsOneWidget);
        expect(
          find.byKey(const Key('home-shortcut-tile-schedule')),
          findsOneWidget,
        );
      },
    );

    testWidgets('shows loading state while dashboard data is pending', (
      tester,
    ) async {
      final completer = Completer<List<ThoiKhoaBieu>>();
      final source = FakeHomeDashboardDataSource(scheduleCompleter: completer);

      await _pumpHome(tester, source);
      await tester.pump();

      expect(find.text('Đang tải trang chủ...'), findsOneWidget);

      completer.complete(const []);
      await tester.pumpAndSettle();
    });

    testWidgets('shows empty schedule state', (tester) async {
      await _pumpHome(tester, FakeHomeDashboardDataSource());
      await tester.pumpAndSettle();

      expect(find.text('Hôm nay không có lịch học'), findsOneWidget);
    });

    testWidgets('shows schedule error without hiding other sections', (
      tester,
    ) async {
      await _pumpHome(
        tester,
        FakeHomeDashboardDataSource(scheduleError: Exception('offline')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Không thể tải lịch hôm nay'), findsOneWidget);
      expect(find.text('Lối tắt'), findsOneWidget);
      expect(find.text('Thông báo'), findsOneWidget);
    });
  });

  group('DD_HOME shortcuts', () {
    testWidgets('prevents enabling more than 8 shortcuts', (tester) async {
      final catalog = _fakeCatalog(9);
      final preferences = [
        for (var index = 0; index < 9; index++)
          HomeShortcutPreference(
            key: 'k$index',
            sortOrder: index,
            enabled: index < 8,
          ),
      ];
      var saved = <HomeShortcutPreference>[];

      await _pumpShortcuts(
        tester,
        catalog: catalog,
        preferences: preferences,
        onSaved: (value) => saved = value,
      );

      await tester.tap(find.byKey(const Key('home-shortcuts-edit-toggle')));
      await tester.pumpAndSettle();
      final editScrollable = find
          .descendant(
            of: find.byType(HomeQuickActions),
            matching: find.byType(Scrollable),
          )
          .last;
      await tester.scrollUntilVisible(
        find.byKey(const Key('shortcut-toggle-k8')),
        120,
        scrollable: editScrollable,
      );
      await tester.tap(find.byKey(const Key('shortcut-toggle-k8')));
      await tester.pumpAndSettle();

      expect(find.text('Tối đa 8 lối tắt được bật'), findsOneWidget);
      expect(saved, isEmpty);
    });

    testWidgets('persists shortcut ordering after move action', (tester) async {
      final catalog = _fakeCatalog(2);
      final preferences = [
        const HomeShortcutPreference(key: 'k0', sortOrder: 0, enabled: true),
        const HomeShortcutPreference(key: 'k1', sortOrder: 1, enabled: true),
      ];
      var saved = <HomeShortcutPreference>[];

      await _pumpShortcuts(
        tester,
        catalog: catalog,
        preferences: preferences,
        onSaved: (value) => saved = value,
      );

      await tester.tap(find.byKey(const Key('home-shortcuts-edit-toggle')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('shortcut-move-down-k0')));
      await tester.pumpAndSettle();

      expect(saved.map((item) => item.key), ['k1', 'k0']);
      expect(saved.map((item) => item.sortOrder), [0, 1]);
    });
  });
}

Future<void> _pumpHome(
  WidgetTester tester,
  FakeHomeDashboardDataSource source,
) async {
  await tester.binding.setSurfaceSize(const Size(900, 1200));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    MaterialApp(
      home: HomeStudent(
        controller: HomeDashboardController(
          dataSource: source,
          catalog: kHomeShortcutCatalog,
        ),
      ),
    ),
  );
}

Future<void> _pumpShortcuts(
  WidgetTester tester, {
  required List<HomeShortcutDefinition> catalog,
  required List<HomeShortcutPreference> preferences,
  required ValueChanged<List<HomeShortcutPreference>> onSaved,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: HomeQuickActions(
            catalog: catalog,
            preferences: preferences,
            onPreferencesChanged: (value) async => onSaved(value),
          ),
        ),
      ),
    ),
  );
}

ThoiKhoaBieu _schedule(String subject, {required int startPeriod}) {
  return ThoiKhoaBieu(
    thu: 2,
    tietBatDau: startPeriod,
    soTiet: 3,
    tenMon: subject,
    giangVien: 'Giảng viên',
    phong: 'A101',
    ngayhoc: '2026-07-03',
  );
}

List<HomeShortcutDefinition> _fakeCatalog(int count) {
  return [
    for (var index = 0; index < count; index++)
      HomeShortcutDefinition(
        key: 'k$index',
        label: 'Mục $index',
        icon: Icons.apps,
        color: Colors.blue,
        builder: (_) => const SizedBox.shrink(),
      ),
  ];
}

class FakeHomeDashboardDataSource implements HomeDashboardDataSource {
  FakeHomeDashboardDataSource({
    this.schedules = const [],
    this.notifications = const [],
    this.shortcutPreferences,
    this.scheduleError,
    this.notificationError,
    this.shortcutError,
    this.scheduleCompleter,
  });

  final List<ThoiKhoaBieu> schedules;
  final List<NotificationItem> notifications;
  final List<HomeShortcutPreference>? shortcutPreferences;
  final Object? scheduleError;
  final Object? notificationError;
  final Object? shortcutError;
  final Completer<List<ThoiKhoaBieu>>? scheduleCompleter;
  List<HomeShortcutPreference> savedPreferences = const [];

  @override
  Future<List<ThoiKhoaBieu>> loadTodaySchedule() async {
    if (scheduleCompleter != null) return scheduleCompleter!.future;
    if (scheduleError != null) throw scheduleError!;
    return schedules;
  }

  @override
  Future<List<NotificationItem>> loadNotifications() async {
    if (notificationError != null) throw notificationError!;
    return notifications;
  }

  @override
  Future<List<HomeShortcutPreference>> loadShortcutPreferences() async {
    if (shortcutError != null) throw shortcutError!;
    return shortcutPreferences ??
        buildDefaultHomeShortcutPreferences(kHomeShortcutCatalog);
  }

  @override
  Future<void> saveShortcutPreferences(
    List<HomeShortcutPreference> preferences,
  ) async {
    savedPreferences = preferences;
  }
}
