import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:diacritic/diacritic.dart';

import 'package:aqedu/core/logging/app_log.dart';

import '../controllers/ctrl_courses_register.dart';
import '../models/model_course_register.dart';
import '../models/model_course_register_action.dart';
import '../models/model_course_register_fillter.dart';
import 'package:aqedu/features/infor/models/models_infor_student.dart';

import 'package:aqedu/core/theme/app_components.dart';

enum _CourseRegisterLoadState { loading, ready, empty, error }

typedef CourseRegisterDataLoader = Future<CourseRegisterScreenData> Function({
  required bool forceRefresh,
});

@visibleForTesting
List<CourseRegisterFilter> buildVisibleCourseRegisterFilters(
  Iterable<CourseRegisterFilter> filters,
) {
  final byValue = <int, CourseRegisterFilter>{};
  for (final filter in filters) {
    final value = filter.giaTri;
    if (value == null || value == 3 || value == 4 || value == 10) continue;
    byValue.putIfAbsent(value, () => filter);
  }
  return byValue.values.toList(growable: false);
}

@visibleForTesting
int? resolveCourseRegisterFilterValue({
  required Iterable<CourseRegisterFilter> filters,
  int? currentValue,
}) {
  final visibleFilters = buildVisibleCourseRegisterFilters(filters);
  final values = visibleFilters.map((filter) => filter.giaTri).toSet();

  if (currentValue != null && values.contains(currentValue)) {
    return currentValue;
  }

  for (final filter in visibleFilters) {
    if (filter.isMacDinh == true) return filter.giaTri;
  }

  if (values.contains(2)) return 2;
  return visibleFilters.isEmpty ? null : visibleFilters.first.giaTri;
}

class CourseRegisterView extends StatefulWidget {
  const CourseRegisterView({super.key, this.dataLoader});

  final CourseRegisterDataLoader? dataLoader;

  @override
  State<CourseRegisterView> createState() => _CourseRegisterViewState();
}

class _CourseRegisterViewState extends State<CourseRegisterView> {
  List<CourseRegisterFilter> filters = [];
  List<CourseRegisterClass> classes = [];
  List<CourseRegisterSubject> subjects = [];

  _CourseRegisterLoadState _loadState = _CourseRegisterLoadState.loading;
  bool isRefreshing = false;
  bool isActionLoading = false;
  bool _loadInProgress = false;

  String keyword = '';
  String? message;

  int? selectedFilter;
  String? selectedKhoa;
  String? selectedLop;

  int svNganh = 1;

  String studentClassCode = '';

  StudentData? studentData;

  String currentIdRs = '';

  static const Color primaryBlue = AppColors.primaryPressed;
  static const Color buttonBlue = AppColors.primary;
  static const Color bgColor = AppColors.background;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData({bool forceRefresh = false}) async {
    if (_loadInProgress) return;
    _loadInProgress = true;

    final hasExistingContent =
        filters.isNotEmpty || classes.isNotEmpty || subjects.isNotEmpty;

    if (mounted) {
      setState(() {
        message = null;
        if (hasExistingContent) {
          isRefreshing = true;
        } else {
          _loadState = _CourseRegisterLoadState.loading;
        }
      });
    }

    try {
      final loader = widget.dataLoader;
      final screenData = loader != null
          ? await loader(forceRefresh: forceRefresh)
          : await (await CtrlCourseRegister.create()).loadScreenData(
              forceRefresh: forceRefresh,
            );
      final fullResponse = screenData.catalog;
      if (fullResponse == null) {
        throw StateError('Không có dữ liệu đăng ký học phần hợp lệ.');
      }

      final student = screenData.student;
      var nextSvNganh = svNganh;
      var nextStudentClassCode = studentClassCode;
      if (student != null) {
        nextSvNganh = int.tryParse(student.idNganh) ?? svNganh;
        nextStudentClassCode = student.lop.trim().toUpperCase();
      }

      final filterResult = screenData.filters;
      final classResult = fullResponse.data?.dsNhomTo ?? [];
      final subjectResult = fullResponse.data?.dsMonHoc ?? [];
      final nextSelectedFilter = resolveCourseRegisterFilterValue(
        filters: filterResult,
        currentValue: selectedFilter,
      );

      if (!mounted) return;
      setState(() {
        filters = filterResult;
        classes = classResult;
        subjects = subjectResult;
        studentData = student;
        svNganh = nextSvNganh;
        studentClassCode = nextStudentClassCode;
        currentIdRs = fullResponse.idRs ?? '';
        selectedFilter = nextSelectedFilter;
        isRefreshing = false;
        _loadState = classResult.isEmpty && subjectResult.isEmpty
            ? _CourseRegisterLoadState.empty
            : _CourseRegisterLoadState.ready;
      });
    } catch (error, stackTrace) {
      AppLog.loi(
        'Không thể hiển thị màn hình đăng ký học phần',
        khuVuc: 'Đăng ký học phần',
        loi: error,
        stackTrace: stackTrace,
      );
      if (!mounted) return;

      setState(() {
        isRefreshing = false;
        message = hasExistingContent
            ? 'Không thể làm mới dữ liệu. Đang hiển thị dữ liệu đã lưu.'
            : 'Không thể tải dữ liệu đăng ký học phần.';
        _loadState = hasExistingContent
            ? _CourseRegisterLoadState.ready
            : _CourseRegisterLoadState.error;
      });
    } finally {
      _loadInProgress = false;
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
    return classes.expand((e) => e.dsKhoa ?? <String>[]).toSet().map((ma) {
      final khoa = (filters.isEmpty) ? null : null;
      final match = _facultiesFromData.firstWhere(
        (e) => e.ma == ma,
        orElse: () => CourseRegisterFaculty(ma: ma, ten: ma),
      );
      return match;
    }).toList();
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
    List<CourseRegisterClass> list = classes
        .where((e) => e.isDk != true)
        .toList();

    switch (selectedFilter) {
      case 0:
        final classCode = studentClassCode.toUpperCase();

        list = list.where((e) {
          final dsLop = (e.dsLop ?? [])
              .map((x) => x.trim().toUpperCase())
              .toList();

          final lop = (e.lop ?? '').trim().toUpperCase();

          return dsLop.contains(classCode) || lop == classCode;
        }).toList();
        break;

      case 1:
        list = list.where((e) => e.isRot == true).toList();
        break;

      case 2:
        list = list.where((e) => e.isCtdt == true).toList();
        break;

      case 6:
        list = list.where((e) => e.isChctdt == true).toList();
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
      final response = await _callAction(idToHoc: idToHoc, isChecked: true);

      final data = response?.data;

      if (data?.isThanhCong == true) {
        final warning = data?.thongBaoTienQuyet?.trim() ?? '';

        await loadData();

        if (warning.isNotEmpty) {
          await _showInfoDialog(title: 'Thông báo', content: warning);
        }

        return;
      }

      final error = data?.thongBaoLoi?.trim() ?? '';

      await _showInfoDialog(
        title: 'Không thể đăng ký',
        content: error.isNotEmpty ? error : 'Đăng ký học phần chưa thành công.',
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
      final response = await _callAction(idToHoc: idToHoc, isChecked: false);

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
            borderRadius: BorderRadius.circular(AppRadius.xl),
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
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.xl),
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
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: primaryBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(content, textAlign: TextAlign.center),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(
                'Không',
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonBlue,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.xl),
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
        foregroundColor: AppColors.white,
        actions: [
          IconButton(
            key: const Key('course-register-refresh'),
            onPressed:
                isRefreshing || _loadState == _CourseRegisterLoadState.loading
                ? null
                : () => loadData(forceRefresh: true),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loadState == _CourseRegisterLoadState.loading) {
      return const Center(
        key: Key('course-register-loading'),
        child: CircularProgressIndicator(),
      );
    }

    if (_loadState == _CourseRegisterLoadState.error) {
      return RefreshIndicator(
        onRefresh: () => loadData(forceRefresh: true),
        child: ListView(
          key: const Key('course-register-error'),
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 64, 24, 32),
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 58,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'Chưa thể hiển thị đăng ký môn học',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message ?? 'Vui lòng kiểm tra kết nối và thử lại.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              key: const Key('course-register-retry'),
              onPressed: () => loadData(forceRefresh: true),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () => loadData(forceRefresh: true),
          child: ListView(
            key: const Key('course-register-content'),
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 32),
            children: [
              _topSummaryCard(),
              const SizedBox(height: AppSpacing.md),
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
                _emptyBox(
                  _loadState == _CourseRegisterLoadState.empty
                      ? 'Chưa có dữ liệu lớp học phần. Hãy kéo xuống để đồng bộ lại.'
                      : 'Không có lớp học phần phù hợp',
                )
              else
                ...availableClasses.map(_classCard),
              const SizedBox(height: 18),
              _registeredBox(),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
        if (isRefreshing)
          const Align(
            alignment: Alignment.topCenter,
            child: LinearProgressIndicator(minHeight: 2),
          ),
        if (isActionLoading)
          Positioned.fill(
            child: ColoredBox(
              color: Color(0x2E000000),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }

  Widget _topSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.lightShadow,
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: AppColors.white24,
            child: Icon(Icons.school, color: AppColors.white),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Đăng ký học phần',
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${registeredClasses.length} học phần đã đăng ký • $totalCredits tín chỉ',
                  style: const TextStyle(color: AppColors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterBox() {
    final visibleFilters = buildVisibleCourseRegisterFilters(filters);
    final safeSelectedFilter = resolveCourseRegisterFilterValue(
      filters: visibleFilters,
      currentValue: selectedFilter,
    );

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          DropdownButtonFormField<int>(
            key: const Key('course-register-filter'),
            value: safeSelectedFilter,
            isExpanded: true,
            hint: const Text('Không có bộ lọc khả dụng'),
            decoration: InputDecoration(
              labelText: 'Bộ lọc',
              prefixIcon: const Icon(Icons.filter_alt_outlined),
              filled: true,
              fillColor: AppColors.surfaceAlt,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: BorderSide.none,
              ),
            ),
            items: visibleFilters.map((filter) {
              return DropdownMenuItem<int>(
                value: filter.giaTri,
                child: Text(filter.mieuTa ?? 'Bộ lọc'),
              );
            }).toList(),
            onChanged: visibleFilters.isEmpty
                ? null
                : (value) {
                    if (value == null) return;

                    setState(() {
                      selectedFilter = value;
                      selectedKhoa = null;
                      selectedLop = null;
                    });
                  },
          ),
          const SizedBox(height: AppSpacing.md),
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
              fillColor: AppColors.surfaceAlt,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: BorderSide.none,
              ),
            ),
          ),
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
        fillColor: AppColors.surfaceAlt,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide.none,
        ),
      ),
      items: values.map((item) {
        return DropdownMenuItem<String>(value: item, child: Text(item));
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _messageBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Text(message ?? ''),
    );
  }

  Widget _sectionHeader({required String title, required String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          subtitle,
          style: const TextStyle(color: AppColors.black54, fontSize: 13),
        ),
      ],
    );
  }

  Widget _classCard(CourseRegisterClass item) {
    final canRegister = item.enable == true;
    final tenMon = getTenMon(item);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: canRegister ? AppColors.white : AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: canRegister ? AppColors.transparent : AppColors.border,
        ),
        boxShadow: canRegister
            ? [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.04),
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
                    color: canRegister ? AppColors.black87 : AppColors.black38,
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
                      color: AppColors.error,
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
            color: AppColors.warning,
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
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.04),
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
          const SizedBox(width: AppSpacing.md),
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
                  style: const TextStyle(color: AppColors.black54, fontSize: 13),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _showCourseDetail(item),
            icon: const Icon(Icons.open_in_new),
            color: AppColors.warning,
          ),
          IconButton(
            onPressed: isActionLoading ? null : () => cancelCourseByClass(item),
            icon: const Icon(Icons.delete_outline),
            color: AppColors.error,
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
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.xl),
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
                          backgroundColor: AppColors.textSecondary,
                          child: Icon(Icons.close, color: AppColors.white),
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
                  const SizedBox(height: AppSpacing.sm),
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
                  const SizedBox(height: AppSpacing.lg20),
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
                        style: TextStyle(color: AppColors.white),
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
        border: Border(bottom: BorderSide(color: AppColors.divider)),
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
                color: AppColors.primaryPressed,
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
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        children: [
          const Icon(Icons.event_note, color: AppColors.primary, size: 42),
          const SizedBox(height: 10),
          Text(text, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _chipText(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
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
