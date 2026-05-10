import 'package:aqedu/features/auth/student/screens/role_view.dart';
import 'package:aqedu/features/home/settings/controllers/controller_settings.dart';
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
        centerTitle: false,
        backgroundColor: primaryColor,
        surfaceTintColor: primaryColor,
        foregroundColor: Colors.white,
        title: const Text(
          'Cài đặt',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
            color: Colors.white,
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
        const SizedBox(width: 10),
        Expanded(
          child: _buildSummaryCard(
            icon: Icons.security_outlined,
            title: 'Bảo mật',
            value: 'Tốt',
            accentColor: const Color(0xff10B981),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildSummaryCard(
            icon: Icons.storage_outlined,
            title: 'Lưu trữ',
            value: '2.4GB',
            accentColor: const Color(0xffF59E0B),
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: accentColor, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 11.5,
              color: mutedTextColor,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(fontSize: 12.5, color: mutedTextColor, height: 1.4),
        ),
      ],
    );
  }

  Widget _buildCard({required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: cardColor,
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: primaryColor, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12.5, color: mutedTextColor),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_outlined,
        size: 14,
        color: mutedTextColor,
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: primaryColor, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12.5, color: mutedTextColor),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: primaryColor,
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, color: borderColor, indent: 14, endIndent: 14);
  }

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            await ControllerSettings.logOut();
            if (mounted) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout_rounded, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'Đăng xuất',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
