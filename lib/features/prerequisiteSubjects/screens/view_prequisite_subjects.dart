import 'package:flutter/material.dart';

import '../controllers/ctrls_prequisite_subjects.dart';
import '../models/model_prequisite_subjects.dart';

class PrerequisiteView extends StatefulWidget {
  const PrerequisiteView({super.key});

  @override
  State<PrerequisiteView> createState() => _PrerequisiteViewState();
}

class _PrerequisiteViewState extends State<PrerequisiteView> {
  List<PrerequisiteSubject> subjects = [];

  bool isLoading = true;
  int selectedLoaiTienQuyet = 1;

  @override
  void initState() {
    super.initState();
    loadPrerequisite();
  }

  Future<void> loadPrerequisite() async {
    try {
      setState(() {
        isLoading = true;
      });

      final controller = await CtrlPrerequisite.create();

      final result = await controller.getPrerequisiteSubjects(
        loaiTienQuyet: selectedLoaiTienQuyet,
      );

      setState(() {
        subjects = result;
        isLoading = false;
      });
    } catch (e) {
      print("Lỗi loadPrerequisite: $e");

      setState(() {
        subjects = [];
        isLoading = false;
      });
    }
  }

  String getTitleByLoai(int loai) {
    switch (loai) {
      case 1:
        return "Môn học tiên quyết";
      case 2:
        return "Môn học trước";
      case 3:
        return "Môn học song hành";
      default:
        return "Môn học điều kiện";
    }
  }

  String getRequireLabelByLoai(int loai) {
    switch (loai) {
      case 1:
        return "Yêu cầu học tiên quyết";
      case 2:
        return "Yêu cầu học trước";
      case 3:
        return "Yêu cầu học song hành";
      default:
        return "Yêu cầu môn học";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F7FB),
      appBar: AppBar(
        title: Text(getTitleByLoai(selectedLoaiTienQuyet)),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _FilterBox(
            selectedValue: selectedLoaiTienQuyet,
            onChanged: (value) {
              if (value == null) return;

              setState(() {
                selectedLoaiTienQuyet = value;
              });

              loadPrerequisite();
            },
          ),

          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : subjects.isEmpty
                    ? Center(
                        child: Text(
                          "Không có dữ liệu ${getTitleByLoai(selectedLoaiTienQuyet).toLowerCase()}",
                          style: const TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: subjects.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = subjects[index];

                          return _PrerequisiteCard(
                            item: item,
                            requireLabel:
                                getRequireLabelByLoai(selectedLoaiTienQuyet),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _FilterBox extends StatelessWidget {
  final int selectedValue;
  final ValueChanged<int?> onChanged;

  const _FilterBox({
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: selectedValue,
          isExpanded: true,
          items: const [
            DropdownMenuItem(
              value: 1,
              child: Text("Loại 1 - Môn học tiên quyết"),
            ),
            DropdownMenuItem(
              value: 2,
              child: Text("Loại 2 - Môn học trước"),
            ),
            DropdownMenuItem(
              value: 3,
              child: Text("Loại 3 - Môn học song hành"),
            ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _PrerequisiteCard extends StatelessWidget {
  final PrerequisiteSubject item;
  final String requireLabel;

  const _PrerequisiteCard({
    required this.item,
    required this.requireLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SubjectTitle(
            code: item.maMonDangKy,
            name: item.tenMonDangKy,
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.arrow_downward_rounded,
                size: 20,
                color: Colors.orange,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  requireLabel,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _InfoBox(
            code: item.maMonYeuCau,
            name: item.tenMonYeuCau,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (item.khoi != null && item.khoi!.isNotEmpty)
                _Tag(text: "Khối: ${item.khoi}"),
              if (item.heDaoTao != null && item.heDaoTao!.isNotEmpty)
                _Tag(text: "Hệ đào tạo: ${item.heDaoTao}"),
            ],
          ),
        ],
      ),
    );
  }
}

class _SubjectTitle extends StatelessWidget {
  final String? code;
  final String? name;

  const _SubjectTitle({
    this.code,
    this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.menu_book_rounded,
          color: Colors.blue,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            "${code ?? ""} - ${name ?? ""}",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String? code;
  final String? name;

  const _InfoBox({
    this.code,
    this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xffFFF7E8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.orange.withOpacity(0.3),
        ),
      ),
      child: Text(
        "${code ?? ""} - ${name ?? ""}",
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;

  const _Tag({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.blue,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}