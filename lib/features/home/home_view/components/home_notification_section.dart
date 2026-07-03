import 'package:aqedu/core/theme/app_text_styles.dart';
import 'package:aqedu/core/theme/app_theme.dart';
import 'package:aqedu/core/widgets/components/app_card.dart';
import 'package:aqedu/features/notification/models/notification_student.dart';
import 'package:aqedu/features/notification/screens/view_noti_student.dart';
import 'package:flutter/material.dart';

class HomeNotificationSection extends StatelessWidget {
  const HomeNotificationSection({
    super.key,
    required this.notifications,
    required this.hasError,
  });

  final List<NotificationItem> notifications;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final unreadCount = notifications
        .where((item) => item.isDaDoc != true)
        .length;
    final visibleItems = notifications.take(3).toList();

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
                    Text('Thông báo', style: AppTextStyles.sectionTitle),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      unreadCount > 0
                          ? '$unreadCount thông báo chưa đọc'
                          : 'Không có thông báo chưa đọc',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.sectionSubtitle,
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => _openNotifications(context),
                child: const Text('Xem tất cả'),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          if (hasError)
            const _NotificationStateMessage(
              icon: Icons.cloud_off_outlined,
              title: 'Không thể tải thông báo',
              subtitle: 'Mở trung tâm thông báo để thử lại.',
              color: AppColors.error,
            )
          else if (visibleItems.isEmpty)
            const _NotificationStateMessage(
              icon: Icons.notifications_none_outlined,
              title: 'Chưa có thông báo mới',
              subtitle: 'Thông báo đào tạo sẽ hiển thị tại đây.',
              color: AppColors.notificationColor,
            )
          else
            Column(
              children: [
                for (final item in visibleItems) ...[
                  _NotificationTile(item: item),
                  if (item != visibleItems.last)
                    SizedBox(height: AppSpacing.sm),
                ],
              ],
            ),
        ],
      ),
    );
  }

  void _openNotifications(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NotificationView()),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.item});

  final NotificationItem item;

  @override
  Widget build(BuildContext context) {
    final isUnread = item.isDaDoc != true;
    final title = item.tieuDe?.trim().isNotEmpty == true
        ? item.tieuDe!.trim()
        : 'Không có tiêu đề';
    final body = _cleanPreview(item.noiDung);

    return Container(
      key: Key('home-notification-${item.id ?? title}'),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isUnread
            ? AppColors.notificationColor.withValues(alpha: AppOpacity.bg10)
            : AppColors.background,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: isUnread
              ? AppColors.notificationColor.withValues(alpha: AppOpacity.bg18)
              : AppColors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isUnread
                ? Icons.notifications_active_outlined
                : Icons.notifications_none_outlined,
            color: AppColors.notificationColor,
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.actionTileTitle,
                ),
                if (body.isNotEmpty) ...[
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.actionTileSubtitle,
                  ),
                ],
                SizedBox(height: AppSpacing.xs),
                Text(
                  _dateLabel(item.ngayGui),
                  style: AppTextStyles.chipText.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _cleanPreview(String? html) {
    final source = html?.trim() ?? '';
    if (source.isEmpty) return '';
    return source
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  String _dateLabel(DateTime? date) {
    if (date == null) return '--/--';
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }
}

class _NotificationStateMessage extends StatelessWidget {
  const _NotificationStateMessage({
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
