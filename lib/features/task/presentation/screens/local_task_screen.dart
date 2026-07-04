import 'package:aqedu/core/di/app_dependencies.dart';
import 'package:aqedu/core/theme/app_text_styles.dart';
import 'package:aqedu/core/theme/app_theme.dart';
import 'package:aqedu/features/platform/domain/usecases/record_analytics_event.dart';
import 'package:aqedu/features/task/domain/entities/local_task.dart';
import 'package:aqedu/features/task/presentation/controllers/local_task_controller.dart';
import 'package:flutter/material.dart';

class LocalTaskScreen extends StatefulWidget {
  const LocalTaskScreen({super.key, this.controller, this.recordAnalytics});

  final LocalTaskController? controller;
  final RecordAnalyticsEvent? recordAnalytics;

  @override
  State<LocalTaskScreen> createState() => _LocalTaskScreenState();
}

class _LocalTaskScreenState extends State<LocalTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dueController = TextEditingController();

  late final LocalTaskController _controller;
  late final RecordAnalyticsEvent _recordAnalytics;
  late Future<List<LocalTask>> _tasksFuture;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? AppDependencies.instance.localTaskController();
    _recordAnalytics =
        widget.recordAnalytics ?? AppDependencies.instance.recordAnalyticsEvent;
    _tasksFuture = _loadTasks();
    _recordAnalytics(eventName: 'open', featureName: 'local_task');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dueController.dispose();
    super.dispose();
  }

  Future<List<LocalTask>> _loadTasks() => _controller.loadTasks();

  void _refresh() {
    setState(() {
      _tasksFuture = _loadTasks();
    });
  }

  Future<void> _createTask() async {
    setState(() => _errorText = null);
    try {
      await _controller.createTask(
        title: _titleController.text,
        description: _descriptionController.text,
        dueAt: _parseDate(_dueController.text),
      );
      _titleController.clear();
      _descriptionController.clear();
      _dueController.clear();
      await _recordAnalytics(
        eventName: 'create',
        featureName: 'local_task',
        metadata: const {'source': 'task_screen'},
      );
      _refresh();
    } on ArgumentError {
      setState(() => _errorText = 'Vui lòng nhập tiêu đề todo');
    }
  }

  Future<void> _toggle(LocalTask task) async {
    await _controller.toggleTask(task);
    await _recordAnalytics(
      eventName: task.isCompleted ? 'reopen' : 'complete',
      featureName: 'local_task',
    );
    _refresh();
  }

  Future<void> _delete(LocalTask task) async {
    await _controller.deleteTask(task.id);
    await _recordAnalytics(eventName: 'delete', featureName: 'local_task');
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Todo offline')),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(AppSpacing.lg),
          children: [
            _TaskComposer(
              titleController: _titleController,
              descriptionController: _descriptionController,
              dueController: _dueController,
              errorText: _errorText,
              onCreate: _createTask,
            ),
            SizedBox(height: AppSpacing.lg),
            FutureBuilder<List<LocalTask>>(
              future: _tasksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const _StateMessage(
                    icon: Icons.cloud_off_outlined,
                    title: 'Không thể tải todo offline',
                    subtitle: 'Dữ liệu cục bộ chưa sẵn sàng.',
                  );
                }
                final tasks = snapshot.data ?? const [];
                if (tasks.isEmpty) {
                  return const _StateMessage(
                    icon: Icons.task_alt_outlined,
                    title: 'Chưa có todo',
                    subtitle: 'Tạo todo đầu tiên để theo dõi deadline cá nhân.',
                  );
                }
                return Column(
                  children: [
                    for (final task in tasks)
                      _TaskTile(
                        task: task,
                        onToggle: () => _toggle(task),
                        onDelete: () => _delete(task),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  DateTime? _parseDate(String value) {
    final text = value.trim();
    if (text.isEmpty) return null;
    return DateTime.tryParse(text);
  }
}

class _TaskComposer extends StatelessWidget {
  const _TaskComposer({
    required this.titleController,
    required this.descriptionController,
    required this.dueController,
    required this.errorText,
    required this.onCreate,
  });

  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController dueController;
  final String? errorText;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tạo todo', style: AppTextStyles.sectionTitle),
            SizedBox(height: AppSpacing.md),
            TextField(
              key: const Key('task-title-field'),
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Tiêu đề',
                errorText: errorText,
              ),
            ),
            TextField(
              key: const Key('task-description-field'),
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Mô tả'),
            ),
            TextField(
              key: const Key('task-due-field'),
              controller: dueController,
              decoration: const InputDecoration(labelText: 'Hạn YYYY-MM-DD'),
            ),
            SizedBox(height: AppSpacing.md),
            FilledButton.icon(
              key: const Key('task-create-button'),
              onPressed: onCreate,
              icon: const Icon(Icons.add_task_outlined),
              label: const Text('Thêm todo'),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  final LocalTask task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        key: Key('task-tile-${task.id}'),
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (_) => onToggle(),
        ),
        title: Text(
          task.title,
          style: task.isCompleted
              ? const TextStyle(decoration: TextDecoration.lineThrough)
              : null,
        ),
        subtitle: Text(_subtitle),
        trailing: IconButton(
          key: Key('task-delete-${task.id}'),
          tooltip: 'Xóa todo',
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline),
        ),
      ),
    );
  }

  String get _subtitle {
    final due = task.dueAt == null
        ? 'Chưa có hạn'
        : 'Hạn ${task.dueAt!.toIso8601String().split('T').first}';
    return '$due · ${task.syncStatus.name}';
  }
}

class _StateMessage extends StatelessWidget {
  const _StateMessage({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(icon, size: 40, color: AppColors.textSecondary),
          SizedBox(height: AppSpacing.sm),
          Text(title, style: AppTextStyles.actionTileTitle),
          SizedBox(height: AppSpacing.xs),
          Text(subtitle, style: AppTextStyles.actionTileSubtitle),
        ],
      ),
    );
  }
}
