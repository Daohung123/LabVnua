import 'dart:convert';

import 'package:aqedu/features/ai_assistant/domain/entities/ai_turn.dart';

class AiIntentClassifier {
  const AiIntentClassifier();

  AiIntent classifyFallback(String prompt) {
    final text = prompt.toLowerCase();
    final target = _targetFromText(text);
    if (target != null) {
      return AiIntent(
        taskKind: AiTaskKind.navigate,
        navigationAction: AiNavigationAction(target: target),
      );
    }

    final contextKeys = <String>[];
    if (_containsAny(text, const ['lịch', 'thời khóa biểu', 'tkb', 'phòng'])) {
      contextKeys.add('schedule');
    }
    if (_containsAny(text, const ['thông báo', 'công văn', 'học vụ'])) {
      contextKeys.add('notifications');
    }
    if (_containsAny(text, const ['điểm', 'gpa', 'kết quả học tập'])) {
      contextKeys.add('scores');
    }
    if (_containsAny(text, const ['học phí', 'khoản thu'])) {
      contextKeys.add('tuition');
    }
    if (_containsAny(text, const ['việc', 'todo', 'deadline', 'hạn nộp'])) {
      contextKeys.add('tasks');
    }
    return AiIntent(
      taskKind: contextKeys.isEmpty ? AiTaskKind.noSqlite : AiTaskKind.sqlite,
      contextKeys: contextKeys,
    );
  }

  AiIntent parseOrFallback(String raw, String prompt) {
    try {
      final decoded = jsonDecode(_extractJson(raw));
      if (decoded is! Map) return classifyFallback(prompt);
      final task = switch (decoded['task']?.toString()) {
        'sqlite' => AiTaskKind.sqlite,
        'navigate' => AiTaskKind.navigate,
        _ => AiTaskKind.noSqlite,
      };
      final target = _targetFromId(decoded['target']?.toString());
      final contextKeys = (decoded['context_keys'] as List? ?? const [])
          .map((value) => value.toString())
          .where(_allowedContextKeys.contains)
          .toList(growable: false);
      if (task == AiTaskKind.navigate && target == null) {
        return classifyFallback(prompt);
      }
      return AiIntent(
        taskKind: task,
        contextKeys: contextKeys,
        navigationAction: target == null
            ? null
            : AiNavigationAction(target: target),
      );
    } catch (_) {
      return classifyFallback(prompt);
    }
  }

  AiNavigationAction? parseAction(Map<dynamic, dynamic>? action) {
    if (action?['type']?.toString() != 'navigate') return null;
    final target = _targetFromId(action?['target']?.toString());
    return target == null ? null : AiNavigationAction(target: target);
  }

  static const _allowedContextKeys = {
    'schedule',
    'notifications',
    'scores',
    'tuition',
    'tasks',
  };

  bool _containsAny(String value, List<String> candidates) =>
      candidates.any(value.contains);

  AiNavigationTarget? _targetFromText(String value) {
    if (_containsAny(value, const ['trang chủ', 'về nhà'])) {
      return AiNavigationTarget.home;
    }
    if (_containsAny(value, const ['học tập', 'môn học'])) {
      return AiNavigationTarget.study;
    }
    if (_containsAny(value, const ['cài đặt', 'thiết lập'])) {
      return AiNavigationTarget.settings;
    }
    if (_containsAny(value, const ['lịch học', 'thời khóa biểu', 'xem lịch'])) {
      return AiNavigationTarget.schedule;
    }
    if (_containsAny(value, const ['xem điểm', 'màn điểm'])) {
      return AiNavigationTarget.scores;
    }
    if (_containsAny(value, const ['xem học phí', 'màn học phí'])) {
      return AiNavigationTarget.tuition;
    }
    if (_containsAny(value, const ['mở thông báo', 'xem thông báo'])) {
      return AiNavigationTarget.notifications;
    }
    if (_containsAny(value, const ['mở todo', 'mở việc'])) {
      return AiNavigationTarget.tasks;
    }
    if (_containsAny(value, const ['đăng ký học', 'đăng ký môn'])) {
      return AiNavigationTarget.courseRegistration;
    }
    if (_containsAny(value, const ['chương trình đào tạo'])) {
      return AiNavigationTarget.programTraining;
    }
    if (_containsAny(value, const ['môn tiên quyết', 'tiên quyết'])) {
      return AiNavigationTarget.prerequisites;
    }
    if (_containsAny(value, const ['quét qr', 'mã qr'])) {
      return AiNavigationTarget.qrScanner;
    }
    return null;
  }

  AiNavigationTarget? _targetFromId(String? value) {
    if (value == null) {
      return null;
    }
    for (final target in AiNavigationTarget.values) {
      if (target.name == value) {
        return target;
      }
    }
    return null;
  }

  String _extractJson(String value) {
    final start = value.indexOf('{');
    final end = value.lastIndexOf('}');
    if (start < 0 || end <= start) throw const FormatException();
    return value.substring(start, end + 1);
  }
}
