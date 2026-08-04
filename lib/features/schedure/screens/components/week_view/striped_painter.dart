import 'package:flutter/material.dart';

import 'package:aqedu/core/theme/app_components.dart';
class StripedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.black26
      ..strokeWidth = 1.5;

    // Long_sua :(Thêm clipRect để giới hạn các đường gạch chéo chỉ nằm trong khung của ô môn học)
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    const gap = 8.0;
    for (double i = -size.height; i < size.width; i += gap) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
