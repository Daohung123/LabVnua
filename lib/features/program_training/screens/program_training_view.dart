import 'package:flutter/material.dart';

import '../controlers/ctrl_program_training.dart';
import '../models/model_program_data.dart';

class ProgramTrainingView extends StatefulWidget {
  const ProgramTrainingView({super.key});

  @override
  State<ProgramTrainingView> createState() => _ProgramTrainingViewState();
}

class _ProgramTrainingViewState extends State<ProgramTrainingView> {
  bool isLoading = true;
  List<ProgramTrainingSemester> semesters = [];

  @override
  void initState() {
    super.initState();
    loadProgramTraining();
  }

  Future<void> loadProgramTraining() async {
    try {
      final ctrl = await CtrlProgramTraining.create();
      final result = await ctrl.getProgramTraining();

      setState(() {
        semesters = result;
        isLoading = false;
      });
    } catch (e) {
      print("Lỗi loadProgramTraining: $e");

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F6F6),
      appBar: AppBar(
        title: const Text("Chương trình đào tạo"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : semesters.isEmpty
              ? const Center(
                  child: Text("Không có dữ liệu chương trình đào tạo"),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: semesters.length,
                  itemBuilder: (context, index) {
                    final semester = semesters[index];

                    return _semesterCard(semester);
                  },
                ),
    );
  }

  Widget _semesterCard(ProgramTrainingSemester semester) {
    final subjects = semester.dsCtdtMonHoc ?? [];

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      elevation: 2,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        childrenPadding: const EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: 12,
        ),
        title: Text(
          semester.tenHocKy ?? "Không rõ học kỳ",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          "Mã học kỳ: ${semester.hocKy ?? ""} - ${subjects.length} môn",
        ),
        children: subjects.map((subject) {
          return _subjectCard(subject);
        }).toList(),
      ),
    );
  }

  Widget _subjectCard(ProgramTrainingSubject subject) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subject.tenMon ?? "Không rõ tên môn",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            subject.tenMonEg ?? "",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 10),

          _infoRow("Mã môn", subject.maMon),
          _infoRow("Số tín chỉ", subject.soTinChi),
          _infoRow("Lý thuyết", subject.lyThuyet),
          _infoRow("Thực hành", subject.thucHanh),
          _infoRow("Tổng tiết", subject.tongTiet),

          const SizedBox(height: 8),

          Row(
            children: [
              _statusChip(
                "Bắt buộc",
                subject.monBatBuoc == "x",
              ),
              const SizedBox(width: 8),
              _statusChip(
                "Đã học",
                subject.monDaHoc == "x",
              ),
              const SizedBox(width: 8),
              _statusChip(
                "Đã đạt",
                subject.monDaDat == "x",
              ),
            ],
          ),

          if ((subject.dsTietThanhPhan ?? []).isNotEmpty) ...[
            const SizedBox(height: 10),
            const Text(
              "Tiết thành phần:",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            ...subject.dsTietThanhPhan!.map((e) {
              return Text(
                "- ${e.tenThanhPhan ?? ""}: ${e.soTiet ?? ""} tiết",
                style: const TextStyle(fontSize: 13),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _infoRow(String title, String? value) {
    if (value == null || value.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              "$title:",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String text, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: active ? Colors.green.shade100 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: active ? Colors.green.shade800 : Colors.grey.shade600,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}