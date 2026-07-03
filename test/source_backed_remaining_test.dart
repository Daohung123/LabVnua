import 'package:aqedu/features/ai_assistant/screens/ai_chat_screen.dart';
import 'package:aqedu/features/ai_assistant/services/ai_context_service.dart';
import 'package:aqedu/core/services_root/sqlite/api_cache/api_response_cache.dart';
import 'package:aqedu/features/class_session/controllers/class_session_note_controller.dart';
import 'package:aqedu/features/class_session/models/class_session_note.dart';
import 'package:aqedu/features/class_session/screens/class_session_detail_screen.dart';
import 'package:aqedu/features/home/home_view/components/home_shortcut_catalog.dart';
import 'package:aqedu/features/home/study_view/screens/study_view.dart';
import 'package:aqedu/features/platform/models/analytics_event.dart';
import 'package:aqedu/features/platform/services/local_analytics_service.dart';
import 'package:aqedu/features/schedure/models/Schedure_Student.dart';
import 'package:aqedu/features/task/controllers/local_task_controller.dart';
import 'package:aqedu/features/task/models/task_models.dart';
import 'package:aqedu/features/task/screens/local_task_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Offline daotao cache', () {
    test('uses stable request hash regardless of map key order', () {
      final left = ApiResponseCacheService.hashRequestBody({
        'filter': {'hoc_ky': 20252, 'ten_hoc_ky': ''},
        'additional': {
          'paging': {'limit': 100, 'page': 1},
        },
      });
      final right = ApiResponseCacheService.hashRequestBody({
        'additional': {
          'paging': {'page': 1, 'limit': 100},
        },
        'filter': {'ten_hoc_ky': '', 'hoc_ky': 20252},
      });

      expect(left, right);
    });
  });

  group('AI assistant source-backed slice', () {
    test('context selector loads only relevant local tables', () {
      final selector = AiContextSelector();

      expect(
        selector.shouldLoadNotifications('Có thông báo mới không?'),
        isTrue,
      );
      expect(selector.shouldLoadSchedule('Lịch học hôm nay thế nào?'), isTrue);
      expect(selector.shouldLoadNotifications('Gợi ý cách học CSDL'), isFalse);
      expect(selector.shouldLoadSchedule('Gợi ý cách học CSDL'), isFalse);
    });

    testWidgets('AI screen sends prompt and renders response', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AIChatScreen(askHandler: (_) async => 'Câu trả lời test'),
        ),
      );

      await tester.enterText(
        find.byKey(const Key('ai-page-input')),
        'Lịch học',
      );
      await tester.tap(find.byKey(const Key('ai-page-send')));
      await tester.pumpAndSettle();

      expect(find.text('Lịch học'), findsOneWidget);
      expect(find.text('Câu trả lời test'), findsOneWidget);
    });
  });

  group('Learning portal source-backed slice', () {
    testWidgets('filters catalog and shows empty state', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HocTapView(analyticsService: _NoopAnalyticsService()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('learning-search-field')),
        'todo',
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('learning-item-tasks')), findsOneWidget);

      await tester.enterText(
        find.byKey(const Key('learning-search-field')),
        'khong-co',
      );
      await tester.pumpAndSettle();

      expect(find.text('Không tìm thấy chức năng'), findsOneWidget);
    });
  });

  group('Task and platform local slice', () {
    test('analytics validator rejects sensitive metadata', () {
      final validator = AnalyticsEventValidator();

      expect(validator.isAllowedMetadata({'source': 'search_box'}), isTrue);
      expect(validator.isAllowedMetadata({'token': 'abc'}), isFalse);
      expect(validator.isAllowedMetadata({'email': 'a@example.com'}), isFalse);
      expect(validator.isAllowedMetadata({'value': 'Bearer abc'}), isFalse);
    });

    testWidgets('local todo CRUD flow renders created task', (tester) async {
      final repository = _FakeTaskRepository();
      final controller = LocalTaskController(repository: repository);

      await tester.pumpWidget(
        MaterialApp(
          home: LocalTaskScreen(
            controller: controller,
            analyticsService: _NoopAnalyticsService(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('task-title-field')),
        'Ôn tập AI',
      );
      await tester.enterText(
        find.byKey(const Key('task-due-field')),
        '2026-07-05',
      );
      await tester.tap(find.byKey(const Key('task-create-button')));
      await tester.pumpAndSettle();

      expect(find.text('Ôn tập AI'), findsOneWidget);
      expect(find.textContaining('2026-07-05'), findsOneWidget);
      expect(repository.tasks, hasLength(1));
    });
  });

  group('Class session local slice', () {
    testWidgets('renders schedule detail and creates note', (tester) async {
      final repository = _FakeClassSessionNoteRepository();
      final controller = ClassSessionNoteController(repository: repository);

      await tester.pumpWidget(
        MaterialApp(
          home: ClassSessionDetailScreen(
            schedule: _schedule(),
            noteController: controller,
            analyticsService: _NoopAnalyticsService(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Trí tuệ nhân tạo'), findsOneWidget);
      expect(find.text('A101'), findsOneWidget);

      await tester.enterText(
        find.byKey(const Key('class-note-field')),
        'Ghi chú local',
      );
      await tester.tap(find.byKey(const Key('class-note-create-button')));
      await tester.pumpAndSettle();

      expect(find.text('Ghi chú local'), findsOneWidget);
      expect(repository.notes, hasLength(1));
    });
  });

  group('Home shortcut catalog', () {
    test('uses AI shortcut instead of old chat shortcut', () {
      final keys = kHomeShortcutCatalog.map((item) => item.key).toList();

      expect(keys, contains('ai'));
      expect(keys, isNot(contains('chat')));
      expect(keys, contains('tasks'));
    });
  });
}

class _NoopAnalyticsService extends LocalAnalyticsService {
  @override
  Future<void> recordEvent({
    required String eventName,
    required String featureName,
    String role = 'anonymous',
    Map<String, String> metadata = const {},
  }) async {}
}

class _FakeTaskRepository implements LocalTaskRepository {
  final List<LocalTask> tasks = [];

  @override
  Future<void> deleteTask(String id) async {
    tasks.removeWhere((task) => task.id == id);
  }

  @override
  Future<List<LocalTask>> loadTasks() async {
    return List.of(tasks);
  }

  @override
  Future<List<LocalTask>> loadUpcomingTasks({int limit = 3}) async {
    return tasks
        .where((task) => task.dueAt != null && !task.isCompleted)
        .toList();
  }

  @override
  Future<void> saveTask(LocalTask task) async {
    tasks.removeWhere((item) => item.id == task.id);
    tasks.add(task);
  }
}

class _FakeClassSessionNoteRepository implements ClassSessionNoteRepository {
  final List<ClassSessionNote> notes = [];

  @override
  Future<void> deleteNote(String id) async {
    notes.removeWhere((note) => note.id == id);
  }

  @override
  Future<List<ClassSessionNote>> loadNotes({
    required String sessionKey,
    required String ownerHash,
  }) async {
    return notes
        .where(
          (note) =>
              note.sessionKey == sessionKey && note.ownerHash == ownerHash,
        )
        .toList();
  }

  @override
  Future<String> resolveOwnerHash() async {
    return 'owner-hash';
  }

  @override
  Future<void> saveNote(ClassSessionNote note) async {
    notes.removeWhere((item) => item.id == note.id);
    notes.add(note);
  }
}

ThoiKhoaBieu _schedule() {
  return ThoiKhoaBieu(
    thu: 2,
    tietBatDau: 1,
    soTiet: 3,
    tenMon: 'Trí tuệ nhân tạo',
    giangVien: 'Giảng viên',
    phong: 'A101',
    ngayhoc: '2026-07-03',
  );
}
