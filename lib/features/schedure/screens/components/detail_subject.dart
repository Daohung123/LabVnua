import 'package:aqedu/features/schedure/models/schedure_student.dart';
import 'package:flutter/material.dart';
import '../../controllers/ctrl_schedure.dart';
import 'week_view/week_view_page.dart';

class DetailSubjectSchedure extends StatefulWidget {
  final int tuan;

  const DetailSubjectSchedure({super.key, required this.tuan});

  @override
  State<DetailSubjectSchedure> createState() => _DetailSubjectSchedureState();
}

class _DetailSubjectSchedureState extends State<DetailSubjectSchedure>
    with TickerProviderStateMixin {
  late Future<List<ThoiKhoaBieu>> _future;
  List<ThoiKhoaBieu> allSchedule = [];
  late TabController _tabController;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _future = _loadData();
  }

  Future<List<ThoiKhoaBieu>> _loadData() async {
    final ctrl = await CtrlSchedure.create();
    // Long_sua :(Tải toàn bộ kỳ học để trang chi tiết cũng hiển thị được giao diện tuần)
    final data = await ctrl.getTkbInSemester();
    if (mounted) {
      setState(() {
        allSchedule = data;
      });
    }
    return data;
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
          "Chi tiết thời khóa biểu",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
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
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
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
          // Long_sua :(Tích hợp giao diện tuần vào trang chi tiết để đồng bộ với trang chính)
          WeekViewPage(allSchedule: allSchedule, selectedDate: selectedDate),
        ],
      ),
    );
  }

  Widget _buildDayView() {
    return FutureBuilder<List<ThoiKhoaBieu>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final todayStr = DateTime.now().toString().split(' ')[0];
        final list = allSchedule
            .where((item) => item.ngayhoc == todayStr)
            .toList();

        if (list.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today, size: 60, color: Colors.grey[300]),
                const SizedBox(height: 10),
                const Text(
                  "Không có lịch học hôm nay",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: list.length,
          padding: const EdgeInsets.all(16),
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
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 80,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xff104492).withOpacity(0.04),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Thời gian",
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.tietBatDau < 6 ? "07:00" : "12:45",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    item.tietBatDau < 6 ? "11:40" : "17:25",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 3,
                    width: 25,
                    decoration: BoxDecoration(
                      color: const Color(0xff104492),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.tenMon,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff104492),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text("Tiết: ", style: TextStyle(fontSize: 12)),
                        Wrap(
                          spacing: 3,
                          children: List.generate(
                            item.soTiet,
                            (i) => _buildTietBadge("${item.tietBatDau + i}"),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Phòng: ${item.phong}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      "GV: ${item.giangVien}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
      decoration: const BoxDecoration(
        color: Color(0xff104492),
        shape: BoxShape.circle,
      ),
      child: Text(
        txt,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
