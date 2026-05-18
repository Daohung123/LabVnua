import 'package:flutter/material.dart';

import 'package:diacritic/diacritic.dart';

import '../controlers/ctrl_courses_register.dart';
import '../models/model_course_register.dart';
import '../models/model_course_register_action.dart';
import '../models/model_course_register_fillter.dart';

class CourseRegisterView extends StatefulWidget {
  const CourseRegisterView({super.key});

  @override
  State<CourseRegisterView> createState() => _CourseRegisterViewState();
}

class _CourseRegisterViewState extends State<CourseRegisterView> {
  List<CourseRegisterFilter> filters = [];
  List<CourseRegisterClass> classes = [];
  List<CourseRegisterSubject> subjects = [];

  bool isLoading = true;
  bool isActionLoading = false;
  bool onlyOpenForClass = false;

  String keyword = "";
  String? message;

  final int svNganh = 1;
  String currentIdRs = "";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final controller = await CtrlCourseRegister.create();

      final filterResult = await controller.getFilters();
      final fullResponse = await controller.getCourseRegisterFull();

      final classResult = fullResponse?.data?.dsNhomTo ?? [];
      final subjectResult = fullResponse?.data?.dsMonHoc ?? [];

      if (classResult.isNotEmpty) {
        currentIdRs = classResult.first.idRs ?? currentIdRs;
      }

      setState(() {
        filters = filterResult;
        classes = classResult;
        subjects = subjectResult;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        message = "Không thể tải dữ liệu: $e";
        isLoading = false;
      });
    }
  }

  String getTenMon(CourseRegisterClass item) {
    final subject = subjects.firstWhere(
      (e) => e.ma == item.maMon,
      orElse: () => CourseRegisterSubject(),
    );

    final ten = subject.ten?.trim();
    if (ten != null && ten.isNotEmpty) return ten;

    final tenClass = item.tenMon?.trim();
    if (tenClass != null && tenClass.isNotEmpty) return tenClass;

    return "Không có tên môn";
  }

  List<CourseRegisterClass> get registeredClasses {
    return classes.where((e) => e.isDk == true).toList();
  }

  List<CourseRegisterClass> get availableClasses {
    List<CourseRegisterClass> list = classes
        .where((e) => e.isDk != true)
        .toList();

    final search = removeDiacritics(keyword.trim().toLowerCase());

    if (search.isNotEmpty) {
      list = list.where((e) {
        final maMon = removeDiacritics((e.maMon ?? "").toLowerCase());

        final tenMon = removeDiacritics(getTenMon(e).toLowerCase());

        return maMon.contains(search) || tenMon.contains(search);
      }).toList();
    }

    if (onlyOpenForClass) {
      if (onlyOpenForClass) {
        list = list.where((e) {
          final lop = (e.lop ?? "").trim();

          return lop.isNotEmpty && lop != "-" && lop.toLowerCase() != "null";
        }).toList();
      }
    }

    return list;
  }

  int get totalCredits {
    return registeredClasses.fold<int>(
      0,
      (sum, item) => sum + (int.tryParse(item.soTc ?? "0") ?? 0),
    );
  }

  Future<CourseRegisterActionResponse?> _callAction({
    required String idToHoc,
    required bool isChecked,
  }) async {
    final controller = await CtrlCourseRegister.create();

    final response = await controller.actionCourseRegister(
      idToHoc: idToHoc,
      isChecked: isChecked,
      svNganh: svNganh,
      idRs: currentIdRs,
    );

    if (response?.data?.idRs != null) {
      currentIdRs = response!.data!.idRs!;
    }

    return response;
  }

  Future<void> registerCourse(CourseRegisterClass item) async {
    final idToHoc = item.idToHoc;
    if (idToHoc == null || idToHoc.isEmpty) return;

    setState(() {
      isActionLoading = true;
      message = null;
    });

    try {
      CourseRegisterActionResponse? response = await _callAction(
        idToHoc: idToHoc,
        isChecked: true,
      );

      var data = response?.data;

      if (data?.isThanhCong != true &&
          data?.thongBaoLoi?.trim() == "Warning!") {
        response = await _callAction(idToHoc: idToHoc, isChecked: true);
        data = response?.data;
      }

      if (data?.isThanhCong == true) {
        final warning = data?.thongBaoTienQuyet?.trim() ?? "";

        await Future.delayed(const Duration(milliseconds: 400));
        await loadData();

        if (warning.isNotEmpty) {
          await _showInfoDialog(title: "Thông báo", content: warning);
        }

        return;
      }

      final error = data?.thongBaoLoi?.trim() ?? "";

      if (error.isNotEmpty && error != "Warning!") {
        await _showInfoDialog(title: "Không thể đăng ký", content: error);
      }
    } catch (e) {
      await _showInfoDialog(title: "Lỗi", content: "Có lỗi xảy ra: $e");
    } finally {
      if (mounted) {
        setState(() => isActionLoading = false);
      }
    }
  }

  Future<void> _showInfoDialog({
    required String title,
    required String content,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: Color(0xff0D47A1),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            content.trim().isEmpty ? "Không có thông báo chi tiết." : content,
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff1565C0),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              child: const Text("Đóng"),
            ),
          ],
        );
      },
    );
  }

  Future<void> cancelCourseByClass(CourseRegisterClass item) async {
    final idToHoc = item.idToHoc;

    if (idToHoc == null || idToHoc.isEmpty) {
      setState(() => message = "Không tìm thấy id_to_hoc để huỷ");
      return;
    }

    final ok = await _showConfirmDialog(
      title: "Thông báo",
      content: "Xác nhận xoá dữ liệu?",
      confirmText: "Có",
    );

    if (ok != true) return;

    setState(() {
      isActionLoading = true;
      message = null;
    });

    try {
      CourseRegisterActionResponse? response;

      for (int i = 0; i < 3; i++) {
        response = await _callAction(idToHoc: idToHoc, isChecked: false);

        if (response?.data?.isThanhCong == true) {
          setState(() => message = "Huỷ thành công");
          await Future.delayed(const Duration(milliseconds: 400));
          await loadData();
          return;
        }

        await Future.delayed(const Duration(milliseconds: 300));
      }

      setState(() {
        message = response?.data?.thongBaoLoi ?? "Huỷ thất bại";
      });
    } catch (e) {
      setState(() => message = "Có lỗi xảy ra: $e");
    } finally {
      if (mounted) {
        setState(() => isActionLoading = false);
      }
    }
  }

  Future<bool?> _showConfirmDialog({
    required String title,
    required String content,
    required String confirmText,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: Color(0xff0D47A1),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(content, textAlign: TextAlign.center),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(
                "Không",
                style: TextStyle(
                  color: Colors.pinkAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff1565C0),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F3F7),
      appBar: AppBar(
        title: const Text("Đăng ký môn học"),
        centerTitle: true,
        backgroundColor: const Color(0xff0D47A1),
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadData,
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  _filterBox(),

                  if (message != null) ...[
                    const SizedBox(height: 10),
                    _messageBox(),
                  ],

                  const SizedBox(height: 18),

                  _sectionTitle("Danh sách lớp học phần mở cho đăng ký"),

                  const SizedBox(height: 6),

                  const Text(
                    "Đánh dấu vào các lớp học phần mà bạn muốn đăng ký.",
                    style: TextStyle(color: Colors.black54, fontSize: 13),
                  ),

                  const SizedBox(height: 10),

                  if (availableClasses.isEmpty)
                    _emptyBox("Không có lớp học phần phù hợp")
                  else
                    ...availableClasses.map(_classCard),

                  const SizedBox(height: 18),

                  _registeredBox(),
                ],
              ),
            ),
    );
  }

  Widget _filterBox() {
    return Column(
      children: [
        TextField(
          onChanged: (value) {
            setState(() {
              keyword = value;
            });
          },
          decoration: InputDecoration(
            hintText: "Tìm theo tên hoặc mã môn học",
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
        ),

        const SizedBox(height: 12),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: SwitchListTile(
            value: onlyOpenForClass,
            onChanged: (value) {
              setState(() {
                onlyOpenForClass = value;
              });
            },
            title: const Text(
              "Môn học mở cho lớp",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }

  Widget _messageBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(message ?? ""),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _classCard(CourseRegisterClass item) {
    final canRegister = item.enable == true;
    final tenMon = getTenMon(item);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: canRegister ? Colors.white : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Checkbox(
            value: false,
            onChanged: canRegister && !isActionLoading
                ? (_) => registerCourse(item)
                : null,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$tenMon - ${item.maMon ?? ""}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: canRegister ? Colors.black87 : Colors.black38,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    _smallText("Số lượng: ${item.slCp ?? 0}"),
                    _smallText("Còn lại: ${item.slCl ?? 0}"),
                    _smallText("Tín chỉ: ${item.soTc ?? "0"}"),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _showCourseDetail(item),
            icon: const Icon(Icons.open_in_new),
            color: Colors.deepOrange,
          ),
        ],
      ),
    );
  }

  Widget _registeredBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Kết quả đăng ký học phần"),

        const SizedBox(height: 4),

        Text(
          "Tổng cộng: ${registeredClasses.length} học phần  |  $totalCredits tín chỉ",
          style: const TextStyle(color: Colors.black54, fontSize: 13),
        ),

        const SizedBox(height: 10),

        if (registeredClasses.isEmpty)
          _emptyBox("Chưa có học phần nào được đăng ký")
        else
          ...registeredClasses.asMap().entries.map((entry) {
            return _registeredCard(entry.key + 1, entry.value);
          }),
      ],
    );
  }

  Widget _registeredCard(int index, CourseRegisterClass item) {
    final tenMon = getTenMon(item);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          Text("$index", style: const TextStyle(fontWeight: FontWeight.bold)),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$tenMon - ${item.maMon ?? ""}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 4),

                Text(
                  "Nhóm tổ: ${item.nhomTo ?? "-"}   Lớp: ${item.lop ?? "-"}",
                  style: const TextStyle(color: Colors.black54, fontSize: 13),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () => _showCourseDetail(item),
            icon: const Icon(Icons.open_in_new),
            color: Colors.deepOrange,
          ),

          IconButton(
            onPressed: isActionLoading ? null : () => cancelCourseByClass(item),
            icon: const Icon(Icons.delete),
            color: Colors.redAccent,
          ),
        ],
      ),
    );
  }

  void _showCourseDetail(CourseRegisterClass item) {
    final tenMon = getTenMon(item);

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Thông tin chi tiết",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xff0D47A1),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const CircleAvatar(
                        radius: 18,
                        backgroundColor: Color(0xff75758B),
                        child: Icon(Icons.close, color: Colors.white),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                _detailRow("Mã môn học", item.maMon),
                _detailRow("Tên môn học", tenMon),
                _detailRow("Nhóm", item.nhomTo),
                _detailRow("Tổ", ""),
                _detailRow("Số tín chỉ", item.soTc),
                _detailRow("Lớp", item.lop),
                _detailRow("Số lượng", "${item.slCp ?? ""}"),
                _detailRow("Còn lại", "${item.slCl ?? ""}"),

                const SizedBox(height: 10),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Thời khóa biểu",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 8),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _formatTkb(item.tkb),
                    style: const TextStyle(
                      color: Color(0xff0D47A1),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: 120,
                  height: 46,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff1565C0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
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
        );
      },
    );
  }

  Widget _detailRow(String title, String? value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xffEEEEEE))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              value ?? "",
              style: const TextStyle(
                color: Color(0xff3F51B5),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyBox(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          const Icon(Icons.event_note, color: Colors.blue, size: 42),
          const SizedBox(height: 10),
          Text(text),
        ],
      ),
    );
  }

  Widget _smallText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 12, color: Colors.black54),
    );
  }

  String _formatTkb(String? tkb) {
    if (tkb == null || tkb.isEmpty) return "";

    return tkb.replaceAll("<hr>", "\n").replaceAll("Thứ", "- Thứ").trim();
  }
}
