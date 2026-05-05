import 'package:aqedu/core/constants/UI/sizes/size_function.dart';
import 'package:aqedu/core/constants/UI/styles/colors.dart';
import 'package:aqedu/core/constants/env.dart';
import 'package:aqedu/core/widgets/Text/text_common.dart';
import 'package:aqedu/features/schedure/models/Schedure_Student.dart';
import 'package:aqedu/features/schedure/screens/study_view_day_month.dart';

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
      width: width_screen_percent(context, 85),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(circle),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
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
              height: 155, // Tăng chiều cao để không bị cắt card
              child: FutureBuilder<List<ThoiKhoaBieu>>(
                future: _future,
                builder: (context, snapshot) {
                  /// ⏳ Loading
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  /// ❌ Lỗi
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Có lỗi xảy ra khi tải lịch học"),
                    );
                  }

                  final list = snapshot.data ?? [];

                  /// 📭 Không có dữ liệu
                  if (list.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Colors.grey[300],
                            size: 40,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Hôm nay không có lịch học",
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ],
                      ),
                    );
                  }

                  /// ✅ Scroll ngang
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final mon = list[index];

                      return Padding(
                        padding: const EdgeInsets.only(
                          right: 12,
                          top: 8,
                          bottom: 8,
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
      width: 180,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg_color, // Đảm bảo bg_color được định nghĩa trong env.dart
        borderRadius: BorderRadius.circular(circle),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 📘 Tên môn
          Text(
            mon.tenMon,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xff104492),
            ),
          ),

          const Spacer(),

          /// ⏰ Tiết học
          Row(
            children: [
              const Icon(Icons.access_time, size: 14, color: Colors.grey),
              const SizedBox(width: 5),
              Text(
                "Tiết ${mon.tietBatDau} (${mon.soTiet} tiết)",
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),

          const SizedBox(height: 4),

          /// 🏫 Phòng
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 14,
                color: Colors.grey,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  "Phòng: ${mon.phong}",
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          /// 👨‍🏫 Giảng viên
          Row(
            children: [
              const Icon(Icons.person_outline, size: 14, color: Colors.grey),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  mon.giangVien,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, color: Colors.blueGrey),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
