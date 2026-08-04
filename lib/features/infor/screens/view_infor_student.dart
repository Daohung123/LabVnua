import 'package:aqedu/features/infor/controllers/ctrls_infor_student.dart';
import 'package:aqedu/features/infor/models/model_infor_student_fill.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/components/app_card.dart';
import '../../../core/widgets/components/app_section_header.dart';
import '../../../core/widgets/appBar/avt.dart';
import '../../../core/widgets/appBar/name_user.dart';
import '../../../core/widgets/appBar/time_fomat.dart';
import '../components/student_info_card.dart';

/// ========================================
/// STUDENT INFORMATION VIEW — Personal Profile Dashboard
/// ========================================
///
/// Redesigned to match the style of student_home_view.dart with:
/// - Hero header with gradient background and user info
/// - Quick stats section with key metrics
/// - Detailed information cards
/// - Achievements/progress section for added interest
/// - Consistent theming and clean code structure

class InforStudentView extends StatefulWidget {
  const InforStudentView({super.key});

  @override
  State<InforStudentView> createState() => _InforStudentViewState();
}

class _InforStudentViewState extends State<InforStudentView> {
  InforStudentFillData? student;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    ;
    final result = await CtrlInforStudent.getInforStudent();
    if (result == null) {
      setState(() {
        isLoading = false;
        errorMessage = "Không tải được thông tin sinh viên.";
      });
      return;
    }

    setState(() {
      student = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (student == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(),
        body: Center(
          child: Text(
            errorMessage ?? 'Đã xảy ra lỗi khi lấy dữ liệu.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.screenPadding,
          children: [
            _buildHeroHeader(),
            SizedBox(height: AppSpacing.xl),
            AppSectionHeader(
              title: 'Thông tin cá nhân',
              subtitle: 'Chi tiết hồ sơ sinh viên',
            ),
            _buildPersonalInfo(),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // APP BAR
  // ─────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      centerTitle: false,
      backgroundColor: AppColors.primary,
      surfaceTintColor: AppColors.transparent,
      titleSpacing: AppSpacing.lg,
      title: Text(
        'Thông tin cá nhân',
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.heroTitle.copyWith(
          fontSize: 20,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // HERO HEADER — Gradient background with user info
  // ─────────────────────────────────────────
  Widget _buildHeroHeader() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        gradient: AppGradients.heroGradient,
        boxShadow: AppShadows.heroShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              Container(
                padding: EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white.withOpacity(AppOpacity.bg12),
                  border: Border.all(
                    color: AppColors.white.withOpacity(AppOpacity.bg14),
                    width: 1.3,
                  ),
                ),
                child: const UserAvatar(imagePath: 'assets/avt.jpg'),
              ),

              SizedBox(width: AppSpacing.lg),

              // User info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserGreeting(
                      firstName: student!.name.split(' ').last,
                      middleName: '',
                      lastName: student!.name.split(' ').first,
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Text(
                      'Sinh viên ${student!.khoa}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.heroSubtitle,
                    ),
                    SizedBox(height: AppSpacing.lg),
                    const TimeFormat(
                      leading: Icon(
                        Icons.access_time_rounded,
                        size: 18,
                        color: AppColors.black,
                      ),
                      backgroundColor: AppColors.white,
                      textStyle: TextStyle(
                        fontSize: 11,
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: AppSpacing.lg),

          // Status chips
          Row(children: [_chip('Đang học')]),
        ],
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(AppOpacity.bg10),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: AppColors.white.withOpacity(AppOpacity.bg12)),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.chipText.copyWith(
          fontSize: 11.5,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // PERSONAL INFO — Detailed student information
  // ─────────────────────────────────────────
  Widget _buildPersonalInfo() {
    return AppCard(
      borderRadius: AppRadius.xl,
      padding: EdgeInsets.all(AppSpacing.lg),
      child: StudentInfoCard(student: student!),
    );
  }
}
