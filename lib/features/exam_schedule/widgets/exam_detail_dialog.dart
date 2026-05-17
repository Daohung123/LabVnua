import 'package:flutter/material.dart';
import '../models/model_main_object.dart';

class ExamDetailDialog extends StatelessWidget {
  final LichThi exam;

  const ExamDetailDialog({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Chi tiết lịch thi",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Divider(),
              _buildDetailItem("Tên môn", exam.tenMon),
              _buildDetailItem("Mã môn", exam.maMon),
              _buildDetailItem("Ngày thi", exam.ngayThi),
              _buildDetailItem("Giờ bắt đầu", exam.gioBatDau),
              _buildDetailItem("Số phút", exam.soPhut),
              _buildDetailItem("Phòng thi", exam.maPhong),
              _buildDetailItem("Hình thức thi", exam.hinhThucThi),
              _buildDetailItem("Sĩ số", exam.siSo?.toString() ?? "N/A"),
              _buildDetailItem("Số tiết", exam.soTiet ?? "N/A"),
              _buildDetailItem("Tổ thi", exam.toThi ?? "N/A"),
              _buildDetailItem("Ghi chú", exam.ghiChu ?? ""),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Đóng",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value.isEmpty ? "Chưa có dữ liệu" : value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
