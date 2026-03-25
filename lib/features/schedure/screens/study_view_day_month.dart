import 'package:aqedu/config/env.dart';
import 'package:aqedu/shared/models/daotao/tkb.dart'; 
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

  // 1. Dữ liệu mẫu (Giả lập dữ liệu từ database/API)
  List<ThoiKhoaBieu> dummyData = [
    ThoiKhoaBieu(
      tenMon: "An toàn hệ thống thông tin",
      tenGiangVien: "Nguyễn Thị Lan",
      maPhong: "TT312-TT312",
      tietBatDau: 2,
      soTiet: 4,
      ngayHoc: "2026-03-24", // Trùng ngày hôm nay
    ),
    ThoiKhoaBieu(
      tenMon: "Kỹ năng quản lý bản thân",
      tenGiangVien: "Trần Thị Thanh Tâm",
      maPhong: "E201-",
      tietBatDau: 6,
      soTiet: 5,
      ngayHoc: "2026-03-24",
    ),
  ];

  // 2. Hàm lọc dữ liệu theo ngày được chọn
  List<ThoiKhoaBieu> _getFilteredData() {
    String formattedSelected = DateFormat('yyyy-MM-dd').format(selectedDate);
    // Ở bước này, nếu bạn muốn test việc thay đổi dữ liệu khi bấm ngày,
    // bạn có thể trả về list rỗng cho các ngày không phải là 24/03/2026.
    if (formattedSelected == "2026-03-24") {
      return dummyData;
    }
    return []; // Trả về danh sách trống cho các ngày khác để thấy sự thay đổi
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
          title: const Text("Thời khóa biểu", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: const TabBar(
            tabs: [Tab(text: "Ngày"), Tab(text: "Tuần")],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
          ),
        ),
        body: TabBarView(
          children: [
            _buildDayView(),
            const Center(child: Text("Giao diện xem theo Tuần")),
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
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text("Chi tiết thời khóa biểu", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
        Expanded(child: _buildSubjectList()),
      ],
    );
  }

  // --- WIDGETS THÀNH PHẦN ---

  Widget _buildDateHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavBtn("Trước", Icons.arrow_back_ios, () {
            setState(() => selectedDate = selectedDate.subtract(const Duration(days: 1)));
          }),
          InkWell(
            onTap: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) setState(() => selectedDate = picked);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  Text(DateFormat('dd/MM/yyyy').format(selectedDate), style: const TextStyle(color: Color(0xff104492), fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  const Icon(Icons.calendar_month, size: 20, color: Color(0xff104492)),
                ],
              ),
            ),
          ),
          _buildNavBtn("Sau", Icons.arrow_forward_ios, () {
            setState(() => selectedDate = selectedDate.add(const Duration(days: 1)));
          }, isLeading: false),
        ],
      ),
    );
  }

  Widget _buildNavBtn(String text, IconData icon, VoidCallback onTap, {bool isLeading = true}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          if (isLeading) Icon(icon, size: 14),
          Text(text, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xff104492))),
          if (!isLeading) Icon(icon, size: 14),
        ],
      ),
    );
  }

  Widget _buildWeekStrip() {
    DateTime firstDayOfWeek = selectedDate.subtract(Duration(days: selectedDate.weekday - 1));

    return Container(
      height: 100,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, index) {
          DateTime date = firstDayOfWeek.add(Duration(days: index));
          bool isSelected = date.day == selectedDate.day && date.month == selectedDate.month;
          bool isToday = date.day == today.day && date.month == today.month && date.year == today.year;

          return GestureDetector(
            onTap: () => setState(() => selectedDate = date),
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Th${index + 2 == 8 ? '7' : index + 2}",
                      style: TextStyle(fontSize: 12, color: isSelected ? Colors.blue : (isToday ? Colors.green : Colors.grey))),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: isToday ? Border.all(color: Colors.green, width: 2) : null,
                    ),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: isSelected ? const Color(0xff104492) : Colors.transparent,
                      child: Text("${date.day}",
                          style: TextStyle(color: isSelected ? Colors.white : (isToday ? Colors.green : Colors.black), fontWeight: FontWeight.bold)),
                    ),
                  ),
                  if (isToday) Container(margin: const EdgeInsets.only(top: 4), width: 4, height: 4, decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle))
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSubjectList() {
    final list = _getFilteredData();
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today_outlined, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text("Không có lịch học cho hôm nay", style: TextStyle(color: Color(0xff104492), fontWeight: FontWeight.bold)),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: list.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) => _buildSubjectCard(list[index]),
    );
  }

  Widget _buildSubjectCard(ThoiKhoaBieu item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 90,
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Thời gian", style: TextStyle(fontSize: 11, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(item.tietBatDau! < 5 ? "07:55" : "12:45", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(item.tietBatDau! < 5 ? "11:40" : "17:25", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  Container(height: 3, width: 40, decoration: BoxDecoration(color: const Color(0xff104492), borderRadius: BorderRadius.circular(10))),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.tenMon ?? "", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xff104492))),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text("Tiết: ", style: TextStyle(fontSize: 13)),
                        Wrap(spacing: 4, children: List.generate(item.soTiet ?? 0, (i) => _buildBadge("${item.tietBatDau! + i}"))),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text("Phòng: ${item.maPhong}", style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    Text("GV: ${item.tenGiangVien}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600, fontSize: 13)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String txt) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: const Color(0xff104492), borderRadius: BorderRadius.circular(5)),
      child: Text(txt, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}