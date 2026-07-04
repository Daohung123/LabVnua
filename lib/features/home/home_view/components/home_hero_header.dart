import 'package:aqedu/core/widgets/appBar/name_user.dart';
import 'package:aqedu/features/infor/controllers/ctrls_infor_student.dart';
import 'package:flutter/material.dart';
import 'package:aqedu/core/theme/app_theme.dart';
import 'package:aqedu/core/theme/app_text_styles.dart';
import 'package:aqedu/core/widgets/appBar/avt.dart';
import 'package:aqedu/core/widgets/appBar/time_fomat.dart';
import 'package:aqedu/features/infor/models/model_infor_student_fill.dart';

class HomeHeroHeader extends StatelessWidget {
  const HomeHeroHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<InforStudentFillData?>(
      future: CtrlInforStudent.getInforStudent(),
      builder: (context, snapshot) {
        /// Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }

        /// Data
        final student = snapshot.data;

        /// SỬA FIELD NÀY ĐÚNG VỚI MODEL CỦA BẠN
        final String fullName = student?.name?.toString().trim() ?? 'Sinh viên';

        /// Tách tên
        final List<String> parts = fullName
            .split(RegExp(r'\s+'))
            .where((e) => e.isNotEmpty)
            .toList();

        final String firstName = parts.isNotEmpty ? parts.last : '';
        final String middleName = parts.length > 2
            ? parts.sublist(1, parts.length - 1).join(' ')
            : '';

        final String lastName = parts.isNotEmpty ? parts.first : '';

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
                  /// Avatar
                  Container(
                    padding: EdgeInsets.all(AppSpacing.xs),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(AppOpacity.bg12),
                      border: Border.all(
                        color: Colors.white.withOpacity(AppOpacity.bg14),
                        width: 1.3,
                      ),
                    ),
                    child: const UserAvatar(imagePath: 'assets/avt.jpg'),
                  ),

                  SizedBox(width: AppSpacing.lg),

                  /// User info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        UserGreeting(
                          firstName: firstName,
                          middleName: middleName,
                          lastName: lastName,
                        ),

                        SizedBox(height: AppSpacing.sm),

                        Text(
                          'Chúc bạn học tập hiệu quả',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.heroSubtitle,
                        ),

                        SizedBox(height: AppSpacing.lg),

                        const TimeFormat(
                          leading: Icon(
                            Icons.access_time_rounded,
                            size: 18,
                            color: Colors.black,
                          ),
                          backgroundColor: Colors.white,
                          textStyle: TextStyle(
                            fontSize: 11,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppSpacing.lg),

              /// Status chips
              Row(
                children: [
                  _buildStatusChip('Đang hoạt động'),
                  SizedBox(width: AppSpacing.sm),
                  _buildStatusChip('Đã đồng bộ'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildStatusChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(AppOpacity.bg10),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: Colors.white.withOpacity(AppOpacity.bg12)),
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
}
