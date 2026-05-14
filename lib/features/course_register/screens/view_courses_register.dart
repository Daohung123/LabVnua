import 'package:flutter/material.dart';

import '../controlers/ctrl_courses_register.dart';
import '../models/model_course_register.dart';
import '../models/model_course_register_fillter.dart';

class CourseRegisterView extends StatefulWidget {
  const CourseRegisterView({super.key});

  @override
  State<CourseRegisterView> createState() => _CourseRegisterViewState();
}

class _CourseRegisterViewState extends State<CourseRegisterView> {
  List<CourseRegisterFilter> filters = [];
  List<CourseRegisterClass> classes = [];

  CourseRegisterFilter? selectedFilter;

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final controller = await CtrlCourseRegister.create();

      final filterResult = await controller.getFilters();
      final classResult = await controller.getClasses();

      setState(() {
        filters = filterResult;
        classes = classResult;

        selectedFilter = filters
            .where((e) => e.isMacDinh == true)
            .cast<CourseRegisterFilter?>()
            .firstOrNull;

        selectedFilter ??= filters.isNotEmpty ? filters.first : null;

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Không thể tải dữ liệu đăng ký tín chỉ";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F7FB),
      appBar: AppBar(
        title: const Text("Đăng ký tín chỉ"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : Column(
                  children: [
                    _filterBox(),
                    Expanded(
                      child: classes.isEmpty
                          ? const Center(
                              child: Text("Không có lớp học phần"),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(12),
                              itemCount: classes.length,
                              itemBuilder: (context, index) {
                                return _classCard(classes[index]);
                              },
                            ),
                    ),
                  ],
                ),
    );
  }

  Widget _filterBox() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<CourseRegisterFilter>(
          value: selectedFilter,
          isExpanded: true,
          hint: const Text("Chọn bộ lọc"),
          items: filters.map((filter) {
            return DropdownMenuItem<CourseRegisterFilter>(
              value: filter,
              child: Text(filter.mieuTa ?? ""),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedFilter = value;
            });

            // Sau này nếu API lọc cần gia_tri thì dùng:
            // selectedFilter?.giaTri
          },
        ),
      ),
    );
  }

  Widget _classCard(CourseRegisterClass item) {
    final canRegister = item.enable == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: canRegister ? Colors.green.shade200 : Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.maMon ?? "Không có mã môn",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            item.tenMon?.isNotEmpty == true
                ? item.tenMon!
                : item.tenMonEg ?? "Không có tên môn",
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              _infoChip("Nhóm ${item.nhomTo ?? "-"}"),
              const SizedBox(width: 8),
              _infoChip("${item.soTc ?? "0"} tín chỉ"),
              const SizedBox(width: 8),
              _infoChip("Còn ${item.slCl ?? 0}/${item.slCp ?? 0}"),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            _formatTkb(item.tkb),
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                canRegister
                    ? "Có thể đăng ký"
                    : item.gcEnable ?? "Không thể đăng ký",
                style: TextStyle(
                  color: canRegister ? Colors.green : Colors.redAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),
              ElevatedButton(
                onPressed: canRegister ? () {} : null,
                child: const Text("Đăng ký"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xffF1F3F6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  String _formatTkb(String? tkb) {
    if (tkb == null || tkb.isEmpty) return "Chưa có thời khóa biểu";

    return tkb.replaceAll("<hr>", "\n");
  }
}