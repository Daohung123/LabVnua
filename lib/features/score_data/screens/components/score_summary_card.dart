import 'package:flutter/material.dart';
import '../../../../core/constants/UI/styles/colors.dart';

class ScoreSummaryCard extends StatelessWidget {
  final dynamic semester;

  const ScoreSummaryCard({
    super.key,
    required this.semester,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Text(
            "Số TC tích lũy",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            semester.soTinChiDatTichLuy ?? "0",
            style: TextStyle(
              fontSize: 16,
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}