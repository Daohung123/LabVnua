import 'package:aqedu/features/infor/screens/view_inforStudent.dart';
import 'package:aqedu/features/schedure/screens/study_view_day_month.dart';
import 'package:aqedu/features/score_data/screens/view_score_student.dart';
import 'package:flutter/material.dart';

class HocTapView extends StatelessWidget {
  const HocTapView({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xff0047A8);
    final Color textBlue = const Color(0xff355070);
    final Color backgroundColor = const Color(0xffF5F8FC);
    final Color cardColor = Colors.white;
    final Color borderColor = const Color(0xffE4EAF2);
    final Color mutedTextColor = const Color(0xff6B7280);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false, // ← Căn trái
        backgroundColor: primaryColor, // ← Màu xanh theo dự án
        surfaceTintColor: primaryColor,
        foregroundColor: Colors.white, // ← Chữ trắng cho dễ nhìn
        title: const Text(
          'Học tập',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
            color: Colors.white, // Đảm bảo chữ trắng
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            _buildHeroHeader(primaryColor, textBlue),
            const SizedBox(height: 16),
            _buildQuickSummary(
              primaryColor: primaryColor,
              cardColor: cardColor,
              borderColor: borderColor,
              mutedTextColor: mutedTextColor,
            ),
            const SizedBox(height: 22),

            _buildSectionHeader(
              title: 'HỌC VỤ',
              subtitle:
                  'Các chức năng liên quan đến đào tạo và kết quả học tập',
              mutedTextColor: mutedTextColor,
            ),
            _buildCard(
              cardColor: cardColor,
              borderColor: borderColor,
              children: [
                _buildActionTile(
                  icon: Icons.school_outlined,
                  title: 'CT đào tạo',
                  subtitle: 'Xem chương trình đào tạo và lộ trình học',
                  primaryColor: primaryColor,
                  mutedTextColor: mutedTextColor,
                  onTap: () {},
                ),
                _buildDivider(borderColor),
                _buildActionTile(
                  icon: Icons.list_alt_outlined,
                  title: 'Môn tiên quyết',
                  subtitle: 'Kiểm tra các môn cần học trước',
                  primaryColor: primaryColor,
                  mutedTextColor: mutedTextColor,
                  onTap: () {},
                ),
                _buildDivider(borderColor),
                _buildActionTile(
                  icon: Icons.calendar_today_outlined,
                  title: 'KQ điểm danh',
                  subtitle: 'Theo dõi kết quả điểm danh theo lớp học',
                  primaryColor: primaryColor,
                  mutedTextColor: mutedTextColor,
                  onTap: () {},
                ),
                _buildDivider(borderColor),
                _buildActionTile(
                  icon: Icons.grade_outlined,
                  title: 'Xem điểm',
                  subtitle: 'Tra cứu điểm thành phần và điểm tổng kết',
                  primaryColor: primaryColor,
                  mutedTextColor: mutedTextColor,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ScoreStudentView(),
                      ),
                    );
                  },
                ),
                _buildDivider(borderColor),
                _buildActionTile(
                  icon: Icons.checklist_rtl_outlined,
                  title: 'Điểm rèn luyện',
                  subtitle: 'Xem kết quả rèn luyện của sinh viên',
                  primaryColor: primaryColor,
                  mutedTextColor: mutedTextColor,
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 18),
            _buildSectionHeader(
              title: 'LỊCH HỌC – THI CỬ',
              subtitle: 'Xem lịch học và lịch thi theo ngày hoặc theo học kỳ',
              mutedTextColor: mutedTextColor,
            ),
            _buildCard(
              cardColor: cardColor,
              borderColor: borderColor,
              children: [
                _buildActionTile(
                  icon: Icons.today_outlined,
                  title: 'TKB ngày',
                  subtitle: 'Xem thời khóa biểu trong ngày',
                  primaryColor: primaryColor,
                  mutedTextColor: mutedTextColor,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ScheduleScreen(),
                      ),
                    );
                  },
                ),
                _buildDivider(borderColor),
                _buildActionTile(
                  icon: Icons.calendar_month_outlined,
                  title: 'TKB học kỳ',
                  subtitle: 'Xem thời khóa biểu theo học kỳ',
                  primaryColor: primaryColor,
                  mutedTextColor: mutedTextColor,
                  onTap: () {},
                ),
                _buildDivider(borderColor),
                _buildActionTile(
                  icon: Icons.access_time_outlined,
                  title: 'Lịch thi',
                  subtitle: 'Theo dõi lịch thi sắp tới',
                  primaryColor: primaryColor,
                  mutedTextColor: mutedTextColor,
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 18),
            _buildSectionHeader(
              title: 'ĐĂNG KÝ & THỦ TỤC',
              subtitle: 'Các mục đăng ký môn học và thủ tục học vụ',
              mutedTextColor: mutedTextColor,
            ),
            _buildCard(
              cardColor: cardColor,
              borderColor: borderColor,
              children: [
                _buildActionTile(
                  icon: Icons.edit_calendar_outlined,
                  title: 'ĐK môn học',
                  subtitle: 'Đăng ký hoặc điều chỉnh môn học',
                  primaryColor: primaryColor,
                  mutedTextColor: mutedTextColor,
                  onTap: () {},
                ),
                _buildDivider(borderColor),
                _buildActionTile(
                  icon: Icons.favorite_border,
                  title: 'ĐK môn nguyện vọng',
                  subtitle: 'Đăng ký môn theo nguyện vọng của bạn',
                  primaryColor: primaryColor,
                  mutedTextColor: mutedTextColor,
                  onTap: () {},
                ),
              ],
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
              Icon(Icons.school_rounded, color: Colors.white, size: 32),
              const SizedBox(width: 12),
              const Text(
                'Học tập & Khảo thí',
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
            'Quản lý học vụ, lịch học, điểm và các thủ tục liên quan',
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
            icon: Icons.calendar_today_outlined,
            title: 'Lịch học',
            value: '12',
            accentColor: const Color(0xff2563EB),
            cardColor: cardColor,
            borderColor: borderColor,
            mutedTextColor: mutedTextColor,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildSummaryCard(
            icon: Icons.grade_outlined,
            title: 'Điểm TB',
            value: '7.8',
            accentColor: const Color(0xff10B981),
            cardColor: cardColor,
            borderColor: borderColor,
            mutedTextColor: mutedTextColor,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildSummaryCard(
            icon: Icons.assignment_outlined,
            title: 'Môn học',
            value: '5',
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

  Widget _buildCard({
    required Color cardColor,
    required Color borderColor,
    required List<Widget> children,
  }) {
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
    required Color primaryColor,
    required Color mutedTextColor,
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

  Widget _buildDivider(Color borderColor) {
    return Divider(height: 1, color: borderColor, indent: 14, endIndent: 14);
  }
}
