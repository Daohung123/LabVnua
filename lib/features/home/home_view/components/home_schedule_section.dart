import 'package:aqedu/core/theme/app_text_styles.dart';
import 'package:aqedu/core/theme/app_theme.dart';
import 'package:aqedu/core/widgets/components/app_card.dart';
import 'package:aqedu/features/class_session/screens/class_session_detail_screen.dart';
import 'package:aqedu/features/schedure/models/Schedure_Student.dart';
import 'package:aqedu/features/schedure/screens/today_schedule_view.dart';
import 'package:aqedu/features/task/models/task_models.dart';
import 'package:aqedu/features/task/screens/local_task_screen.dart';
import 'package:flutter/material.dart';

class HomeScheduleSection extends StatelessWidget {
  const HomeScheduleSection({
    super.key,
    required this.schedules,
    required this.hasError,
  });

  final List<ThoiKhoaBieu> schedules;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      borderRadius: AppRadius.xl,
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            title: 'Lịch hôm nay',
            subtitle: _todayLabel(DateTime.now()),
            actionLabel: 'Xem đầy đủ',
            onAction: () => _openTodaySchedule(context),
          ),
          SizedBox(height: AppSpacing.lg),
          if (hasError)
            const _ScheduleStateMessage(
              icon: Icons.cloud_off_outlined,
              title: 'Không thể tải lịch hôm nay',
              subtitle: 'Kiểm tra kết nối hoặc mở trang lịch để thử lại.',
              color: AppColors.error,
            )
          else if (schedules.isEmpty)
            const _ScheduleStateMessage(
              icon: Icons.event_available_outlined,
              title: 'Hôm nay không có lịch học',
              subtitle: 'Khi có lịch trong ngày, buổi học sẽ hiển thị tại đây.',
              color: AppColors.scheduleColor,
            )
          else
            SizedBox(
              height: 150,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: schedules.length,
                separatorBuilder: (_, __) => SizedBox(width: AppSpacing.md),
                itemBuilder: (context, index) {
                  return _ScheduleTile(
                    schedule: schedules[index],
                    onTap: () => _openClassSession(context, schedules[index]),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  void _openTodaySchedule(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TodayScheduleView()),
    );
  }

  void _openClassSession(BuildContext context, ThoiKhoaBieu schedule) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ClassSessionDetailScreen(schedule: schedule),
      ),
    );
  }

  String _todayLabel(DateTime now) {
    final day = now.day.toString().padLeft(2, '0');
    final month = now.month.toString().padLeft(2, '0');
    return 'Hôm nay, $day/$month/${now.year}';
  }
}

class _ScheduleTile extends StatelessWidget {
  const _ScheduleTile({required this.schedule, required this.onTap});

  final ThoiKhoaBieu schedule;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _sessionColor(schedule.tietBatDau);
    final room = schedule.phong.trim().isEmpty
        ? 'Chưa có phòng'
        : schedule.phong;

    return InkWell(
      key: Key('home-schedule-${schedule.tietBatDau}-${schedule.tenMon}'),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      onTap: onTap,
      child: Container(
        width: 230,
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: color.withValues(alpha: AppOpacity.bg10),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: color.withValues(alpha: AppOpacity.bg18)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _SmallBadge(
                  label:
                      '${_startTime(schedule.tietBatDau)} - '
                      '${_endTime(schedule.tietBatDau, schedule.soTiet)}',
                  color: color,
                ),
                const Spacer(),
                Icon(Icons.chevron_right_rounded, color: color),
              ],
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              schedule.tenMon,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.actionTileTitle.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            _IconLine(
              icon: Icons.meeting_room_outlined,
              text: room,
              color: color,
            ),
            SizedBox(height: AppSpacing.xs),
            _IconLine(
              icon: Icons.schedule_outlined,
              text: 'Tiết ${schedule.tietBatDau} (${schedule.soTiet} tiết)',
              color: color,
            ),
          ],
        ),
      ),
    );
  }

  Color _sessionColor(int startPeriod) {
    if (startPeriod <= 5) return AppColors.scheduleColor;
    if (startPeriod <= 9) return AppColors.success;
    return AppColors.warning;
  }

  String _startTime(int period) {
    const times = {
      1: '07:00',
      2: '07:55',
      3: '08:50',
      4: '09:55',
      5: '10:50',
      6: '12:45',
      7: '13:40',
      8: '14:35',
      9: '15:30',
      10: '17:25',
      11: '18:15',
      12: '19:05',
    };
    return times[period] ?? '--:--';
  }

  String _endTime(int period, int count) {
    final end = period + count - 1;
    const times = {
      1: '07:50',
      2: '08:45',
      3: '09:40',
      4: '10:45',
      5: '11:40',
      6: '13:35',
      7: '14:30',
      8: '15:25',
      9: '17:20',
      10: '18:10',
      11: '19:00',
      12: '19:50',
    };
    return times[end] ?? '--:--';
  }
}

class HomeDeadlineSection extends StatelessWidget {
  const HomeDeadlineSection({
    super.key,
    required this.tasks,
    required this.hasError,
  });

  final List<LocalTask> tasks;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      borderRadius: AppRadius.xl,
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            title: 'Deadline cá nhân',
            subtitle: 'Todo offline đang chờ đồng bộ',
            actionLabel: 'Mở todo',
            onAction: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LocalTaskScreen()),
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          if (hasError)
            const _ScheduleStateMessage(
              icon: Icons.cloud_off_outlined,
              title: 'Không thể tải todo offline',
              subtitle: 'Mở mục Todo để kiểm tra lại dữ liệu cục bộ.',
              color: AppColors.error,
            )
          else if (tasks.isEmpty)
            const _ScheduleStateMessage(
              icon: Icons.assignment_late_outlined,
              title: 'Chưa có nguồn deadline chính thức',
              subtitle:
                  'Todo offline sẽ hiển thị ở đây; deadline/nộp bài cần contract.',
              color: AppColors.warning,
            )
          else
            Column(
              children: [
                for (final task in tasks.take(3)) _DeadlineTile(task: task),
              ],
            ),
        ],
      ),
    );
  }

}

class _DeadlineTile extends StatelessWidget {
  const _DeadlineTile({required this.task});

  final LocalTask task;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key('home-deadline-${task.id}'),
      width: double.infinity,
      margin: EdgeInsets.only(bottom: AppSpacing.sm),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: AppOpacity.bg10),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: AppOpacity.bg18),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.task_alt_outlined, color: AppColors.warning),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.actionTileTitle,
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  _dueLabel(task.dueAt),
                  style: AppTextStyles.actionTileSubtitle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _dueLabel(DateTime? dueAt) {
    if (dueAt == null) return 'Chưa có hạn';
    final day = dueAt.day.toString().padLeft(2, '0');
    final month = dueAt.month.toString().padLeft(2, '0');
    return 'Hạn $day/$month/${dueAt.year}';
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.sectionTitle),
              SizedBox(height: AppSpacing.xs),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.sectionSubtitle,
              ),
            ],
          ),
        ),
        TextButton(onPressed: onAction, child: Text(actionLabel)),
      ],
    );
  }
}

class _ScheduleStateMessage extends StatelessWidget {
  const _ScheduleStateMessage({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: color.withValues(alpha: AppOpacity.bg10),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: color.withValues(alpha: AppOpacity.bg18)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.actionTileTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle,
                  style: AppTextStyles.actionTileSubtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallBadge extends StatelessWidget {
  const _SmallBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: AppOpacity.bg18),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(label, style: AppTextStyles.chipText.copyWith(color: color)),
    );
  }
}

class _IconLine extends StatelessWidget {
  const _IconLine({
    required this.icon,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.actionTileSubtitle,
          ),
        ),
      ],
    );
  }
}
