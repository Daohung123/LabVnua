import 'package:aqedu/features/home/setting/controllers/student_logout_flow.dart';
import 'package:flutter/material.dart';

import 'package:aqedu/core/theme/app_components.dart';

typedef SettingsLogoutHandler = Future<bool> Function(BuildContext context);

class SettingsView extends StatefulWidget {
  const SettingsView({super.key, this.logoutHandler});

  final SettingsLogoutHandler? logoutHandler;

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final Color primaryColor = AppColors.primary;
  final Color textBlue = AppColors.textSecondary;

  final Color backgroundColor = AppColors.background;
  final Color cardColor = AppColors.white;
  final Color borderColor = AppColors.border;
  final Color mutedTextColor = AppColors.textSecondary;

  bool notifySchedule = true;
  bool notifyTuition = false;
  bool notifyNews = true;
  bool soundEnabled = true;
  bool vibrationEnabled = false;
  bool darkMode = false;
  bool biometricLogin = true;
  bool autoSync = true;
  bool _isLoggingOut = false;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false, // Căn trái
        backgroundColor: primaryColor, // Màu xanh đồng bộ dự án
        surfaceTintColor: primaryColor,
        foregroundColor: AppColors.white,
        title: const Text(
          'Cài đặt',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
            color: AppColors.white, // Chữ trắng
          ),
        ),
        actions: [
          IconButton(
            key: const Key('settings-appbar-logout'),
            tooltip: 'Đăng xuất',
            onPressed: _isLoggingOut ? null : _handleLogout,
            icon: _isLoggingOut
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.white,
                    ),
                  )
                : const Icon(Icons.logout_rounded),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 32 + bottomInset),
          children: [
            _buildProfileHeader(),
            const SizedBox(height: AppSpacing.lg),
            const SizedBox(height: 22),

            _buildSectionHeader(
              title: 'Tài khoản',
              subtitle: 'Quản lý thông tin và bảo mật đăng nhập',
            ),
            _buildCard(
              children: [
                _buildActionTile(
                  icon: Icons.person_outline_rounded,
                  title: 'Thông tin cá nhân',
                  subtitle: 'Cập nhật họ tên, mã sinh viên, lớp, khoa',
                  onTap: () {},
                ),
                _buildDivider(),
                _buildActionTile(
                  icon: Icons.badge_outlined,
                  title: 'Hồ sơ học tập',
                  subtitle: 'Xem trạng thái học tập và thông tin liên quan',
                  onTap: () {},
                ),
                _buildDivider(),
                _buildActionTile(
                  icon: Icons.lock_outline_rounded,
                  title: 'Đổi mật khẩu',
                  subtitle: 'Thay đổi mật khẩu đăng nhập hệ thống',
                  onTap: () {},
                ),
                _buildDivider(),
                _buildSwitchTile(
                  icon: Icons.fingerprint_rounded,
                  title: 'Đăng nhập sinh trắc học',
                  subtitle: 'Dùng vân tay / Face ID để mở ứng dụng',
                  value: biometricLogin,
                  onChanged: (value) => setState(() => biometricLogin = value),
                ),
              ],
            ),

            const SizedBox(height: 18),
            _buildSectionHeader(
              title: 'Thông báo',
              subtitle: 'Tùy chỉnh cách ứng dụng gửi thông báo',
            ),
            _buildCard(
              children: [
                _buildSwitchTile(
                  icon: Icons.schedule_outlined,
                  title: 'Nhắc lịch học',
                  subtitle: 'Thông báo khi có lịch học mới hoặc thay đổi',
                  value: notifySchedule,
                  onChanged: (value) => setState(() => notifySchedule = value),
                ),
                _buildDivider(),
                _buildSwitchTile(
                  icon: Icons.attach_money_outlined,
                  title: 'Học phí',
                  subtitle: 'Cảnh báo khi có cập nhật về học phí',
                  value: notifyTuition,
                  onChanged: (value) => setState(() => notifyTuition = value),
                ),
                _buildDivider(),
                _buildSwitchTile(
                  icon: Icons.campaign_outlined,
                  title: 'Tin tức / Thông báo',
                  subtitle: 'Nhận thông báo từ nhà trường và khoa',
                  value: notifyNews,
                  onChanged: (value) => setState(() => notifyNews = value),
                ),
                _buildDivider(),
                _buildSwitchTile(
                  icon: Icons.volume_up_outlined,
                  title: 'Âm thanh thông báo',
                  subtitle: 'Phát âm thanh khi có sự kiện mới',
                  value: soundEnabled,
                  onChanged: (value) => setState(() => soundEnabled = value),
                ),
                _buildDivider(),
                _buildSwitchTile(
                  icon: Icons.vibration_rounded,
                  title: 'Rung khi có thông báo',
                  subtitle: 'Tăng khả năng nhận biết khi đang dùng điện thoại',
                  value: vibrationEnabled,
                  onChanged: (value) =>
                      setState(() => vibrationEnabled = value),
                ),
              ],
            ),

            const SizedBox(height: 18),
            _buildSectionHeader(
              title: 'Giao diện & đồng bộ',
              subtitle: 'Điều chỉnh trải nghiệm sử dụng của bạn',
            ),
            _buildCard(
              children: [
                _buildSwitchTile(
                  icon: Icons.dark_mode_outlined,
                  title: 'Chế độ tối',
                  subtitle: 'Sử dụng giao diện tối cho buổi tối',
                  value: darkMode,
                  onChanged: (value) => setState(() => darkMode = value),
                ),
                _buildDivider(),
                _buildSwitchTile(
                  icon: Icons.sync_outlined,
                  title: 'Tự động đồng bộ',
                  subtitle: 'Làm mới dữ liệu khi mở ứng dụng',
                  value: autoSync,
                  onChanged: (value) => setState(() => autoSync = value),
                ),
                _buildDivider(),
                _buildActionTile(
                  icon: Icons.language_rounded,
                  title: 'Ngôn ngữ',
                  subtitle: 'Tiếng Việt',
                  trailing: _buildTrailingValue('VI'),
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 18),
            _buildSectionHeader(
              title: 'Hỗ trợ',
              subtitle: 'Thông tin ứng dụng và các tiện ích khác',
            ),
            _buildCard(
              children: [
                _buildActionTile(
                  icon: Icons.help_outline_rounded,
                  title: 'Trợ giúp',
                  subtitle: 'Hướng dẫn sử dụng và câu hỏi thường gặp',
                  onTap: () {},
                ),
                _buildDivider(),
                _buildActionTile(
                  icon: Icons.feedback_outlined,
                  title: 'Gửi phản hồi',
                  subtitle: 'Góp ý để cải thiện ứng dụng',
                  onTap: () {},
                ),
                _buildDivider(),
                _buildActionTile(
                  icon: Icons.info_outline_rounded,
                  title: 'Về ứng dụng',
                  subtitle: 'Phiên bản, điều khoản, chính sách',
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 22),
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.mediumShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white.withValues(alpha: 0.16),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.22),
                width: 1.2,
              ),
            ),
            child: const Icon(
              Icons.school_rounded,
              color: AppColors.white,
              size: 36,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sinh viên VNUA',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Cổng thông tin đào tạo',
                  style: TextStyle(
                    color: AppColors.white.withValues(alpha: 0.88),
                    fontSize: 13.5,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _buildHeaderChip('Đang hoạt động'),
                    const SizedBox(width: AppSpacing.sm),
                    _buildHeaderChip('Đã đồng bộ'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            subtitle,
            style: TextStyle(
              color: mutedTextColor,
              fontSize: 12.5,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Divider(height: 1, thickness: 1, color: borderColor),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: primaryColor.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Icon(icon, color: primaryColor, size: 23),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 14.5,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Text(
          subtitle,
          style: TextStyle(color: mutedTextColor, fontSize: 12.5, height: 1.3),
        ),
      ),
      trailing:
          trailing ??
          Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textTertiary,
            size: 24,
          ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      secondary: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: primaryColor.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Icon(icon, color: primaryColor, size: 23),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 14.5,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Text(
          subtitle,
          style: TextStyle(color: mutedTextColor, fontSize: 12.5, height: 1.3),
        ),
      ),
      activeThumbColor: primaryColor,
      inactiveThumbColor: AppColors.textSecondary,
      inactiveTrackColor: AppColors.border,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Future<void> _handleLogout() async {
    if (_isLoggingOut) return;

    setState(() => _isLoggingOut = true);
    final handler = widget.logoutHandler ?? StudentLogoutFlow.confirmAndLogout;
    try {
      await handler(context);
    } finally {
      if (mounted) {
        setState(() => _isLoggingOut = false);
      }
    }
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        key: const Key('settings-logout-button'),
        onPressed: _isLoggingOut ? null : _handleLogout,
        icon: _isLoggingOut
            ? const SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.logout_rounded),
        label: Text(
          _isLoggingOut ? 'Đang đăng xuất...' : 'Đăng xuất',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.error,
          disabledBackgroundColor: AppColors.surfaceAlt,
          disabledForegroundColor: AppColors.textTertiary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            side: const BorderSide(color: AppColors.errorLight),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.18)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTrailingValue(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: primaryColor,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
