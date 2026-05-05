import 'package:flutter/material.dart';
import 'row_info.dart';

class StudentInfoCard extends StatelessWidget {
  final Map<String, String> student;

  const StudentInfoCard({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black12,
            offset: Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        children: [

          RowInfo(
            left: "Ngày sinh",
            right: student["ngaySinh"]!,
          ),

          RowInfo(
            left: "Giới tính",
            right: student["gioiTinh"]!,
          ),

          const RowInfo(
            left: "Trạng thái",
            right: "Đang học",
          ),

          RowInfo(
            left: "Lớp",
            right: student["lop"]!,
          ),

          RowInfo(
            left: "Khoa",
            right: student["khoa"]!,
          ),

          RowInfo(
            left: "Hệ đào tạo",
            right: student["heDaoTao"]!,
          ),

          RowInfo(
            left: "Ngành",
            right: student["nganh"]!,
          ),

          RowInfo(
            left: "Niên khóa",
            right: student["nienKhoa"]!,
          ),
        ],
      ),
    );
  }
}