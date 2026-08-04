import 'package:aqedu/core/logging/app_log.dart';
import 'package:aqedu/features/qr_code/screens/view_qr_code.dart';
import 'package:flutter/material.dart';
import 'package:aqedu/core/theme/app_theme.dart';
import 'package:aqedu/core/theme/app_text_styles.dart';
import 'package:aqedu/core/widgets/appBar/notification.dart';
import 'package:aqedu/core/widgets/appBar/scan.dart';
import 'package:aqedu/features/home/setting/controllers/student_logout_flow.dart';
import 'package:aqedu/features/home/setting/screens/view_student_setting.dart';
import 'package:aqedu/features/notification/screens/view_noti_student.dart';

/// AppBar component cho Home Student
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key, this.onSettingsPressed, this.onLogoutPressed});

  final VoidCallback? onSettingsPressed;
  final VoidCallback? onLogoutPressed;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      centerTitle: false,
      backgroundColor: AppColors.primary,
      surfaceTintColor: AppColors.transparent,
      titleSpacing: AppSpacing.lg,
      title: Text(
        'Trang chủ',
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.heroTitle.copyWith(
          fontSize: 20,
          letterSpacing: 0.2,
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              NotificationButton(
                onPressed: () {
                  AppLog.thaoTacNguoiDung(
                    'Người dùng mở trung tâm thông báo từ thanh trên',
                    khuVuc: 'Thanh trên trang chủ',
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationView(),
                    ),
                  );
                },
              ),
              SizedBox(width: AppSpacing.xs),
              QRScanButton(
                onPressed: () {
                  AppLog.thaoTacNguoiDung(
                    'Người dùng mở màn hình quét QR',
                    khuVuc: 'Thanh trên trang chủ',
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const QRScannerView()),
                  );
                },
              ),
              SizedBox(width: AppSpacing.xs),
              _AvatarMenuButton(
                onSettingsPressed: onSettingsPressed,
                onLogoutPressed: onLogoutPressed,
              ),
              SizedBox(width: AppSpacing.sm),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

enum _AvatarMenuAction { settings, logout }

class _AvatarMenuButton extends StatelessWidget {
  const _AvatarMenuButton({this.onSettingsPressed, this.onLogoutPressed});

  final VoidCallback? onSettingsPressed;
  final VoidCallback? onLogoutPressed;

  void _openSettings(BuildContext context) {
    AppLog.thaoTacNguoiDung(
      'Người dùng mở cài đặt từ menu tài khoản',
      khuVuc: 'Menu tài khoản',
    );
    if (onSettingsPressed != null) {
      onSettingsPressed!();
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SettingsView()),
    );
  }

  Future<void> _logout(BuildContext context) async {
    AppLog.thaoTacNguoiDung(
      'Người dùng chọn đăng xuất từ menu tài khoản',
      khuVuc: 'Menu tài khoản',
    );
    if (onLogoutPressed != null) {
      onLogoutPressed!();
      return;
    }

    await StudentLogoutFlow.confirmAndLogout(context);
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_AvatarMenuAction>(
      tooltip: 'Tài khoản',
      offset: const Offset(0, 48),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
      onSelected: (action) {
        AppLog.thaoTacNguoiDung(
          'Người dùng chọn mục trong menu tài khoản',
          khuVuc: 'Menu tài khoản',
          duLieu: {'hanh_dong': action.name},
        );
        switch (action) {
          case _AvatarMenuAction.settings:
            _openSettings(context);
            break;
          case _AvatarMenuAction.logout:
            _logout(context);
            break;
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem<_AvatarMenuAction>(
          enabled: false,
          child: _AvatarProfileSummary(),
        ),
        PopupMenuDivider(height: 8),
        PopupMenuItem<_AvatarMenuAction>(
          value: _AvatarMenuAction.settings,
          child: _AvatarMenuItem(
            icon: Icons.settings_outlined,
            label: 'Cài đặt',
          ),
        ),
        PopupMenuItem<_AvatarMenuAction>(
          enabled: false,
          child: _AvatarMenuItem(
            icon: Icons.lock_outline_rounded,
            label: 'Đổi mật khẩu',
            helper: 'Chưa có màn hình',
          ),
        ),
        PopupMenuDivider(height: 8),
        PopupMenuItem<_AvatarMenuAction>(
          value: _AvatarMenuAction.logout,
          child: _AvatarMenuItem(
            icon: Icons.logout_rounded,
            label: 'Đăng xuất',
            color: AppColors.error,
          ),
        ),
      ],
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.14),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.white.withValues(alpha: 0.24)),
        ),
        child: const Icon(
          Icons.account_circle_rounded,
          color: AppColors.white,
          size: 28,
        ),
      ),
    );
  }
}

class _AvatarProfileSummary extends StatelessWidget {
  const _AvatarProfileSummary();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.primary.withValues(alpha: 0.12),
          child: const Icon(Icons.school_rounded, color: AppColors.primary),
        ),
        const SizedBox(width: AppSpacing.md),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sinh viên VNUA',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Đang hoạt động',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AvatarMenuItem extends StatelessWidget {
  const _AvatarMenuItem({
    required this.icon,
    required this.label,
    this.helper,
    this.color,
  });

  final IconData icon;
  final String label;
  final String? helper;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.textPrimary;
    return Row(
      children: [
        Icon(icon, color: effectiveColor, size: 20),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: effectiveColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (helper != null) ...[
                const SizedBox(height: 2),
                Text(
                  helper!,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
