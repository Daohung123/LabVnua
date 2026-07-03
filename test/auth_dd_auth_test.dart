import 'package:aqedu/features/auth/student/screens/student_login_view.dart';
import 'package:aqedu/features/home/home_view/components/home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DD_AUTH login screen', () {
    testWidgets('shows login form and disabled VNied option', (tester) async {
      await tester.binding.setSurfaceSize(const Size(900, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(home: LoginScreen(loginHandler: (_, _) async => false)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Đăng nhập'), findsWidgets);
      expect(find.text('Đăng nhập VNied'), findsOneWidget);
      expect(find.text('Chờ cấu hình OAuth2'), findsOneWidget);
      expect(find.text('Tài khoản'), findsOneWidget);
      expect(find.text('Mật khẩu'), findsOneWidget);

      final vniedButtonFinder = find.byKey(const Key('vnied-login-disabled'));
      expect(vniedButtonFinder, findsOneWidget);

      final vniedButton = tester.widget<OutlinedButton>(vniedButtonFinder);
      expect(vniedButton.onPressed, isNull);
    });

    testWidgets('empty submit validates locally without calling login', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(900, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      var called = false;

      await tester.pumpWidget(
        MaterialApp(
          home: LoginScreen(
            loginHandler: (_, _) async {
              called = true;
              return true;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Đăng nhập'));
      await tester.pump();

      expect(called, isFalse);
      expect(
        find.text('Vui lòng nhập mã sinh viên / giảng viên'),
        findsOneWidget,
      );
      expect(find.text('Vui lòng nhập mật khẩu'), findsOneWidget);
    });
  });

  group('DD_AUTH avatar menu', () {
    testWidgets('opens menu and invokes logout callback', (tester) async {
      var logoutCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: HomeAppBar(
              onLogoutPressed: () {
                logoutCalled = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byTooltip('Tài khoản'));
      await tester.pumpAndSettle();

      expect(find.text('Sinh viên VNUA'), findsOneWidget);
      expect(find.text('Cài đặt'), findsOneWidget);
      expect(find.text('Đổi mật khẩu'), findsOneWidget);
      expect(find.text('Chưa có màn hình'), findsOneWidget);
      expect(find.text('Đăng xuất'), findsOneWidget);

      await tester.tap(find.text('Đăng xuất'));
      await tester.pumpAndSettle();

      expect(logoutCalled, isTrue);
    });
  });
}
