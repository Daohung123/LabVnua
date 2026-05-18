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

  String keyword = '';
  String? message;

  int selectedFilter = 2;
  String? selectedKhoa;
  String? selectedLop;

  final int svNganh = 1;
  String currentIdRs = '';

  static const Color primaryBlue = Color(0xff0D47A1);
  static const Color buttonBlue = Color(0xff1565C0);
  static const Color bgColor = Color(0xffF2F3F7);

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

      currentIdRs = fullResponse?.idRs ?? '';

      final defaultFilter = filterResult.firstWhere(
        (e) => e.isMacDinh == true,
        orElse: () => CourseRegisterFilter(giaTri: 2),
      );

      if (!mounted) return;

      setState(() {
        filters = filterResult;
        classes = classResult;
        subjects = subjectResult;
        selectedFilter = defaultFilter.giaTri ?? selectedFilter;
        isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        message = 'Không thể tải dữ liệu.';
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

    final tenEg = item.tenMonEg?.trim();
    if (tenEg != null && tenEg.isNotEmpty) return tenEg;

    return 'Không có tên môn';
  }

  String getFilterName(int value) {
    final filter = filters.firstWhere(
      (e) => e.giaTri == value,
      orElse: () => CourseRegisterFilter(mieuTa: 'Bộ lọc'),
    );

    return filter.mieuTa ?? 'Bộ lọc';
  }

  List<CourseRegisterFaculty> get faculties {
    return classes
        .expand((e) => e.dsKhoa ?? <String>[])
        .toSet()
        .map((ma) {
          final khoa = (filters.isEmpty)
              ? null
              : null;
          final match = _facultiesFromData.firstWhere(
            (e) => e.ma == ma,
            orElse: () => CourseRegisterFaculty(ma: ma, ten: ma),
          );
          return match;
        })
        .toList();
  }

  List<CourseRegisterFaculty> get _facultiesFromData {
    final data = <String, CourseRegisterFaculty>{};
    for (final item in _rawFaculties) {
      if ((item.ma ?? '').isNotEmpty) {
        data[item.ma!] = item;
      }
    }
    return data.values.toList();
  }

  List<CourseRegisterFaculty> get _rawFaculties {
    // ds_khoa đang nằm trong fullResponse.data, nhưng view hiện chỉ lưu classes/subjects.
    // Hàm này giữ để tránh lỗi nếu muốn mở rộng sau.
    return const [];
  }

  List<String> get availableKhoaCodes {
    final set = <String>{};
    for (final item in classes) {
      set.addAll(item.dsKhoa ?? []);
    }
    final list = set.toList();
    list.sort();
    return list;
  }

  List<String> get availableLopCodes {
    final set = <String>{};
    for (final item in classes) {
      set.addAll(item.dsLop ?? []);
      final lop = item.lop?.trim();
      if (lop != null && lop.isNotEmpty) set.add(lop);
    }
    final list = set.toList();
    list.sort();
    return list;
  }

  List<CourseRegisterClass> get registeredClasses {
    return classes.where((e) => e.isDk == true).toList();
  }

  List<CourseRegisterClass> get availableClasses {
    List<CourseRegisterClass> list =
        classes.where((e) => e.isDk != true).toList();

    switch (selectedFilter) {
      case 0:
        list = list.where((e) {
          final dsLop = e.dsLop ?? [];
          final lop = (e.lop ?? '').toUpperCase();

          return dsLop.any((x) {
                final value = x.toUpperCase();
                return value.contains('K68CNTTF') ||
                    value == 'LOP_DH' ||
                    value == '*';
              }) ||
              lop == 'LOP_DH';
        }).toList();
        break;

      case 1:
        list = list.where((e) => e.isRot == true).toList();
        break;

      case 2:
        list = list.where((e) => e.isCtdt == true).toList();
        break;

      case 3:
        if (selectedKhoa != null && selectedKhoa!.isNotEmpty) {
          list = list
              .where((e) => (e.dsKhoa ?? []).contains(selectedKhoa))
              .toList();
        }
        break;

      case 4:
        if (selectedLop != null && selectedLop!.isNotEmpty) {
          list = list.where((e) {
            final dsLop = e.dsLop ?? [];
            return dsLop.contains(selectedLop) || e.lop == selectedLop;
          }).toList();
        }
        break;

      case 6:
        list = list.where((e) => e.isChctdt == true).toList();
        break;

      case 10:
      default:
        break;
    }

    final search = removeDiacritics(keyword.trim().toLowerCase());

    if (search.isNotEmpty) {
      list = list.where((e) {
        final maMon = removeDiacritics((e.maMon ?? '').toLowerCase());
        final tenMon = removeDiacritics(getTenMon(e).toLowerCase());

        return maMon.contains(search) || tenMon.contains(search);
      }).toList();
    }

    return list;
  }

  int get totalCredits {
    return registeredClasses.fold<int>(
      0,
      (sum, item) => sum + (int.tryParse(item.soTc ?? '0') ?? 0),
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

    final newIdRs = response?.data?.idRs;

    if (newIdRs != null && newIdRs.isNotEmpty) {
      currentIdRs = newIdRs;
    }

    return response;
  }

  Future<void> registerCourse(CourseRegisterClass item) async {
    final idToHoc = item.idToHoc;

    if (idToHoc == null || idToHoc.isEmpty) return;

    if (currentIdRs.isEmpty) {
      await _showInfoDialog(
        title: 'Không thể đăng ký',
        content: 'Chưa lấy được mã phiên đăng ký. Vui lòng tải lại dữ liệu.',
      );
      return;
    }

    setState(() {
      isActionLoading = true;
      message = null;
    });

    try {
      final response = await _callAction(
        idToHoc: idToHoc,
        isChecked: true,
      );

      final data = response?.data;

      if (data?.isThanhCong == true) {
        final warning = data?.thongBaoTienQuyet?.trim() ?? '';

        await loadData();

        if (warning.isNotEmpty) {
          await _showInfoDialog(
            title: 'Thông báo',
            content: warning,
          );
        }

        return;
      }

      final error = data?.thongBaoLoi?.trim() ?? '';

      await _showInfoDialog(
        title: 'Không thể đăng ký',
        content: error.isNotEmpty
            ? error
            : 'Đăng ký học phần chưa thành công.',
      );
    } catch (_) {
      await _showInfoDialog(
        title: 'Lỗi',
        content: 'Có lỗi xảy ra khi đăng ký học phần.',
      );
    } finally {
      if (mounted) {
        setState(() {
          isActionLoading = false;
        });
      }
    }
  }

  Future<void> cancelCourseByClass(CourseRegisterClass item) async {
    final idToHoc = item.idToHoc;

    if (idToHoc == null || idToHoc.isEmpty) {
      await _showInfoDialog(
        title: 'Không thể huỷ',
        content: 'Không tìm thấy mã lớp học phần để huỷ.',
      );
      return;
    }

    final ok = await _showConfirmDialog(
      title: 'Xác nhận huỷ',
      content: 'Bạn có chắc muốn huỷ học phần này không?',
      confirmText: 'Có',
    );

    if (ok != true) return;

    if (currentIdRs.isEmpty) {
      await _showInfoDialog(
        title: 'Không thể huỷ',
        content: 'Chưa lấy được mã phiên đăng ký. Vui lòng tải lại dữ liệu.',
      );
      return;
    }

    setState(() {
      isActionLoading = true;
      message = null;
    });

    try {
      final response = await _callAction(
        idToHoc: idToHoc,
        isChecked: false,
      );

      final data = response?.data;

      if (data?.isThanhCong == true) {
        await loadData();
        return;
      }

      final error = data?.thongBaoLoi?.trim() ?? '';

      await _showInfoDialog(
        title: 'Không thể huỷ',
        content: error.isNotEmpty ? error : 'Huỷ học phần chưa thành công.',
      );
    } catch (_) {
      await _showInfoDialog(
        title: 'Lỗi',
        content: 'Có lỗi xảy ra khi huỷ học phần.',
      );
    } finally {
      if (mounted) {
        setState(() {
          isActionLoading = false;
        });
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
              color: primaryBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            content.trim().isEmpty ? 'Không có thông báo chi tiết.' : content,
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
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
              color: primaryBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            content,
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(
                'Không',
                style: TextStyle(
                  color: Colors.pinkAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonBlue,
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
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Đăng ký môn học'),
        centerTitle: true,
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: loadData,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                RefreshIndicator(
                  onRefresh: loadData,
                  child: ListView(
                    padding: const EdgeInsets.all(14),
                    children: [
                      _topSummaryCard(),
                      const SizedBox(height: 12),
                      _filterBox(),
                      if (message != null) ...[
                        const SizedBox(height: 10),
                        _messageBox(),
                      ],
                      const SizedBox(height: 18),
                      _sectionHeader(
                        title: 'Danh sách lớp học phần mở cho đăng ký',
                        subtitle:
                            'Đánh dấu vào các lớp học phần mà bạn muốn đăng ký.',
                      ),
                      const SizedBox(height: 10),
                      if (availableClasses.isEmpty)
                        _emptyBox('Không có lớp học phần phù hợp')
                      else
                        ...availableClasses.map(_classCard),
                      const SizedBox(height: 18),
                      _registeredBox(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
                if (isActionLoading)
                  Container(
                    color: Colors.black.withOpacity(0.18),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _topSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff0D47A1), Color(0xff1976D2)],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.white24,
            child: Icon(Icons.school, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Đăng ký học phần',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${registeredClasses.length} học phần đã đăng ký • $totalCredits tín chỉ',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          DropdownButtonFormField<int>(
            value: selectedFilter,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: 'Bộ lọc',
              prefixIcon: const Icon(Icons.filter_alt_outlined),
              filled: true,
              fillColor: const Color(0xffF7F8FC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
            items: filters.map((filter) {
              return DropdownMenuItem<int>(
                value: filter.giaTri,
                child: Text(filter.mieuTa ?? 'Bộ lọc'),
              );
            }).toList(),
            onChanged: (value) {
              if (value == null) return;

              setState(() {
                selectedFilter = value;
                selectedKhoa = null;
                selectedLop = null;
              });
            },
          ),
          const SizedBox(height: 12),
          TextField(
            onChanged: (value) {
              setState(() {
                keyword = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Tìm theo tên hoặc mã môn học',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: const Color(0xffF7F8FC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          if (selectedFilter == 3) ...[
            const SizedBox(height: 12),
            _dropdownString(
              label: 'Khoa quản lý môn học',
              value: selectedKhoa,
              values: availableKhoaCodes,
              onChanged: (value) {
                setState(() {
                  selectedKhoa = value;
                });
              },
            ),
          ],
          if (selectedFilter == 4) ...[
            const SizedBox(height: 12),
            _dropdownString(
              label: 'Lớp',
              value: selectedLop,
              values: availableLopCodes,
              onChanged: (value) {
                setState(() {
                  selectedLop = value;
                });
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _dropdownString({
    required String label,
    required String? value,
    required List<String> values,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xffF7F8FC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      items: values.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _messageBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(message ?? ''),
    );
  }

  Widget _sectionHeader({
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _classCard(CourseRegisterClass item) {
    final canRegister = item.enable == true;
    final tenMon = getTenMon(item);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: canRegister ? Colors.white : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: canRegister ? Colors.transparent : Colors.grey.shade300,
        ),
        boxShadow: canRegister
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Row(
        children: [
          Checkbox(
            value: false,
            onChanged: canRegister && !isActionLoading
                ? (_) => registerCourse(item)
                : null,
          ),
          const SizedBox(width: 2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$tenMon - ${item.maMon ?? ''}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: canRegister ? Colors.black87 : Colors.black38,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    _chipText('Nhóm ${item.nhomTo ?? '-'}'),
                    _chipText('SL ${item.slCp ?? 0}'),
                    _chipText('Còn ${item.slCl ?? 0}'),
                    _chipText('${item.soTc ?? '0'} TC'),
                  ],
                ),
                if ((item.gcEnable ?? '').trim().isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    item.gcEnable!,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
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
        _sectionHeader(
          title: 'Kết quả đăng ký học phần',
          subtitle:
              'Tổng cộng: ${registeredClasses.length} học phần • $totalCredits tín chỉ',
        ),
        const SizedBox(height: 10),
        if (registeredClasses.isEmpty)
          _emptyBox('Chưa có học phần nào được đăng ký')
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
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: primaryBlue.withOpacity(0.1),
            child: Text(
              '$index',
              style: const TextStyle(
                color: primaryBlue,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$tenMon - ${item.maMon ?? ''}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  'Nhóm: ${item.nhomTo ?? '-'} • Lớp: ${item.lop ?? '-'} • ${item.soTc ?? '0'} TC',
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                  ),
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
            icon: const Icon(Icons.delete_outline),
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Thông tin chi tiết',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: primaryBlue,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const CircleAvatar(
                          radius: 18,
                          backgroundColor: Color(0xff75758B),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _detailRow('Mã môn học', item.maMon),
                  _detailRow('Tên môn học', tenMon),
                  _detailRow('Nhóm', item.nhomTo),
                  _detailRow('Tổ', item.to),
                  _detailRow('Số tín chỉ', item.soTc),
                  _detailRow('Lớp', item.lop),
                  _detailRow('Số lượng', '${item.slCp ?? ''}'),
                  _detailRow('Còn lại', '${item.slCl ?? ''}'),
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Thời khóa biểu',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _formatTkb(item.tkb),
                      style: const TextStyle(
                        color: primaryBlue,
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
                        backgroundColor: buttonBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Đóng',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
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
        border: Border(
          bottom: BorderSide(color: Color(0xffEEEEEE)),
        ),
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
              value ?? '',
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
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.event_note,
            color: Colors.blue,
            size: 42,
          ),
          const SizedBox(height: 10),
          Text(
            text,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _chipText(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xffEEF3FF),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          color: primaryBlue,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatTkb(String? tkb) {
    if (tkb == null || tkb.isEmpty) return '';

    return tkb.replaceAll('<hr>', '\n').replaceAll('Thứ', '- Thứ').trim();
  }
}
