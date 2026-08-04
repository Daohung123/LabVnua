import 'package:aqedu/features/notification/controllers/data_change_notification_controller.dart';
import 'package:aqedu/features/notification/models/data_change_models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:aqedu/core/theme/app_components.dart';
class DataChangeNotificationView extends StatefulWidget {
  const DataChangeNotificationView({super.key});

  @override
  State<DataChangeNotificationView> createState() =>
      _DataChangeNotificationViewState();
}

class _DataChangeNotificationViewState
    extends State<DataChangeNotificationView> {
  final DataChangeNotificationController _controller =
      DataChangeNotificationController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerChanged);
    _controller.loadHistory();
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thay đổi dữ liệu (${_controller.unreadCount})'),
        actions: [
          IconButton(
            tooltip: 'Đồng bộ',
            onPressed: _controller.isLoading ? null : _controller.refreshNow,
            icon: const Icon(Icons.sync_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _controller.refreshNow();
        },
        child: _controller.isLoading
            ? const Center(child: CircularProgressIndicator())
            : _controller.history.isEmpty
            ? ListView(
                children: const [
                  SizedBox(height: 160),
                  Icon(Icons.notifications_none_rounded, size: 56),
                  SizedBox(height: AppSpacing.md),
                  Center(child: Text('Chưa có thay đổi dữ liệu')),
                ],
              )
            : ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.lg),
                itemCount: _controller.history.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final change = _controller.history[index];
                  return _DataChangeTile(
                    change: change,
                    onTap: () => _controller.markAsRead(change.id),
                  );
                },
              ),
      ),
    );
  }
}

class _DataChangeTile extends StatelessWidget {
  final DataChange change;
  final VoidCallback onTap;

  const _DataChangeTile({required this.change, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = change.isRead
        ? AppColors.textSecondary
        : Theme.of(context).colorScheme.primary;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        side: BorderSide(color: color.withValues(alpha: 0.22)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(_iconFor(change.changeType), color: color),
        title: Text(
          change.message,
          style: TextStyle(
            fontWeight: change.isRead ? FontWeight.w500 : FontWeight.w700,
          ),
        ),
        subtitle: Text(
          '${change.dataType.label} - ${DateFormat('dd/MM/yyyy HH:mm').format(change.createdAt)}',
        ),
        trailing: change.isRead
            ? null
            : const Icon(Icons.circle, size: 10, color: AppColors.error),
      ),
    );
  }

  IconData _iconFor(DataChangeType type) {
    switch (type) {
      case DataChangeType.added:
        return Icons.add_circle_outline_rounded;
      case DataChangeType.updated:
        return Icons.change_circle_outlined;
      case DataChangeType.removed:
        return Icons.remove_circle_outline_rounded;
    }
  }
}
