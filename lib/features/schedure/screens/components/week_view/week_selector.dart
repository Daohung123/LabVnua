import 'package:flutter/material.dart';

import 'package:aqedu/core/theme/app_components.dart';
class WeekSelector extends StatelessWidget {
  final String semesterTitle;
  final String weekTitle;
  final VoidCallback? onSemesterTap;
  final VoidCallback? onWeekTap;

  const WeekSelector({
    super.key,
    required this.semesterTitle,
    required this.weekTitle,
    this.onSemesterTap,
    this.onWeekTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Thời khóa biểu tuần",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: AppSpacing.md),
          // Bộ chọn học kỳ
          _buildDropdownBtn(
            context,
            icon: Icons.calendar_today_outlined,
            title: semesterTitle,
            onTap: onSemesterTap,
          ),
          const SizedBox(height: 10),
          // Bộ chọn tuần
          _buildDropdownBtn(
            context,
            icon: Icons.calendar_month_outlined,
            title: weekTitle,
            onTap: onWeekTap,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownBtn(BuildContext context, {required IconData icon, required String title, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.divider),
          boxShadow: [
            BoxShadow(color: AppColors.black.withOpacity(0.03), blurRadius: 10)
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryPressed, size: 24),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
