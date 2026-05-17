import 'package:flutter/material.dart';
import 'package:aqedu/core/theme/app_theme.dart';
import 'package:aqedu/core/theme/app_text_styles.dart';
import 'package:aqedu/core/widgets/appBar/avt.dart';
import 'package:aqedu/core/widgets/appBar/name_user.dart';
import 'package:aqedu/core/widgets/appBar/time_fomat.dart';
import 'package:aqedu/features/infor/services/service_sqlite_informationStudent.dart';
import 'package:aqedu/features/infor/models/models_inforStudent.dart';

class HomeHeroHeader extends StatefulWidget {
  const HomeHeroHeader({super.key});

  @override
  State<HomeHeroHeader> createState() => _HomeHeroHeaderState();
}

class _HomeHeroHeaderState extends State<HomeHeroHeader> {
  String _fullName = "";

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    // Thử load từ DB
    final student = await ServiceSqlInformationStudent.getAllInformation();
    if (student != null && mounted) {
      setState(() {
        _fullName = student.tenDayDu;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hiển thị tên thật lấy từ DB
                    UserGreeting(
                      firstName: _fullName.isNotEmpty ? _fullName.split(' ').last : '',
                      middleName: '',
                      lastName: _fullName.isNotEmpty ? _fullName.split(' ').first : 'Sinh viên',
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Text(
                      'Chúc bạn học tập hiệu quả',
                      style: AppTextStyles.heroSubtitle,
                    ),
                    SizedBox(height: AppSpacing.lg),
                    const TimeFormat(
                      leading: Icon(Icons.access_time_rounded, size: 18, color: Colors.black),
                      backgroundColor: Colors.white,
                      textStyle: TextStyle(fontSize: 11, color: Colors.black, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              _buildStatusChip('Đang hoạt động'),
              SizedBox(width: AppSpacing.sm),
              _buildStatusChip(_fullName.isNotEmpty ? 'Đã đồng bộ' : 'Đang đồng bộ...'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(AppOpacity.bg10),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: Colors.white.withOpacity(AppOpacity.bg12)),
      ),
      child: Text(text, style: AppTextStyles.chipText.copyWith(fontSize: 11.5)),
    );
  }
}
