import 'package:aqedu/core/logging/app_log.dart';
import 'package:aqedu/features/infor/models/model_infor_student_fill.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/UI/styles/colors.dart';

class ProfileCard extends StatelessWidget {
  final InforStudentFillData student;

  const ProfileCard({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: darkCard,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const CircleAvatar(radius: 34, child: Icon(Icons.person, size: 38)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  student.maSv,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              AppLog.thaoTacNguoiDung(
                'Người dùng bấm nút QR trong thẻ hồ sơ',
                khuVuc: 'Thông tin sinh viên',
                duLieu: {'co_ma_sinh_vien': student.maSv.trim().isNotEmpty},
              );
            },
            icon: const Icon(Icons.qr_code_2, color: Colors.white, size: 36),
          ),
        ],
      ),
    );
  }
}
