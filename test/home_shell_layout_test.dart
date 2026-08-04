import 'dart:io';

import 'package:aqedu/features/home/setting/screens/view_student_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('settings logout remains reachable on a short viewport', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    var logoutCalled = false;
    await tester.pumpWidget(
      MaterialApp(
        home: SettingsView(
          logoutHandler: (_) async {
            logoutCalled = true;
            return true;
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('settings-appbar-logout')),
      findsOneWidget,
    );

    final logout = find.byKey(const Key('settings-logout-button'));
    await tester.scrollUntilVisible(
      logout,
      280,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(logout, findsOneWidget);
    final rect = tester.getRect(logout);
    expect(rect.bottom, lessThanOrEqualTo(640));

    await tester.tap(logout);
    await tester.pumpAndSettle();
    expect(logoutCalled, isTrue);
  });

  test('mobile shell reserves navigation and removes fixed FAB offset', () {
    final source = File(
      'lib/features/home/home_screen/screens/student_home_screen_view.dart',
    ).readAsStringSync();

    expect(source, contains('bottomNavigationBar: wide'));
    expect(source, contains('_kMobileFabClearance'));
    expect(source, isNot(contains('bottom: 98')));
  });
}
