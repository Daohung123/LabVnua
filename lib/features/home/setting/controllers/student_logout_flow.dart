import 'package:aqedu/core/logging/app_log.dart';
import 'package:aqedu/core/theme/app_components.dart';
import 'package:aqedu/features/auth/student/screens/student_login_view.dart';
import 'package:aqedu/features/home/setting/controllers/controller_settings.dart';
import 'package:flutter/material.dart';

class StudentLogoutFlow {
  const StudentLogoutFlow._();

  static bool _isRunning = false;

  static Future<bool> confirmAndLogout(BuildContext context) async {
    if (_isRunning) return false;
    _isRunning = true;

    try {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            icon: const Icon(
              Icons.logout_rounded,
              color: AppColors.error,
              size: 32,
            ),
            title: const Text('Đăng xuất khỏi EduAI?'),
            content: const Text(
              'Phiên đăng nhập trên thiết bị sẽ được xoá và bạn cần đăng nhập lại để tiếp tục sử dụng ứng dụng.',
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Huỷ'),
              ),
              FilledButton.icon(
                key: const Key('confirm-student-logout'),
                onPressed: () => Navigator.of(dialogContext).pop(true),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: AppColors.white,
                ),
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Đăng xuất'),
              ),
            ],
          );
        },
      );

      if (confirmed != true || !context.mounted) return false;

      await ControllerSettings.logOut();
      AppLog.coSoDuLieu(
        'Đã xoá session khi đăng xuất',
        khuVuc: 'Đăng xuất sinh viên',
        ketQua: 'Chuyển người dùng về màn hình đăng nhập.',
      );

      if (!context.mounted) return true;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
        (_) => false,
      );
      return true;
    } catch (error, stackTrace) {
      AppLog.loi(
        'Không thể đăng xuất sinh viên',
        khuVuc: 'Đăng xuất sinh viên',
        loi: error,
        stackTrace: stackTrace,
      );
      if (context.mounted) {
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          const SnackBar(
            content: Text('Không thể đăng xuất. Vui lòng thử lại.'),
          ),
        );
      }
      return false;
    } finally {
      _isRunning = false;
    }
  }
}
