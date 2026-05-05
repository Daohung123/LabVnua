import 'package:aqedu/features/schedure/ctrls/ctrl_schedure.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'week_constants.dart';
import 'week_grid.dart';
import 'subject_block.dart';
import 'week_selector.dart';
import '../../../models/Schedure_Student.dart';

class WeekViewPage extends StatefulWidget {
  final List<ThoiKhoaBieu> allSchedule;
  final DateTime selectedDate;
  // Long_sua :(Thêm callback để cập nhật lại dữ liệu allSchedule của trang cha khi đổi học kỳ)
  final Function(List<ThoiKhoaBieu>)? onScheduleChanged;

  const WeekViewPage({
    super.key,
    required this.allSchedule,
    required this.selectedDate,
    this.onScheduleChanged,
  });

  @override
  State<WeekViewPage> createState() => _WeekViewPageState();
}

class _WeekViewPageState extends State<WeekViewPage> {
  TkbResponse? _fullData;
  TuanTkb? _selectedWeek;
  
  final List<Map<String, dynamic>> _semesters = [
    {"id": 20252, "name": "Học kỳ 2 - Năm học 2025 - 2026"},
    {"id": 20251, "name": "Học kỳ 1 - Năm học 2025 - 2026"},
    {"id": 20242, "name": "Học kỳ 2 - Năm học 2024 - 2025"},
    {"id": 20241, "name": "Học kỳ 1 - Năm học 2024 - 2025"},
    {"id": 20232, "name": "Học kỳ 2 - Năm học 2023 - 2024"},
    {"id": 20231, "name": "Học kỳ 1 - Năm học 2023 - 2024"},
  ];
  
  late Map<String, dynamic> _selectedSemester;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedSemester = _semesters.first;
    _initData(_selectedSemester["id"]);
  }

  // Long_sua :(Hàm tải dữ liệu thực tế từ API và cập nhật trạng thái hiển thị)
  Future<void> _initData(int semesterId) async {
    setState(() => _isLoading = true);
    final ctrl = await CtrlSchedure.create();
    final data = await ctrl.getFullTkbResponse(semesterId: semesterId);
    
    if (mounted) {
      setState(() {
        _fullData = data;
        if (data != null && data.dsTuanTkb.isNotEmpty) {
          // Tự động chọn tuần hiện tại hoặc tuần đầu tiên
          _selectedWeek = data.dsTuanTkb.firstWhere(
            (t) => _isCurrentWeek(t.thongTinTuan),
            orElse: () => data.dsTuanTkb.first,
          );

          // Long_sua :(Gom toàn bộ môn học kì mới để cập nhật cho trang Ngày/Chấm xanh)
          List<ThoiKhoaBieu> newAllSchedule = [];
          for (var week in data.dsTuanTkb) {
            newAllSchedule.addAll(week.dsThoiKhoaBieu);
          }
          if (widget.onScheduleChanged != null) {
            widget.onScheduleChanged!(newAllSchedule);
          }
        } else {
          _selectedWeek = null;
        }
        _isLoading = false;
      });
    }
  }

  DateTime? _parseStartDate(String thongTinTuan) {
    try {
      RegExp regExp = RegExp(r"(\d{2}/\d{2}/\d{4})");
      Iterable<RegExpMatch> matches = regExp.allMatches(thongTinTuan);
      if (matches.isNotEmpty) {
        return DateFormat("dd/MM/yyyy").parse(matches.first.group(0)!);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  bool _isCurrentWeek(String thongTinTuan) {
    DateTime? start = _parseStartDate(thongTinTuan);
    if (start == null) return false;
    DateTime end = start.add(const Duration(days: 6));
    DateTime now = DateTime.now();
    return now.isAfter(start.subtract(const Duration(days: 1))) &&
        now.isBefore(end.add(const Duration(days: 1)));
  }

  void _showSelectionSheet<T>({
    required String title,
    required List<T> items,
    required T? selectedItem,
    required String Function(T) labelBuilder,
    required Function(T) onSelected,
  }) {
    int selectedIndex = items.indexOf(selectedItem as T);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          expand: false,
          builder: (context, scrollController) {
            if (selectedIndex > 0) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                scrollController.jumpTo(selectedIndex * 50.0);
              });
            }

            return Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  Container(
                    width: 40, height: 5,
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                  ),
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        bool isSelected = item == selectedItem;
                        bool isRealNow = (item is TuanTkb) && _isCurrentWeek(item.thongTinTuan);

                        return ListTile(
                          leading: Icon(
                            Icons.calendar_today,
                            color: isRealNow ? Colors.orange : (isSelected ? const Color(0xff104492) : Colors.grey),
                          ),
                          title: Text(
                            labelBuilder(item),
                            style: TextStyle(
                              color: isSelected ? const Color(0xff104492) : Colors.black87,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          trailing: isSelected ? const Icon(Icons.check_circle, color: Color(0xff104492)) : null,
                          onTap: () {
                            onSelected(item);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    // Long_sua :(Nếu học kỳ không có dữ liệu, vẫn hiển thị WeekSelector để người dùng chọn lại kì khác)
    if (_fullData == null || _fullData!.dsTuanTkb.isEmpty) {
      return Column(
        children: [
          WeekSelector(
            semesterTitle: _selectedSemester["name"],
            weekTitle: "Kì học này không có dữ liệu",
            onSemesterTap: () {
              _showSelectionSheet<Map<String, dynamic>>(
                title: "Chọn học kỳ",
                items: _semesters,
                selectedItem: _selectedSemester,
                labelBuilder: (s) => s["name"],
                onSelected: (s) {
                  setState(() => _selectedSemester = s);
                  _initData(s["id"]);
                },
              );
            },
            onWeekTap: null,
          ),
          const Expanded(child: Center(child: Text("Học kỳ được chọn chưa có thời khóa biểu"))),
        ],
      );
    }

    DateTime firstDay = _parseStartDate(_selectedWeek?.thongTinTuan ?? "") ?? DateTime.now();

    return Container(
      color: const Color(0xfff5f5f5),
      child: SingleChildScrollView(
        child: Column(
          children: [
            WeekSelector(
              semesterTitle: _selectedSemester["name"],
              weekTitle: _selectedWeek != null
                  ? "Tuần ${_selectedWeek!.tuanHocKy}: ${_selectedWeek!.thongTinTuan}"
                  : "Chọn tuần học",
              onSemesterTap: () {
                _showSelectionSheet<Map<String, dynamic>>(
                  title: "Chọn học kỳ",
                  items: _semesters,
                  selectedItem: _selectedSemester,
                  labelBuilder: (s) => s["name"],
                  onSelected: (s) {
                    setState(() => _selectedSemester = s);
                    _initData(s["id"]);
                  },
                );
              },
              onWeekTap: () {
                _showSelectionSheet<TuanTkb>(
                  title: "Chọn tuần học",
                  items: _fullData!.dsTuanTkb,
                  selectedItem: _selectedWeek,
                  labelBuilder: (t) => "Tuần ${t.tuanHocKy}: ${t.thongTinTuan}",
                  onSelected: (t) => setState(() => _selectedWeek = t),
                );
              },
            ),
            
            _buildDayHeader(firstDay),

            SizedBox(
              height: WeekConstants.rowHeight * 14,
              child: Stack(
                children: [
                  const WeekGrid(),
                  if (_selectedWeek != null)
                    ..._buildSubjectBlocks(context, firstDay, _selectedWeek!.dsThoiKhoaBieu),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayHeader(DateTime firstDay) {
    return Container(
      padding: const EdgeInsets.only(left: WeekConstants.timeColumnWidth, right: WeekConstants.timeColumnWidth),
      height: 45,
      decoration: BoxDecoration(
        color: const Color(0xff104492),
        border: Border(bottom: BorderSide(color: Colors.blue.shade100)),
      ),
      child: Row(
        children: List.generate(7, (index) {
          DateTime date = firstDay.add(Duration(days: index));
          return Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.white.withOpacity(0.2), width: 0.5)),
              ),
              child: Center(
                child: Text(
                  "Th ${index + 2 == 8 ? 'CN' : index + 2}\n${date.day}/${date.month}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  List<Widget> _buildSubjectBlocks(BuildContext context, DateTime firstDay, List<ThoiKhoaBieu> schedule) {
    double screenWidth = MediaQuery.of(context).size.width;
    double dayWidth = (screenWidth - (WeekConstants.timeColumnWidth * 2)) / 7;

    return schedule.map((subject) {
      int dayIndex = subject.thu - 2;
      if (dayIndex < 0) dayIndex = 6;

      bool isOverlap = schedule.any((s) =>
          s != subject &&
          s.thu == subject.thu &&
          ((s.tietBatDau >= subject.tietBatDau && s.tietBatDau < subject.tietBatDau + subject.soTiet) ||
              (subject.tietBatDau >= s.tietBatDau && subject.tietBatDau < s.tietBatDau + s.soTiet)));

      return Positioned(
        left: WeekConstants.timeColumnWidth + (dayIndex * dayWidth),
        top: (subject.tietBatDau - 1) * WeekConstants.rowHeight,
        width: dayWidth,
        height: subject.soTiet * WeekConstants.rowHeight,
        child: SubjectBlock(subject: subject, isOverlap: isOverlap),
      );
    }).toList();
  }
}
