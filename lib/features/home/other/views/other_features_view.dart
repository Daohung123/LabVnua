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
            _buildQuickSummary(
              primaryColor: primaryColor,
              cardColor: cardColor,
              borderColor: borderColor,
              mutedTextColor: subtitleColor,
            ),
            const SizedBox(height: 22),

            // Section: TIỆN ÍCH SINH VIÊN
            _buildSectionHeader(
              title: 'TIỆN ÍCH SINH VIÊN',
              subtitle: 'Các công cụ hỗ trợ học tập và sinh hoạt hằng ngày',
              mutedTextColor: subtitleColor,
            ),
            const SizedBox(height: 22),

            // Section: HỖ TRỢ & TƯƠNG TÁC
            _buildSectionHeader(
              title: 'HỖ TRỢ & TƯƠNG TÁC',
              subtitle: 'Kênh liên hệ và công cụ hỗ trợ người dùng',
              mutedTextColor: subtitleColor,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.apps_rounded, color: Colors.white, size: 32),
              const SizedBox(width: 12),
              const Text(
                'Các tính năng khác',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Khám phá thêm nhiều công cụ hữu ích hỗ trợ sinh hoạt',
            style: TextStyle(
              fontSize: 13.5,
              color: Colors.white.withOpacity(0.92),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickSummary({
    required Color primaryColor,
    required Color cardColor,
    required Color borderColor,
    required Color mutedTextColor,
  }) {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            icon: Icons.map_outlined,
            title: 'Bản đồ',
            value: '10',
            accentColor: const Color(0xff2563EB),
            cardColor: cardColor,
            borderColor: borderColor,
            mutedTextColor: mutedTextColor,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildSummaryCard(
            icon: Icons.support_agent_rounded,
            title: 'Hỗ trợ',
            value: '24/7',
            accentColor: const Color(0xff10B981),
            cardColor: cardColor,
            borderColor: borderColor,
            mutedTextColor: mutedTextColor,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildSummaryCard(
            icon: Icons.smart_toy_outlined,
            title: 'AI Chat',
            value: '∞',
            accentColor: const Color(0xffF59E0B),
            cardColor: cardColor,
            borderColor: borderColor,
            mutedTextColor: mutedTextColor,
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
    required Color cardColor,
    required Color borderColor,
    required Color mutedTextColor,
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
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
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
    required Color mutedTextColor,
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
}
