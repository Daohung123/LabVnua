import 'package:aqedu/config/env.dart';
import 'package:aqedu/features/schedure/models/Schedure_Student.dart';
import 'package:aqedu/features/schedure/screens/study_view_day_month.dart';
import 'package:aqedu/shared/widgets/Text/text_common.dart';
import 'package:flutter/material.dart';
import '../../ctrls/ctrl_schedure.dart';

class Schedure extends StatefulWidget {
  const Schedure({super.key});

  @override
  State<Schedure> createState() => _SchedureState();
}

class _SchedureState extends State<Schedure> {
  late Future<List<ThoiKhoaBieu>> _future;

  @override
  void initState() {
    super.initState();
    _future = loadData();
  }

  Future<List<ThoiKhoaBieu>> loadData() async {
    final ctrl = await CtrlSchedure.create();
    return await ctrl.getTkbToday();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width_screen_percent(context, 0.85),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(circle),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔥 Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextCommon(txt: "Thời khóa biểu"),

                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const StudyViewDayMoth(),
                      ),
                    );
                  },
                  child: Row(
                    children: const [
                      Text(
                        "Xem thêm",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            /// 🔥 TKB ngang
            SizedBox(
              height: 150,
              child: FutureBuilder<List<ThoiKhoaBieu>>(
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
                    return const Center(child: Text("Không có lịch học"));
                  }

                  /// ✅ Scroll ngang
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final mon = list[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 12,
                        ),
                        child: _buildCard(mon),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 Card môn học
  Widget _buildCard(ThoiKhoaBieu mon) {
    return Container(
      width: 170,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg_color,
        borderRadius: BorderRadius.circular(circle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 📘 Tên môn
          Text(
            mon.tenMon,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),

          const SizedBox(height: 6),

          /// ⏰ Tiết học
          Row(
            children: [
              const Icon(Icons.access_time, size: 16, color: Colors.grey),
              const SizedBox(width: 5),
              Text(
                "Tiết ${mon.tietBatDau}",
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),

          const SizedBox(height: 4),

          /// 🏫 Phòng
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.grey),
              const SizedBox(width: 5),
              Text("Phòng: ${mon.phong}", style: const TextStyle(fontSize: 13)),
            ],
          ),

          const SizedBox(height: 6),

          /// 👨‍🏫 Giảng viên
          Text(
            mon.giangVien,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
