import 'package:flutter/material.dart';

class OtherFeaturesView extends StatelessWidget {
  const OtherFeaturesView({super.key});

  final Color primaryColor = const Color(0xff0047A8);
  final Color backgroundColor = const Color(0xffF5F8FC);
  final Color cardColor = Colors.white;
  final Color borderColor = const Color(0xffE5EAF0);
  final Color titleColor = const Color(0xff111827);
  final Color subtitleColor = const Color(0xff6B7280);

  @override
  Widget build(BuildContext context) {
    // Layout structured like study_view.dart but content preserved
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: primaryColor,
        surfaceTintColor: primaryColor,
        foregroundColor: Colors.white,
        title: const Text(
          'Tính năng khác',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: 0.2,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            _buildHeroHeader(primaryColor, const Color(0xff355070)),
            const SizedBox(height: 16),
            const SizedBox(height: 22),

            // Section: TIỆN ÍCH SINH VIÊN (rendered as card + ListTiles to match study_view)
            _buildSectionHeader(
              title: 'TIỆN ÍCH SINH VIÊN',
              subtitle: 'Các công cụ hỗ trợ học tập và sinh hoạt hằng ngày',
              mutedTextColor: subtitleColor,
            ),
            _buildCard(
              cardColor: cardColor,
              borderColor: borderColor,
              children: _featureItemsToTiles([
                _FeatureItem(
                  title: 'Bản đồ trường',
                  subtitle: 'Xem khuôn viên, tòa nhà',
                  icon: Icons.map_outlined,
                  color: const Color(0xff2563EB),
                  onTap: () {},
                ),
                _FeatureItem(
                  title: 'Sơ đồ phòng học',
                  subtitle: 'Tra cứu vị trí phòng học',
                  icon: Icons.apartment_outlined,
                  color: const Color(0xff4F46E5),
                  onTap: () {},
                ),
                _FeatureItem(
                  title: 'Tìm phòng học',
                  subtitle: 'Tìm nhanh theo mã phòng',
                  icon: Icons.search_rounded,
                  color: const Color(0xff06B6D4),
                  onTap: () {},
                ),
                _FeatureItem(
                  title: 'Tra cứu giảng viên',
                  subtitle: 'Thông tin giảng viên',
                  icon: Icons.person_search_outlined,
                  color: const Color(0xff8B5CF6),
                  onTap: () {},
                ),
                _FeatureItem(
                  title: 'Danh bạ sinh viên',
                  subtitle: 'Tra cứu liên hệ',
                  icon: Icons.contacts_outlined,
                  color: const Color(0xff14B8A6),
                  onTap: () {},
                ),
                _FeatureItem(
                  title: 'Xe bus trường',
                  subtitle: 'Tuyến xe và lịch chạy',
                  icon: Icons.directions_bus_outlined,
                  color: const Color(0xffF59E0B),
                  onTap: () {},
                ),
                _FeatureItem(
                  title: 'Ký túc xá',
                  subtitle: 'Thông tin khu ở',
                  icon: Icons.home_work_outlined,
                  color: const Color(0xff10B981),
                  onTap: () {},
                ),
                _FeatureItem(
                  title: 'Căn tin / dịch vụ',
                  subtitle: 'Ăn uống, tiện ích',
                  icon: Icons.restaurant_menu_outlined,
                  color: const Color(0xffEF4444),
                  onTap: () {},
                ),
                _FeatureItem(
                  title: 'Wifi campus',
                  subtitle: 'Thông tin kết nối mạng',
                  icon: Icons.wifi_rounded,
                  color: const Color(0xff0EA5E9),
                  onTap: () {},
                ),
              ]),
            ),

            const SizedBox(height: 18),

            // Section: HỖ TRỢ & TƯƠNG TÁC
            _buildSectionHeader(
              title: 'HỖ TRỢ & TƯƠNG TÁC',
              subtitle: 'Kênh liên hệ và công cụ hỗ trợ người dùng',
              mutedTextColor: subtitleColor,
            ),
            _buildCard(
              cardColor: cardColor,
              borderColor: borderColor,
              children: _featureItemsToTiles([
                _FeatureItem(
                  title: 'Chat phòng đào tạo',
                  subtitle: 'Hỏi đáp thủ tục',
                  icon: Icons.support_agent_rounded,
                  color: const Color(0xff2563EB),
                  onTap: () {},
                ),
                _FeatureItem(
                  title: 'Chat giảng viên',
                  subtitle: 'Trao đổi học tập',
                  icon: Icons.chat_bubble_outline_rounded,
                  color: const Color(0xff4F46E5),
                  onTap: () {},
                ),
                _FeatureItem(
                  title: 'Chatbot hỗ trợ (AI)',
                  subtitle: 'Hỗ trợ tự động 24/7',
                  icon: Icons.smart_toy_outlined,
                  color: const Color(0xff8B5CF6),
                  onTap: () {},
                ),
                _FeatureItem(
                  title: 'FAQ',
                  subtitle: 'Câu hỏi thường gặp',
                  icon: Icons.help_outline_rounded,
                  color: const Color(0xffF59E0B),
                  onTap: () {},
                ),
                _FeatureItem(
                  title: 'Gửi phản hồi',
                  subtitle: 'Đóng góp ý kiến',
                  icon: Icons.feedback_outlined,
                  color: const Color(0xff10B981),
                  onTap: () {},
                ),
                _FeatureItem(
                  title: 'Báo lỗi hệ thống',
                  subtitle: 'Gửi lỗi nhanh',
                  icon: Icons.bug_report_outlined,
                  color: const Color(0xffEF4444),
                  onTap: () {},
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroHeader(Color primaryColor, Color textBlue) {
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
              Icons.apps_rounded,
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
                  'Tổng hợp tiện ích',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Truy cập nhanh các chức năng hỗ trợ học tập, sinh hoạt và tương tác trong ứng dụng.',
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

  

  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required String value,
    required Color accentColor,
    required Color cardColor,
    required Color borderColor,
    required Color mutedTextColor,
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
    required Color mutedTextColor,
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

  Widget _buildCard({
    required Color cardColor,
    required Color borderColor,
    required List<Widget> children,
  }) {
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

  List<Widget> _featureItemsToTiles(List<_FeatureItem> items) {
    final List<Widget> widgets = [];
    for (var i = 0; i < items.length; i++) {
      widgets.add(_buildActionTile(
        icon: items[i].icon,
        title: items[i].title,
        subtitle: items[i].subtitle,
        primaryColor: items[i].color,
        mutedTextColor: subtitleColor,
        onTap: items[i].onTap,
      ));
      if (i != items.length - 1) widgets.add(_buildDivider(borderColor));
    }
    return widgets;
  }

  Widget _buildDivider(Color borderColor) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Divider(height: 1, thickness: 1, color: borderColor),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color primaryColor,
    required Color mutedTextColor,
    required VoidCallback onTap,
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
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: Colors.grey.shade400,
        size: 24,
      ),
    );
  }
}

class _FeatureItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  _FeatureItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}
