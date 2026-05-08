import 'package:aqedu/features/schedure/controllers/ctrl_schedure.dart';
import 'package:aqedu/features/schedure/models/Schedure_Student.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'components/week_view/week_view_page.dart';

class StudyViewDayMoth extends StatefulWidget {
  const StudyViewDayMoth({super.key});

  @override
  State<StudyViewDayMoth> createState() => _StudyViewDayMothState();
}

class _StudyViewDayMothState extends State<StudyViewDayMoth> with TickerProviderStateMixin {
  DateTime selectedDate = DateTime.now();
  final DateTime today = DateTime.now();

  late Future<List<ThoiKhoaBieu>> _future;
  List<ThoiKhoaBieu> allSchedule = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _future = _loadData();
  }

  Future<List<ThoiKhoaBieu>> _loadData() async {
    final ctrl = await CtrlSchedure.create();
    final data = await ctrl.getTkbInSemester();
    if (mounted) {
      setState(() {
        allSchedule = data;
      });
    }
    return data;
  }

  bool _hasLesson(DateTime date) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    return allSchedule.any((item) =>
        DateFormat('yyyy-MM-dd').format(DateTime.parse(item.ngayhoc)) ==
        formattedDate);
  }

  List<ThoiKhoaBieu> _getFilteredData(List<ThoiKhoaBieu> data) {
    String formattedSelected = DateFormat('yyyy-MM-dd').format(selectedDate);
    return data.where((item) {
      return DateFormat('yyyy-MM-dd').format(DateTime.parse(item.ngayhoc)) ==
          formattedSelected;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: const Color(0xff104492),
        elevation: 0,
        toolbarHeight: 70,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Thời khóa biểu",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(45),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              width: 135,
              height: 34,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
                labelColor: const Color(0xff104492),
                unselectedLabelColor: Colors.white,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: const [
                  Tab(text: "Ngày"),
                  Tab(text: "Tuần"),
                ],
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDayView(),
          // Long_sua :(Lắng nghe sự kiện thay đổi dữ liệu từ WeekViewPage để cập nhật allSchedule cho tab Ngày)
          WeekViewPage(
            allSchedule: allSchedule,
            selectedDate: selectedDate,
            onScheduleChanged: (newList) {
              setState(() {
                allSchedule = newList;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDayView() {
    return Column(
      children: [
        _buildDateHeader(),
        _buildWeekStrip(),
        const SizedBox(height: 5),
        Expanded(child: _buildSubjectList()),
      ],
    );
  }

  Widget _buildDateHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildNavCircleBtn(Icons.arrow_back, () {
                setState(() => selectedDate = selectedDate.subtract(const Duration(days: 1)));
              }),
              const SizedBox(width: 8),
              const Text("Trước", style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xff104492), fontSize: 12)),
              const SizedBox(width: 5),
              const Text("|", style: TextStyle(color: Colors.grey)),
              const SizedBox(width: 5),
              const Text("Sau", style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xff104492), fontSize: 12)),
              const SizedBox(width: 8),
              _buildNavCircleBtn(Icons.arrow_forward, () {
                setState(() => selectedDate = selectedDate.add(const Duration(days: 1)));
              }),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xff104492).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Text(
                  DateFormat('dd/MM/yyyy').format(selectedDate),
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xff104492), fontSize: 12),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.calendar_month, size: 14, color: Color(0xff104492)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavCircleBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: const BoxDecoration(
          color: Color(0xff104492),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 12, color: Colors.white),
      ),
    );
  }

  Widget _buildWeekStrip() {
    DateTime firstDay = selectedDate.subtract(Duration(days: selectedDate.weekday - 1));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 4),
          child: Text(
            "Tháng ${selectedDate.month}/${selectedDate.year}",
            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xff800000), fontSize: 12),
          ),
        ),
        Container(
          height: 80,
          color: Colors.white,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 7,
            itemBuilder: (context, index) {
              DateTime date = firstDay.add(Duration(days: index));
              bool isSelected = DateFormat('yyyy-MM-dd').format(date) ==
                  DateFormat('yyyy-MM-dd').format(selectedDate);

              return GestureDetector(
                onTap: () => setState(() => selectedDate = date),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Th${date.weekday + 1 == 8 ? 'CN' : date.weekday + 1}",
                        style: TextStyle(
                          fontSize: 10,
                          color: isSelected ? const Color(0xff104492) : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        width: 32,
                        height: 38,
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xff104492) : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "${date.day}",
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),
                      // Long_sua :(Hiển thị chấm xanh dựa trên allSchedule được cập nhật mới nhất)
                      if (_hasLesson(date))
                        Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(color: Color(0xff104492), shape: BoxShape.circle),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectList() {
    return FutureBuilder<List<ThoiKhoaBieu>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        // Long_sua :(Luôn lọc dữ liệu từ allSchedule để tab Ngày cập nhật theo học kỳ đang chọn ở tab Tuần)
        final list = _getFilteredData(allSchedule);

        if (list.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today, size: 60, color: Colors.grey[300]),
                const SizedBox(height: 10),
                const Text("Không có lịch học", style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: list.length,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          itemBuilder: (context, index) => _buildSubjectCard(list[index]),
        );
      },
    );
  }

  Widget _buildSubjectCard(ThoiKhoaBieu item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 80,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xff104492).withOpacity(0.04),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Thời gian", style: TextStyle(fontSize: 10, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(item.tietBatDau < 6 ? "07:00" : "12:45", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  Text(item.tietBatDau < 6 ? "11:40" : "17:25", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 6),
                  Container(height: 3, width: 25, decoration: BoxDecoration(color: const Color(0xff104492), borderRadius: BorderRadius.circular(10))),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.tenMon, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff104492))),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text("Tiết: ", style: TextStyle(fontSize: 12)),
                        Wrap(
                          spacing: 3,
                          children: List.generate(item.soTiet, (i) => _buildTietBadge("${item.tietBatDau + i}")),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text("Phòng: ${item.phong}", style: const TextStyle(fontSize: 12, color: Colors.black54)),
                    Text("GV: ${item.giangVien}", style: const TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTietBadge(String txt) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(color: Color(0xff104492), shape: BoxShape.circle),
      child: Text(txt, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
    );
  }
}
