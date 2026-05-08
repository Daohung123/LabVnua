import 'package:aqedu/features/auth/student/screens/role_view.dart';
import 'package:aqedu/features/home/controllers/controller_home.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final Color primaryColor = const Color(0xff0047A8);
  final Color textBlue = const Color(0xff355070);

  final Color backgroundColor = const Color(0xffF5F8FC);
  final Color cardColor = Colors.white;
  final Color borderColor = const Color(0xffE4EAF2);
  final Color mutedTextColor = const Color(0xff6B7280);

  bool notifySchedule = true;
  bool notifyTuition = false;
  bool notifyNews = true;
  bool soundEnabled = true;
  bool vibrationEnabled = false;
  bool darkMode = false;
  bool biometricLogin = true;
  bool autoSync = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false, // Căn trái
        backgroundColor: primaryColor, // Màu xanh đồng bộ dự án
        surfaceTintColor: primaryColor,
        foregroundColor: Colors.white,
        title: const Text(
          'Cài đặt',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
            color: Colors.white, // Chữ trắng
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 16),
            _buildQuickSummary(),
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
        gradient: LinearGradient(
          colors: [primaryColor, primaryColor.withOpacity(0.92), textBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.18),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.16),
              border: Border.all(
                color: Colors.white.withOpacity(0.22),
                width: 1.2,
              ),
            ),
            child: const Icon(
              Icons.school_rounded,
              color: Colors.white,
              size: 36,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sinh viên VNUA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Cổng thông tin đào tạo',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.88),
                    fontSize: 13.5,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _buildHeaderChip('Đang hoạt động'),
                    const SizedBox(width: 8),
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

  Widget _buildQuickSummary() {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            icon: Icons.notifications_active_outlined,
            title: 'Thông báo',
            value: '3',
            accentColor: const Color(0xff0EA5E9),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            icon: Icons.lock_outline_rounded,
            title: 'Bảo mật',
            value: 'Tốt',
            accentColor: const Color(0xff10B981),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            icon: Icons.sync_rounded,
            title: 'Đồng bộ',
            value: 'Mới',
            accentColor: const Color(0xff8B5CF6),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required String value,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: accentColor, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xff111827),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.5,
              color: mutedTextColor,
              fontWeight: FontWeight.w500,
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
              color: Color(0xff111827),
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
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
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
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
          color: primaryColor.withOpacity(0.10),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: primaryColor, size: 23),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xff111827),
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
            color: Colors.grey.shade400,
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
          color: primaryColor.withOpacity(0.10),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: primaryColor, size: 23),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xff111827),
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
      inactiveThumbColor: Colors.grey.shade500,
      inactiveTrackColor: Colors.grey.shade300,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: () {
          ControllerHome.logOut();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => RoleView()),
          );
        },
        icon: const Icon(Icons.logout_rounded),
        label: const Text(
          'Đăng xuất',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xffDC2626),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xffFECACA)),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
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
        color: const Color(0xffEEF4FF),
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
