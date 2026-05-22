import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/ctrls_ semester_timetable.dart';
import '../models/model_semester_timetable.dart';

class SemesterTimetableView extends StatelessWidget {
  const SemesterTimetableView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FakeSemesterTimetableController()..loadData(),
      child: const _SemesterTimetableBody(),
    );
  }
}

class _SemesterTimetableBody extends StatelessWidget {
  const _SemesterTimetableBody();

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<FakeSemesterTimetableController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Thời khóa biểu"), centerTitle: true),

      body: controller.loading
          ? const Center(child: CircularProgressIndicator())
          : controller.list.isEmpty
          ? const Center(child: Text("Không có dữ liệu"))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: controller.list.length,

              itemBuilder: (context, index) {
                final SemesterTimetableItem item = controller.list[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(16),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        // tên môn
                        Text(
                          item.tenMon ?? "",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // mã môn
                        Text("Mã môn: ${item.maMon ?? ""}"),

                        const SizedBox(height: 4),

                        // thứ
                        Text("Thứ: ${item.thu ?? ""}"),

                        const SizedBox(height: 4),

                        // tiết
                        Text(
                          "Tiết: "
                          "${item.tietBatDau ?? ""}"
                          " - "
                          "${(item.tietBatDau ?? 0) + (item.soTiet ?? 0) - 1}",
                        ),

                        const SizedBox(height: 4),

                        // giờ học
                        Text(
                          "Giờ: "
                          "${item.tuGio ?? ""}"
                          " - "
                          "${item.denGio ?? ""}",
                        ),

                        const SizedBox(height: 4),

                        // phòng
                        Text("Phòng: ${item.phong ?? ""}"),

                        const SizedBox(height: 4),

                        // giảng viên
                        Text("GV: ${item.gv ?? ""}"),

                        const SizedBox(height: 4),

                        // lớp
                        Text("Lớp: ${item.lop ?? ""}"),

                        const SizedBox(height: 8),

                        // tooltip
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),

                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),

                          child: Text(item.tooltip ?? ""),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
