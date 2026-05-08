import 'package:flutter/material.dart';
import 'package:aqedu/core/theme/app_theme.dart';
import 'package:aqedu/core/theme/app_text_styles.dart';
import 'package:aqedu/core/widgets/components/app_card.dart';
import 'package:aqedu/features/schedure/screens/today_schedule_view.dart';
import 'package:aqedu/features/notification/screens/view_noti_student.dart';
import 'package:aqedu/features/tuition/screens/view_tuition.dart';

/// Quick Summary component — hiển thị 3 mục quan trọng
class HomeQuickSummary extends StatelessWidget {
  const HomeQuickSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      borderRadius: AppRadius.xl,
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tổng quan nhanh', style: AppTextStyles.sectionTitle),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      'Xem nhanh các mục quan trọng trước khi bắt đầu ngày học',
                      style: AppTextStyles.sectionSubtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(AppOpacity.bg12),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: const Icon(
                  Icons.dashboard_outlined,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
            ],
          ),

          SizedBox(height: AppSpacing.lg),

          _QuickSummaryItem(
            icon: Icons.calendar_month_outlined,
            title: 'Lịch học hôm nay',
            value: '4 tiết đang chờ',
            color: AppColors.scheduleColor,
            destination: TodayScheduleView(),
          ),

          SizedBox(height: AppSpacing.md),

          _QuickSummaryItem(
            icon: Icons.notifications_active_outlined,
            title: 'Thông báo mới',
            value: '3 thông báo chưa xem',
            color: AppColors.notificationColor,
            destination: NotificationView(),
          ),

          SizedBox(height: AppSpacing.md),

          _QuickSummaryItem(
            icon: Icons.payments_outlined,
            title: 'Học phí',
            value: 'Xem chi tiết công nợ',
            color: AppColors.tuitionColor,
            destination: TuitionView(),
          ),
        ],
      ),
    );
  }
}

/// Item nhỏ trong Quick Summary
class _QuickSummaryItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;
  final Widget destination;

  const _QuickSummaryItem({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: color.withOpacity(AppOpacity.bg10),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: color.withOpacity(AppOpacity.bg12)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withOpacity(AppOpacity.bg18),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(icon, color: color, size: 22),
            ),

            SizedBox(width: AppSpacing.md),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.actionTileTitle,
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.actionTileSubtitle,
                  ),
                ],
              ),
            ),

            Icon(Icons.chevron_right_rounded, color: color, size: 24),
          ],
        ),
      ),
    );
  }
}
