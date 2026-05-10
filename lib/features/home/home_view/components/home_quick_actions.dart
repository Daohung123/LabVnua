import 'package:flutter/material.dart';
import 'package:aqedu/core/theme/app_theme.dart';
import 'package:aqedu/core/theme/app_text_styles.dart';
import 'package:aqedu/core/widgets/components/app_card.dart';
import 'package:aqedu/features/home/home_view/components/home_models.dart';
import 'package:aqedu/features/schedure/screens/study_view_day_month.dart';
import 'package:aqedu/features/score_data/screens/view_score_student.dart';
import 'package:aqedu/features/tuition/screens/view_tuition.dart';
import 'package:aqedu/core/screens/view_developing.dart';

/// Quick Actions component — lối tắt nhanh
class HomeQuickActions extends StatelessWidget {
  const HomeQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final shortcuts = [
      ShortcutData(
        Icons.today_outlined,
        'TKB ngày',
        AppColors.scheduleColor,
        ScheduleScreen(),
      ),
      ShortcutData(
        Icons.grade_outlined,
        'Xem điểm',
        AppColors.scoreColor,
        ScoreStudentView(),
      ),
      ShortcutData(
        Icons.payments_outlined,
        'Học phí',
        AppColors.tuitionColor,
        HocPhiView(),
      ),
      ShortcutData(
        Icons.menu_book_outlined,
        'Học liệu',
        AppColors.materialsColor,
        Developing(),
      ),
    ];

    return AppCard(
      borderRadius: AppRadius.xl,
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Lối tắt', style: AppTextStyles.sectionTitle),
          SizedBox(height: AppSpacing.xs),
          Text(
            'Truy cập nhanh những chức năng bạn dùng nhiều nhất',
            style: AppTextStyles.sectionSubtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: AppSpacing.lg),

          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            childAspectRatio: 3.0,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: shortcuts.map((s) => _ShortcutTile(shortcut: s)).toList(),
          ),
        ],
      ),
    );
  }
}

/// Tile nhỏ cho mỗi shortcut
class _ShortcutTile extends StatelessWidget {
  final ShortcutData shortcut;

  const _ShortcutTile({required this.shortcut});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => shortcut.page as Widget),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: shortcut.color.withOpacity(AppOpacity.bg10),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: shortcut.color.withOpacity(AppOpacity.bg12),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: shortcut.color.withOpacity(AppOpacity.bg18),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(shortcut.icon, color: shortcut.color, size: 20),
            ),

            SizedBox(width: AppSpacing.md),

            Flexible(
              child: Text(
                shortcut.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.actionTileTitle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
