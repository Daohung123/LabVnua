import 'package:flutter/material.dart';

import 'package:aqedu/core/theme/app_components.dart';
class OtherFeaturesView extends StatelessWidget {
  const OtherFeaturesView({super.key});

  final Color primaryColor = AppColors.primary;
  final Color backgroundColor = AppColors.background;
  final Color cardColor = AppColors.white;
  final Color borderColor = AppColors.border;
  final Color titleColor = AppColors.textPrimary;
  final Color subtitleColor = AppColors.textSecondary;

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
        foregroundColor: AppColors.white,
        title: const Text(
          'Tính năng khác',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: 0.2,
            color: AppColors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            _buildHeroHeader(primaryColor, AppColors.textSecondary),
            const SizedBox(height: AppSpacing.lg),
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
                  color: AppColors.primary,
                  onTap: () {},
                ),
                _FeatureItem(
                  title: 'Sơ đồ phòng học',
                  subtitle: 'Tra cứu vị trí phòng học',
                  icon: Icons.apartment_outlined,
                  color: AppColors.ai,
                  onTap: () {},
                ),
                _FeatureItem(
                  title: 'Tìm phòng học',
                  subtitle: 'Tìm nhanh theo mã phòng',
                  icon: Icons.search_rounded,
                  color: AppColors.primary,
                  onTap: () {},
                ),
                _FeatureItem(
                  title: 'Tra cứu giảng viên',
                  subtitle: 'Thông tin giảng viên',
                  icon: Icons.person_search_outlined,
                  color: AppColors.ai,
                  onTap: () {},
                ),
                _FeatureItem(
                  title: 'Danh bạ sinh viên',
                  subtitle: 'Tra cứu liên hệ',
                  icon: Icons.contacts_outlined,
                  color: AppColors.success,
                  onTap: () {},
                ),
                _FeatureItem(
                  title: 'Xe bus trường',
                  subtitle: 'Tuyến xe và lịch chạy',
                  icon: Icons.directions_bus_outlined,
                  color: AppColors.warning,
                  onTap: () {},
                ),
                _FeatureItem(
                  title: 'Ký túc xá',
                  subtitle: 'Thông tin khu ở',
                  icon: Icons.home_work_outlined,
                  color: AppColors.success,
                  onTap: () {},
                ),
                _FeatureItem(
                  title: 'Căn tin / dịch vụ',
                  subtitle: 'Ăn uống, tiện ích',
                  icon: Icons.restaurant_menu_outlined,
                  color: AppColors.error,
                  onTap: () {},
                ),
                _FeatureItem(
                  title: 'Wifi campus',
                  subtitle: 'Thông tin kết nối mạng',
                  icon: Icons.wifi_rounded,
                  color: AppColors.primary,
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
                  color: AppColors.primary,
                  onTap: () {},
                ),
                _FeatureItem(
                  title: 'Chat giảng viên',
                  subtitle: 'Trao đổi học tập',
                  icon: Icons.chat_bubble_outline_rounded,
                  color: AppColors.ai,
                  onTap: () {},
                ),
                _FeatureItem(
                  title: 'Chatbot hỗ trợ (AI)',
                  subtitle: 'Hỗ trợ tự động 24/7',
                  icon: Icons.smart_toy_outlined,
                  color: AppColors.ai,
                  onTap: () {},
                ),
                _FeatureItem(
                  title: 'FAQ',
                  subtitle: 'Câu hỏi thường gặp',
                  icon: Icons.help_outline_rounded,
                  color: AppColors.warning,
                  onTap: () {},
                ),
                _FeatureItem(
                  title: 'Gửi phản hồi',
                  subtitle: 'Đóng góp ý kiến',
                  icon: Icons.feedback_outlined,
                  color: AppColors.success,
                  onTap: () {},
                ),
                _FeatureItem(
                  title: 'Báo lỗi hệ thống',
                  subtitle: 'Gửi lỗi nhanh',
                  icon: Icons.bug_report_outlined,
                  color: AppColors.error,
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
              color: AppColors.white.withOpacity(0.16),
              border: Border.all(
                color: AppColors.white.withOpacity(0.22),
                width: 1.2,
              ),
            ),
            child: const Icon(
              Icons.apps_rounded,
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
                  'Tổng hợp tiện ích',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Truy cập nhanh các chức năng hỗ trợ học tập, sinh hoạt và tương tác trong ứng dụng.',
                  style: TextStyle(
                    color: AppColors.white.withOpacity(0.88),
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
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.04),
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
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(icon, color: accentColor, size: 22),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
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

  Widget _buildCard({
    required Color cardColor,
    required Color borderColor,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.04),
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
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: AppColors.textTertiary,
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
