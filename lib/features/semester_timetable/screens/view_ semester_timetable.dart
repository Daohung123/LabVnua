import 'package:aqedu/features/semester_timetable/controllers/ctrls_%20semester_timetable.dart';
import 'package:flutter/material.dart';
import '../models/model_semester_timetable.dart';

class SemesterTimetableView extends StatefulWidget {
  const SemesterTimetableView({super.key});

  @override
  State<SemesterTimetableView> createState() => _SemesterTimetableViewState();
}

class _SemesterTimetableViewState extends State<SemesterTimetableView> {
  late Future<List<SemesterTimetableItem>> futureData;

  String selectedSemester = "Học kỳ hiện tại";

  final List<String> semesters = ["Học kỳ hiện tại", "Học kỳ kế tiếp"];

  static const double rowHeight = 90;
  static const double dayWidth = 180;
  static const double periodWidth = 60;

  @override
  void initState() {
    super.initState();
    futureData = _loadData();
  }

  Future<List<SemesterTimetableItem>> _loadData() async {
    final ctrl = await CtrlsemesterTimetable.create();
    return await ctrl.getTkbInSemester();
  }

  final colors = [
    const Color(0xffef476f),
    const Color(0xffff9f1c),
    const Color(0xff06d6a0),
    const Color(0xff118ab2),
    const Color(0xff8338ec),
    const Color(0xff3a86ff),
    const Color(0xfffb5607),
  ];

  Color getColor(String key) {
    return colors[key.hashCode.abs() % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thời khóa biểu học kỳ"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _semesterDropdown(),

          Expanded(
            child: FutureBuilder<List<SemesterTimetableItem>>(
              future: futureData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }

                final list = snapshot.data ?? [];

                if (list.isEmpty) {
                  return const Center(child: Text("Không có dữ liệu"));
                }

                return _buildTimetable(list);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _semesterDropdown() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black12)],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: selectedSemester,
          items: semesters.map((e) {
            return DropdownMenuItem(value: e, child: Text(e));
          }).toList(),
          onChanged: (value) {
            if (value == null) return;

            setState(() {
              selectedSemester = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildTimetable(List<SemesterTimetableItem> list) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: periodWidth + (dayWidth * 7),
        child: Column(
          children: [
            _buildHeader(),

            Expanded(
              child: SingleChildScrollView(
                child: SizedBox(
                  height: rowHeight * 15,
                  child: Stack(
                    children: [
                      _buildGrid(),

                      ...list.map((item) {
                        return _buildSubjectPositioned(item);
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    const days = ["Tiết", "T2", "T3", "T4", "T5", "T6", "T7", "CN"];

    return Row(
      children: days.map((day) {
        return Container(
          width: day == "Tiết" ? periodWidth : dayWidth,
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.blue,
            border: Border.all(color: Colors.white),
          ),
          child: Text(
            day,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGrid() {
    return Column(
      children: List.generate(15, (row) {
        return Row(
          children: [
            Container(
              width: periodWidth,
              height: rowHeight,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                "${row + 1}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            ...List.generate(
              7,
              (_) => Container(
                width: dayWidth,
                height: rowHeight,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSubjectPositioned(SemesterTimetableItem item) {
    final color = getColor(item.maMon ?? item.tenMon ?? "");

    final day = ((item.thu ?? 2) - 2).clamp(0, 6);

    final startPeriod = ((item.tietBatDau ?? 1) - 1);

    return Positioned(
      left: periodWidth + day * dayWidth,
      top: startPeriod * rowHeight,
      width: dayWidth,
      height: (item.soTiet ?? 1) * rowHeight,
      child: GestureDetector(
        onTap: () {
          _showDetail(item);
        },
        child: Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.tenMon ?? "",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                item.maMon ?? "",
                style: const TextStyle(color: Colors.white70),
              ),

              const Spacer(),

              Text(
                "👨 ${item.gv ?? ''}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 11),
              ),

              Text(
                "🏫 ${item.phong ?? ''}",
                style: const TextStyle(color: Colors.white, fontSize: 11),
              ),

              Text(
                "👥 ${item.lop ?? ''}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 11),
              ),

              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${item.tuGio ?? ''} - ${item.denGio ?? ''}",
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetail(SemesterTimetableItem item) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(
                item.tenMon ?? "",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              ListTile(
                title: const Text("Mã môn"),
                subtitle: Text(item.maMon ?? ""),
              ),

              ListTile(
                title: const Text("Giảng viên"),
                subtitle: Text(item.gv ?? ""),
              ),

              ListTile(
                title: const Text("Phòng"),
                subtitle: Text(item.phong ?? ""),
              ),

              ListTile(
                title: const Text("Lớp"),
                subtitle: Text(item.lop ?? ""),
              ),

              ListTile(
                title: const Text("Nhóm tổ"),
                subtitle: Text(item.nhomTo ?? ""),
              ),

              ListTile(
                title: const Text("Giờ học"),
                subtitle: Text("${item.tuGio ?? ''} - ${item.denGio ?? ''}"),
              ),

              ListTile(
                title: const Text("Thứ"),
                subtitle: Text("Thứ ${item.thu}"),
              ),

              ListTile(
                title: const Text("Tiết"),
                subtitle: Text(
                  "${item.tietBatDau} - ${(item.tietBatDau ?? 1) + (item.soTiet ?? 1) - 1}",
                ),
              ),

              if ((item.tooltip ?? "").isNotEmpty)
                ListTile(
                  title: const Text("Ghi chú"),
                  subtitle: Text(item.tooltip!),
                ),
            ],
          ),
        );
      },
    );
  }
}
