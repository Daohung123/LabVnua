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
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false, // Căn trái
        backgroundColor: primaryColor, // Màu xanh đồng bộ dự án
        surfaceTintColor: primaryColor,
        foregroundColor: Colors.white,
        title: const Text(
          'Tính năng khác',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: 0.2,
            color: Colors.white, // Chữ trắng
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final isSmall = width < 420;
          final isMedium = width >= 420 && width < 900;

          final horizontalPadding = isSmall ? 12.0 : 16.0;
          final topPadding = 16.0;

          return ListView(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              topPadding,
              horizontalPadding,
              16,
            ),
            children: [
              _buildBanner(isSmall),
              const SizedBox(height: 16),

              _buildSection(
                title: 'TIỆN ÍCH SINH VIÊN',
                subtitle: 'Các công cụ hỗ trợ học tập và sinh hoạt hằng ngày',
                items: [
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
                ],
                width: width,
                isSmall: isSmall,
                isMedium: isMedium,
              ),

              const SizedBox(height: 18),

              _buildSection(
                title: 'HỖ TRỢ & TƯƠNG TÁC',
                subtitle: 'Kênh liên hệ và công cụ hỗ trợ người dùng',
                items: [
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
                ],
                width: width,
                isSmall: isSmall,
                isMedium: isMedium,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBanner(bool isSmall) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 66,
          height: 66,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.16),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.2,
            ),
          ),
          child: const Icon(Icons.apps_rounded, color: Colors.white, size: 34),
        ),
        const SizedBox(width: 0, height: 14),
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
            color: Colors.white.withOpacity(0.9),
            fontSize: 13.5,
            height: 1.4,
          ),
        ),
      ],
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmall ? 16 : 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor,
            primaryColor.withOpacity(0.88),
            const Color(0xff355070),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.18),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: isSmall
          ? content
          : Row(
              children: [
                Container(
                  width: 66,
                  height: 66,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1.2,
                    ),
                  ),
                  child: const Icon(
                    Icons.apps_rounded,
                    color: Colors.white,
                    size: 34,
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
                          color: Colors.white.withOpacity(0.9),
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

  Widget _buildSection({
    required String title,
    required String subtitle,
    required List<_FeatureItem> items,
    required double width,
    required bool isSmall,
    required bool isMedium,
  }) {
    final crossAxisCount = width < 380
        ? 2
        : width < 600
        ? 3
        : width < 900
        ? 4
        : 5;

    final childAspectRatio = width < 380
        ? 0.92
        : width < 600
        ? 0.95
        : 1.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontSize: isSmall ? 14.8 : 15.5,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: subtitleColor,
              fontSize: isSmall ? 12.2 : 12.5,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: childAspectRatio,
            ),
            itemBuilder: (context, index) {
              return _buildFeatureTile(items[index], isSmall);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureTile(_FeatureItem item, bool isSmall) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isSmall ? 8 : 10,
          vertical: isSmall ? 10 : 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: isSmall ? 42 : 46,
              height: isSmall ? 42 : 46,
              decoration: BoxDecoration(
                color: item.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                item.icon,
                color: item.color,
                size: isSmall ? 21 : 23,
              ),
            ),
            SizedBox(height: isSmall ? 8 : 10),
            Text(
              item.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: isSmall ? 11.3 : 12.3,
                fontWeight: FontWeight.w700,
                color: titleColor,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.subtitle,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: isSmall ? 10.0 : 10.8,
                color: subtitleColor,
                height: 1.25,
              ),
            ),
          ],
        ),
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
