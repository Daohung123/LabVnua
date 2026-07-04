import 'package:aqedu/core/di/app_dependencies.dart';
import 'package:aqedu/core/theme/app_text_styles.dart';
import 'package:aqedu/core/theme/app_theme.dart';
import 'package:aqedu/features/class_session/domain/entities/class_session_note.dart';
import 'package:aqedu/features/class_session/presentation/controllers/class_session_note_controller.dart';
import 'package:aqedu/features/platform/domain/usecases/record_analytics_event.dart';
import 'package:aqedu/features/schedure/models/schedure_student.dart';
import 'package:flutter/material.dart';

class ClassSessionDetailScreen extends StatefulWidget {
  const ClassSessionDetailScreen({
    super.key,
    required this.schedule,
    this.noteController,
    this.analyticsService,
  });

  final ThoiKhoaBieu schedule;
  final ClassSessionNoteController? noteController;
  final RecordAnalyticsEvent? analyticsService;

  @override
  State<ClassSessionDetailScreen> createState() =>
      _ClassSessionDetailScreenState();
}

class _ClassSessionDetailScreenState extends State<ClassSessionDetailScreen> {
  final _noteTextController = TextEditingController();
  late final ClassSessionNoteController _noteController;
  late final RecordAnalyticsEvent _analyticsService;
  late Future<_ClassSessionNoteState> _notesFuture;
  String? _noteError;

  @override
  void initState() {
    super.initState();
    _noteController =
        widget.noteController ??
        AppDependencies.instance.classSessionNoteController();
    _analyticsService =
        widget.analyticsService ??
        AppDependencies.instance.recordAnalyticsEvent;
    _notesFuture = _loadNotes();
    _analyticsService(
      eventName: 'open',
      featureName: 'class_session',
      metadata: {'source': 'schedule'},
    );
  }

  @override
  void dispose() {
    _noteTextController.dispose();
    super.dispose();
  }

  Future<_ClassSessionNoteState> _loadNotes() async {
    final ownerHash = await _noteController.resolveOwnerHash();
    final notes = await _noteController.loadNotes(
      sessionKey: sessionKeyForSchedule(widget.schedule),
      ownerHash: ownerHash,
    );
    return _ClassSessionNoteState(ownerHash: ownerHash, notes: notes);
  }

  void _refresh() {
    setState(() {
      _notesFuture = _loadNotes();
    });
  }

  Future<void> _createNote(String ownerHash) async {
    setState(() => _noteError = null);
    try {
      await _noteController.createNote(
        sessionKey: sessionKeyForSchedule(widget.schedule),
        ownerHash: ownerHash,
        content: _noteTextController.text,
      );
      _noteTextController.clear();
      await _analyticsService(
        eventName: 'create_note',
        featureName: 'class_session',
      );
      _refresh();
    } on ArgumentError {
      setState(() => _noteError = 'Vui lòng nhập nội dung ghi chú');
    }
  }

  Future<void> _deleteNote(ClassSessionNote note) async {
    await _noteController.deleteNote(note.id);
    await _analyticsService(
      eventName: 'delete_note',
      featureName: 'class_session',
    );
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final schedule = widget.schedule;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Chi tiết buổi học')),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(AppSpacing.lg),
          children: [
            _SessionSummary(schedule: schedule),
            SizedBox(height: AppSpacing.lg),
            FutureBuilder<_ClassSessionNoteState>(
              future: _notesFuture,
              builder: (context, snapshot) {
                final state = snapshot.data;
                return _NotesSection(
                  controller: _noteTextController,
                  errorText: _noteError,
                  isLoading:
                      snapshot.connectionState == ConnectionState.waiting,
                  notes: state?.notes ?? const [],
                  onCreate: state == null
                      ? null
                      : () => _createNote(state.ownerHash),
                  onDelete: _deleteNote,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

String sessionKeyForSchedule(ThoiKhoaBieu schedule) {
  return [
    schedule.ngayhoc,
    schedule.thu,
    schedule.tietBatDau,
    schedule.tenMon,
    schedule.phong,
  ].join('|');
}

class _ClassSessionNoteState {
  const _ClassSessionNoteState({required this.ownerHash, required this.notes});

  final String ownerHash;
  final List<ClassSessionNote> notes;
}

class _SessionSummary extends StatelessWidget {
  const _SessionSummary({required this.schedule});

  final ThoiKhoaBieu schedule;

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
            Text(schedule.tenMon, style: AppTextStyles.sectionTitle),
            SizedBox(height: AppSpacing.sm),
            _InfoLine(icon: Icons.person_outline, text: schedule.giangVien),
            _InfoLine(icon: Icons.meeting_room_outlined, text: schedule.phong),
            _InfoLine(
              icon: Icons.schedule_outlined,
              text: 'Tiết ${schedule.tietBatDau} (${schedule.soTiet} tiết)',
            ),
            _InfoLine(icon: Icons.event_outlined, text: schedule.ngayhoc),
          ],
        ),
      ),
    );
  }
}

class _NotesSection extends StatelessWidget {
  const _NotesSection({
    required this.controller,
    required this.errorText,
    required this.isLoading,
    required this.notes,
    required this.onCreate,
    required this.onDelete,
  });

  final TextEditingController controller;
  final String? errorText;
  final bool isLoading;
  final List<ClassSessionNote> notes;
  final VoidCallback? onCreate;
  final ValueChanged<ClassSessionNote> onDelete;

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
            Text('Ghi chú buổi học', style: AppTextStyles.sectionTitle),
            SizedBox(height: AppSpacing.md),
            TextField(
              key: const Key('class-note-field'),
              controller: controller,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Nội dung ghi chú',
                errorText: errorText,
              ),
            ),
            SizedBox(height: AppSpacing.md),
            FilledButton.icon(
              key: const Key('class-note-create-button'),
              onPressed: onCreate,
              icon: const Icon(Icons.note_add_outlined),
              label: const Text('Lưu ghi chú'),
            ),
            SizedBox(height: AppSpacing.lg),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (notes.isEmpty)
              Text(
                'Chưa có ghi chú local cho buổi học này.',
                style: AppTextStyles.actionTileSubtitle,
              )
            else
              for (final note in notes)
                Card(
                  child: ListTile(
                    key: Key('class-note-${note.id}'),
                    title: Text(note.content),
                    subtitle: Text(note.syncStatus.name),
                    trailing: IconButton(
                      key: Key('class-note-delete-${note.id}'),
                      tooltip: 'Xóa ghi chú',
                      onPressed: () => onDelete(note),
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AppSpacing.xs),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text.trim().isEmpty ? 'Chưa có dữ liệu' : text,
              style: AppTextStyles.actionTileSubtitle,
            ),
          ),
        ],
      ),
    );
  }
}
