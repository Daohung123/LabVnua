import 'package:aqedu/features/infor/screens/view_inforStudent.dart';
import 'package:aqedu/features/schedure/screens/study_view_day_month.dart';
import 'package:aqedu/features/score_data/screens/view_score_student.dart';
import 'package:aqedu/features/score_data/screens/view_study_analyst.dart';
import 'package:aqedu/features/tuition/screens/view_tuition.dart';
import 'package:flutter/material.dart';
import 'package:aqedu/features/program_training/screens/program_training_view.dart';
import '../../../prerequisite_subjects/screens/view_prequisite_subjects.dart';
import '../../../course_register/screens/view_courses_register.dart';

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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProgramTrainingView(),
                      ),
                    );
                  },
                ),
                _buildDivider(borderColor),
                _buildActionTile(
                  icon: Icons.list_alt_outlined,
                  title: 'Môn tiên quyết',
                  subtitle: 'Kiểm tra các môn cần học trước',
                  primaryColor: primaryColor,
                  mutedTextColor: mutedTextColor,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PrerequisiteView(),
                      ),
                    );
                  },
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CourseRegisterView(),
                      ),
                    );
                  },
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

            const SizedBox(height: 18),
            _buildSectionHeader(
              title: 'CÁ NHÂN & TIỆN ÍCH',
              subtitle: 'Thông tin cá nhân và các công cụ hỗ trợ',
              mutedTextColor: mutedTextColor,
            ),
            _buildCard(
              cardColor: cardColor,
              borderColor: borderColor,
              children: [
                _buildActionTile(
                  icon: Icons.poll_outlined,
                  title: 'Khảo sát',
                  subtitle: 'Tham gia các khảo sát từ nhà trường',
                  primaryColor: primaryColor,
                  mutedTextColor: mutedTextColor,
                  onTap: () {},
                ),
                _buildDivider(borderColor),
                _buildActionTile(
                  icon: Icons.account_box_outlined,
                  title: 'Lý lịch',
                  subtitle: 'Xem và cập nhật thông tin cá nhân',
                  primaryColor: primaryColor,
                  mutedTextColor: mutedTextColor,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InforStudentView(),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 18),
            _buildSectionHeader(
              title: 'TÀI CHÍNH – HỌC PHÍ',
              subtitle:
                  'Theo dõi và thực hiện các thao tác liên quan đến học phí',
              mutedTextColor: mutedTextColor,
            ),
            _buildCard(
              cardColor: cardColor,
              borderColor: borderColor,
              children: [
                _buildActionTile(
                  icon: Icons.monetization_on_outlined,
                  title: 'Học phí',
                  subtitle: 'Xem tình trạng và chi tiết học phí',
                  primaryColor: primaryColor,
                  mutedTextColor: mutedTextColor,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HocPhiView(),
                      ),
                    );
                  },
                ),
                _buildDivider(borderColor),
                _buildActionTile(
                  icon: Icons.payments_outlined,
                  title: 'Đóng học phí',
                  subtitle: 'Thực hiện thanh toán học phí trực tuyến',
                  primaryColor: primaryColor,
                  mutedTextColor: mutedTextColor,
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 18),
            _buildSectionHeader(
              title: 'TIỆN ÍCH NÂNG CAO',
              subtitle: 'Các tính năng hỗ trợ học tập nâng cao',
              mutedTextColor: mutedTextColor,
            ),
            _buildCard(
              cardColor: cardColor,
              borderColor: borderColor,
              children: [
                _buildActionTile(
                  icon: Icons.bar_chart_outlined,
                  title: 'Phân tích học tập',
                  subtitle: 'Xem thống kê và biểu đồ kết quả học tập',
                  primaryColor: primaryColor,
                  mutedTextColor: mutedTextColor,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ScoreAnalysisView(),
                      ),
                    );
                  },
                ),
                _buildDivider(borderColor),
                _buildActionTile(
                  icon: Icons.menu_book_outlined,
                  title: 'Kho học liệu',
                  subtitle: 'Tài nguyên học tập và tài liệu tham khảo',
                  primaryColor: primaryColor,
                  mutedTextColor: mutedTextColor,
                  onTap: () {},
                ),
                _buildDivider(borderColor),
                _buildActionTile(
                  icon: Icons.auto_awesome_outlined,
                  title: 'AI học tập',
                  subtitle: 'Trợ lý hỗ trợ học tập thông minh',
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
                  'Cổng học tập',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Truy cập nhanh các chức năng học vụ, lịch học và học phí',
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
}
