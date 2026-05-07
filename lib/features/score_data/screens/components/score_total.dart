import 'package:flutter/material.dart';
import '../../../../core/constants/UI/styles/colors.dart';

class ScoreTotalCard extends StatelessWidget {
  final dynamic semester;

  const ScoreTotalCard({
    super.key,
    required this.semester,
  });

  Widget buildRow({
    required String left,
    required String right,
    bool isRed = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black12),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              left,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Text(
            right,
            style: TextStyle(
              fontSize: 16,
              color: isRed ? Colors.redAccent : textBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [

          buildRow(
            left: "Điểm trung bình học kỳ hệ 4",
            right: semester.dtbHkHe4 ?? "-",
            isRed: semester.dtbHkHe4 == "-",
          ),

          buildRow(
            left: "Điểm trung bình tích lũy hệ 4",
            right: semester.dtbTichLuyHe4 ?? "-",
          ),

          buildRow(
            left: "Điểm trung bình học kỳ hệ 10",
            right: semester.dtbHkHe10 ?? "-",
            isRed: semester.dtbHkHe10 == "-",
          ),

          buildRow(
            left: "Điểm trung bình tích lũy hệ 10",
            right: semester.dtbTichLuyHe10 ?? "-",
          ),

          buildRow(
            left: "Số tín chỉ đạt học kỳ",
            right: semester.soTinChiDatHk ?? "-",
            isRed: semester.soTinChiDatHk == "-",
          ),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 13),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    "Số TC tích lũy",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                Text(
                  semester.soTinChiDatTichLuy ?? "-",
                  style: TextStyle(
                    fontSize: 16,
                    color: textBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}