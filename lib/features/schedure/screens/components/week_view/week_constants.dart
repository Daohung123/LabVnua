import 'package:flutter/material.dart';

import 'package:aqedu/core/theme/app_components.dart';
class WeekConstants {
  static const double rowHeight = 60.0;
  static const double timeColumnWidth = 60.0;
  static const Color morningColor = AppColors.errorLight; // Hồng nhạt
  static const Color afternoonColor = AppColors.successLight; // Xanh nhạt
  static const Color overlapColor = AppColors.textSecondary;

  static const List<String> periodTimes = [
    "07:00", "07:55", "08:50", "09:55", "10:50",
    "12:45", "13:40", "14:35", "15:40", "16:35",
    "18:00", "18:55", "19:50", "20:40"
  ];
}
