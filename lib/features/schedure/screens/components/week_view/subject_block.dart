import 'package:flutter/material.dart';
import 'week_constants.dart';
import 'striped_painter.dart';
import '../../../models/Schedure_Student.dart';

class SubjectBlock extends StatelessWidget {
  final ThoiKhoaBieu subject;
  final bool isOverlap;

  const SubjectBlock({
    super.key,
    required this.subject,
    this.isOverlap = false,
  });

  @override
  Widget build(BuildContext context) {
    // Xác định màu sắc dựa trên buổi (Sáng/Chiều)
    // Giả định tiết 1-5 là sáng, 6-14 là chiều
    Color bgColor = subject.tietBatDau <= 5 
        ? WeekConstants.morningColor 
        : WeekConstants.afternoonColor;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.blue.shade200, width: 0.5),
      ),
      child: Stack(
        children: [
          // Nếu trùng lịch thì vẽ gạch xám
          if (isOverlap)
            Positioned.fill(
              child: CustomPaint(
                painter: StripedPainter(),
              ),
            ),
          
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (subject.soTiet >= 2)
                  const Icon(Icons.edit_calendar, size: 12, color: Colors.blueGrey),
                Expanded(
                  child: Text(
                    subject.tenMon,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
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
