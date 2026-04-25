import 'package:aqedu/features/schedure/ctrls/ctrl_schedure.dart';
import 'package:aqedu/features/schedure/models/Schedure_Student.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StudyViewDayMoth extends StatefulWidget {
  const StudyViewDayMoth({super.key});

  @override
  State<StudyViewDayMoth> createState() => _StudyViewDayMothState();
}

class _StudyViewDayMothState extends State<StudyViewDayMoth> {
  DateTime selectedDate = DateTime.now();
  final DateTime today = DateTime.now();

  late Future<List<ThoiKhoaBieu>> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadData();
  }

  Future<List<ThoiKhoaBieu>> _loadData() async {
    final ctrl = await CtrlSchedure.create();
    return await ctrl.getTkbInSemester();
  }

  // ✅ FILTER ĐÚNG
  List<ThoiKhoaBieu> _getFilteredData(List<ThoiKhoaBieu> data) {
    return data.where((item) {
      return DateFormat('yyyy-MM-dd').format(DateTime.parse(item.ngayhoc)) ==
          DateFormat('yyyy-MM-dd').format(selectedDate);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xfff5f5f5),
        appBar: AppBar(
          backgroundColor: const Color(0xff104492),
          elevation: 0,
          title: const Text(
            "Thời khóa biểu",
            style: TextStyle(color: Colors.white),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Ngày"),
              Tab(text: "Tuần"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildDayView(),
            const Center(child: Text("Giao diện tuần")),
          ],
        ),
      ),
    );
  }

  Widget _buildDayView() {
    return Column(
      children: [
        _buildDateHeader(),
        _buildWeekStrip(),
        const SizedBox(height: 10),
        Expanded(child: _buildSubjectList()),
      ],
    );
  }

  // ================== DATA ==================

  Widget _buildSubjectList() {
    return FutureBuilder<List<ThoiKhoaBieu>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text("Lỗi tải dữ liệu"));
        }

        final data = snapshot.data ?? [];
        final list = _getFilteredData(data);

        if (list.isEmpty) {
          return const Center(child: Text("Không có lịch học"));
        }

        return ListView.builder(
          itemCount: list.length,
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) => _buildSubjectCard(list[index]),
        );
      },
    );
  }

  // ================== UI ==================

  Widget _buildDateHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                selectedDate = selectedDate.subtract(const Duration(days: 1));
              });
            },
            icon: const Icon(Icons.arrow_back),
          ),
          Text(
            DateFormat('dd/MM/yyyy').format(selectedDate),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                selectedDate = selectedDate.add(const Duration(days: 1));
              });
            },
            icon: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekStrip() {
    DateTime firstDay = selectedDate.subtract(
      Duration(days: selectedDate.weekday - 1),
    );

    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, index) {
          DateTime date = firstDay.add(Duration(days: index));

          bool isSelected =
              DateFormat('yyyy-MM-dd').format(date) ==
              DateFormat('yyyy-MM-dd').format(selectedDate);
          String thu = "T${date.weekday + 1}";
          if (date.weekday == 7) thu = "CN";
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDate = date;
              });
            },
            child: Container(
              width: 50,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(thu),
                  const SizedBox(height: 5),
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: isSelected
                        ? const Color(0xff104492)
                        : Colors.transparent,
                    child: Text(
                      "${date.day}",
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSubjectCard(ThoiKhoaBieu item) {
    int tietEnd = item.tietBatDau + item.soTiet - 1;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(
          item.tenMon,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Tiết: ${item.tietBatDau} - $tietEnd"),
            Text("Phòng: ${item.phong}"),
            Text("GV: ${item.giangVien}"),
          ],
        ),
      ),
    );
  }
}
