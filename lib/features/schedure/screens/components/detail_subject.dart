import 'package:aqedu/features/schedure/models/Schedure_Student.dart';
import 'package:flutter/material.dart';
import '../../ctrls/ctrl_schedure.dart';

class DetailSubjectSchedure extends StatefulWidget {
  final int tuan;

  const DetailSubjectSchedure({
    super.key,
    required this.tuan,
  });

  @override
  State<DetailSubjectSchedure> createState() =>
      _DetailSubjectSchedureState();
}

class _DetailSubjectSchedureState
    extends State<DetailSubjectSchedure> {
  late Future<List<ThoiKhoaBieu>> _future;

  @override
  void initState() {
    super.initState();
    _future = getTkbToday(widget.tuan);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("TKB hôm nay")),
      body: FutureBuilder<List<ThoiKhoaBieu>>(
        future: _future,
        builder: (context, snapshot) {
          /// ⏳ Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          /// ❌ Lỗi
          if (snapshot.hasError) {
            return const Center(child: Text("Có lỗi xảy ra"));
          }

          final list = snapshot.data ?? [];

          /// 📭 Không có dữ liệu
          if (list.isEmpty) {
            return const Center(
              child: Text("Không có lịch học hôm nay"),
            );
          }

          /// ✅ Hiển thị danh sách
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final mon = list[index];

              return Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      color: Colors.black12,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 📘 Tên môn
                    Text(
                      mon.tenMon,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 6),

                    /// ⏰ Tiết
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 5),
                        Text(
                          "Tiết ${mon.tietBatDau} (${mon.soTiet} tiết)",
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    /// 🏫 Phòng
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 5),
                        Text(
                          "Phòng: ${mon.phong}",
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    /// 👨‍🏫 Giảng viên
                    Text(
                      "GV: ${mon.giangVien}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}