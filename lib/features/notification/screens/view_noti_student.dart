import 'package:aqedu/core/logging/app_log.dart';
import 'package:aqedu/features/notification/controllers/ctrl_noti_student.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_html/flutter_html.dart';

import '../models/notification_student.dart';

import 'package:aqedu/core/theme/app_components.dart';
class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  static const Color _bgTop = AppColors.background;
  static const Color _bgBottom = AppColors.background;
  static const Color _cardColor = AppColors.white;
  static const Color _brandColor = AppColors.primaryPressed;
  static const Color _brandColorSoft = AppColors.background;
  static const Color _textDark = AppColors.textPrimary;
  static const Color _textMuted = AppColors.textSecondary;
  static const Color _warning = AppColors.error;
  static const Color _danger = AppColors.error;

  late Future<List<NotificationItem>> _futureNotifications;

  @override
  void initState() {
    super.initState();
    AppLog.vongDoi(
      'Màn hình trung tâm thông báo được mở',
      khuVuc: 'Trung tâm thông báo',
    );
    _futureNotifications = _loadNotifications();
  }

  Future<List<NotificationItem>> _loadNotifications() async {
    AppLog.thongBao(
      'Bắt đầu tải danh sách thông báo',
      khuVuc: 'Trung tâm thông báo',
    );
    try {
      final ctrl = CtrlNotiStudent();
      final notifications = await ctrl.getNotification();
      AppLog.thongBao(
        'Tải danh sách thông báo hoàn tất',
        khuVuc: 'Trung tâm thông báo',
        duLieu: {
          'so_luong': notifications.length,
          'chua_doc': notifications.where((e) => !(e.isDaDoc ?? false)).length,
        },
      );
      return notifications;
    } catch (e, stackTrace) {
      AppLog.loi(
        'Tải danh sách thông báo gặp lỗi',
        khuVuc: 'Trung tâm thông báo',
        loi: e,
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  Widget _buildHtmlContent(
    String? html, {
    double fontSize = 13.5,
    double? height,
  }) {
    final widget = Html(
      data: html ?? 'Không có nội dung',
      style: {
        "body": Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          fontSize: FontSize(fontSize),
          color: _textMuted,
        ),
        "p": Style(margin: Margins.zero, padding: HtmlPaddings.zero),
      },
    );

    if (height != null) {
      return ClipRect(
        child: SizedBox(height: height, child: widget),
      );
    }

    return widget;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgBottom,
      appBar: AppBar(
        backgroundColor: AppColors.primaryPressed,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        surfaceTintColor: AppColors.transparent,
        title: const Text(
          'Thông báo',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: Container(
        color: AppColors.background,
        child: SafeArea(
          top: false,
          child: FutureBuilder<List<NotificationItem>>(
            future: _futureNotifications,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(child: Text('Có lỗi khi tải thông báo'));
              }

              final List<NotificationItem> notifications = snapshot.data ?? [];
              final int unreadCount = notifications
                  .where((e) => !(e.isDaDoc ?? false))
                  .length;

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                    child: _buildHeader(
                      context,
                      notifications.length,
                      unreadCount,
                    ),
                  ),
                  Expanded(
                    child: notifications.isEmpty
                        ? _buildEmptyState()
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                            itemCount: notifications.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: AppSpacing.md),
                            itemBuilder: (context, index) {
                              final item = notifications[index];
                              return _buildNotificationCard(context, item);
                            },
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int total, int unread) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.mediumShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.16),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.white.withOpacity(0.18)),
            ),
            child: const Icon(
              Icons.notifications_rounded,
              color: AppColors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Trung tâm thông báo',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Bạn đang có $total thông báo • $unread chưa đọc',
                  style: TextStyle(
                    color: AppColors.white.withOpacity(0.86),
                    fontSize: 12.5,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.14),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.white.withOpacity(0.16)),
            ),
            child: Text(
              unread > 0 ? '$unread mới' : 'Đã đọc hết',
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context, NotificationItem item) {
    final bool isRead = item.isDaDoc ?? false;
    final bool isUrgent = item.isPhaiXem ?? false;

    final Color accentColor = isUrgent ? _warning : _brandColor;
    final Color iconBg = isUrgent ? AppColors.divider : _brandColorSoft;
    final IconData icon = isUrgent
        ? Icons.priority_high_rounded
        : Icons.notifications_none_rounded;

    return Material(
      color: AppColors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: () => _showDetail(context, item),
        child: Ink(
          decoration: BoxDecoration(
            color: _cardColor,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: isRead
                  ? AppColors.border
                  : accentColor.withOpacity(0.22),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.05),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: isRead ? AppColors.border : accentColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppRadius.lg),
                      bottomLeft: Radius.circular(AppRadius.lg),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            color: iconBg,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(icon, color: accentColor, size: 26),
                        ),
                        if (!isRead)
                          Positioned(
                            right: -1,
                            top: -1,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: _danger,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  item.tieuDe ?? 'Không có tiêu đề',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15.5,
                                    height: 1.25,
                                    fontWeight: isRead
                                        ? FontWeight.w600
                                        : FontWeight.w800,
                                    color: _textDark,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                item.ngayGui != null
                                    ? DateFormat(
                                        'dd/MM/yyyy',
                                      ).format(item.ngayGui!)
                                    : '--/--',
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  color: _textMuted,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          _buildHtmlContent(
                            item.noiDung,
                            fontSize: 13.5,
                            height: 42,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Row(
                            children: [
                              const Icon(
                                Icons.person_outline_rounded,
                                size: 16,
                                color: _textMuted,
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Expanded(
                                child: Text(
                                  item.nguoiGui ?? 'N/A',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: _textMuted,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              if (isUrgent) _tag('Quan trọng', _warning),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.notifications_off_outlined,
              size: 68,
              color: AppColors.textTertiary,
            ),
            SizedBox(height: 14),
            Text(
              'Chưa có thông báo nào',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: _textDark,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Bạn sẽ thấy thông báo mới tại đây khi có cập nhật.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: _textMuted, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetail(BuildContext context, NotificationItem item) {
    AppLog.thaoTacNguoiDung(
      'Người dùng mở chi tiết thông báo',
      khuVuc: 'Trung tâm thông báo',
      duLieu: {
        'ma_thong_bao': item.id,
        'da_doc': item.isDaDoc,
        'bat_buoc_xem': item.isPhaiXem,
      },
    );
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: _bgBottom,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 46,
                          height: 5,
                          decoration: BoxDecoration(
                            color: AppColors.borderStrong,
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: _cardColor,
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withOpacity(0.05),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.tieuDe ?? 'Không có tiêu đề',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: _textDark,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _infoChip(
                                  icon: Icons.person_outline_rounded,
                                  label: item.nguoiGui ?? 'N/A',
                                ),
                                _infoChip(
                                  icon: Icons.calendar_today_rounded,
                                  label: item.ngayGui != null
                                      ? DateFormat(
                                          'dd/MM/yyyy',
                                        ).format(item.ngayGui!)
                                      : '--/--',
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            _buildHtmlContent(item.noiDung, fontSize: 14),
                            const SizedBox(height: 14),
                            if ((item.dsDoiTuong ?? []).isNotEmpty) ...[
                              const Text(
                                'Đối tượng nhận',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: _textDark,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: (item.dsDoiTuong ?? []).map((e) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceAlt,
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      e,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: _textDark,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _infoChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: _textMuted),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: _textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
