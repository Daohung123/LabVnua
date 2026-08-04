import 'package:aqedu/features/infor/models/model_infor_student_fill.dart';
import 'package:flutter/material.dart';
import 'row_info.dart';

import 'package:aqedu/core/theme/app_components.dart';
class StudentInfoCard extends StatelessWidget {
  final InforStudentFillData student;

  const StudentInfoCard({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: const [
          BoxShadow(blurRadius: 8, color: AppColors.black12, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          RowInfo(left: "Ngày sinh", right: student.ngaySinh),
          RowInfo(left: "Giới tính", right: student.gioiTinh),
          RowInfo(left: "Trạng thái", right: student.trangThai),
          RowInfo(left: "Lớp", right: student.lop),
          RowInfo(left: "Khoa", right: student.khoa),
          RowInfo(left: "Hệ đào tạo", right: student.heDaoTao),
          RowInfo(left: "Ngành", right: student.nganh),
          RowInfo(left: "Niên khóa", right: student.nienKhoa),
        ],
      ),
    );
  }
}
