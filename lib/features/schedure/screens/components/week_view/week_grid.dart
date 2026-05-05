import 'package:flutter/material.dart';
import 'week_constants.dart';

class WeekGrid extends StatelessWidget {
  const WeekGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final borderColor = Colors.blue.shade100;

    // Long_sua :(Cố định chiều cao bằng tổng chiều cao các tiết học để tránh lỗi RenderBox no size trong Stack)
    return SizedBox(
      height: WeekConstants.rowHeight * 14,
      child: Row(
        children: [
          // Cột Tiết
          _buildColumn(
            width: WeekConstants.timeColumnWidth,
            borderRight: true,
            children: List.generate(14, (index) => _buildCell("Tiết ${index + 1}", isBold: true)),
          ),
          // Lưới các ngày
          Expanded(
            child: Row(
              children: List.generate(7, (index) => Expanded(
                child: _buildColumn(
                  borderRight: true,
                  children: List.generate(14, (index) => _buildCell("")),
                ),
              )),
            ),
          ),
          // Cột Giờ
          _buildColumn(
            width: WeekConstants.timeColumnWidth,
            borderLeft: true,
            children: List.generate(14, (index) => _buildCell(WeekConstants.periodTimes[index])),
          ),
        ],
      ),
    );
  }

  Widget _buildColumn({double? width, bool borderRight = false, bool borderLeft = false, required List<Widget> children}) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: borderRight ? BorderSide(color: Colors.blue.shade100) : BorderSide.none,
          left: borderLeft ? BorderSide(color: Colors.blue.shade100) : BorderSide.none,
        ),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildCell(String text, {bool isBold = false}) {
    return Container(
      height: WeekConstants.rowHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.blue.shade50)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          color: isBold ? const Color(0xff104492) : Colors.black54,
        ),
      ),
    );
  }
}
