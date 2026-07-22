import 'dart:convert';

import 'package:aqedu/core/database/app_database.dart';

/// Read-only, typed projections that may be used as AI context.
///
/// Table names and selected columns are fixed here.  Callers can only choose
/// one of the methods below; no model output is ever used to construct SQL.
abstract interface class AiContextSqliteReader {
  Future<List<AiScoreContextItem>> readScores({int limit = 40});

  Future<List<AiTuitionContextItem>> readTuition();

  Future<List<AiTaskContextItem>> readTasks({int limit = 20});
}

class SqliteAiContextReader implements AiContextSqliteReader {
  SqliteAiContextReader({AppDatabase? database})
    : _database = database ?? AppDatabase();

  final AppDatabase _database;

  @override
  Future<List<AiScoreContextItem>> readScores({int limit = 40}) async {
    final database = await _database.instance;
    final rows = await database.query(
      'cached_scores',
      columns: const ['payload', 'source_updated_at', 'cached_at'],
      orderBy: 'cached_at DESC',
      limit: _positiveLimit(limit),
    );
    return _mapRows(rows, AiScoreContextItem.tryFromCacheRow);
  }

  @override
  Future<List<AiTuitionContextItem>> readTuition() async {
    final database = await _database.instance;
    final rows = await database.query(
      'cached_tuition',
      columns: const ['payload', 'source_updated_at', 'cached_at'],
      orderBy: 'cached_at DESC',
    );
    return _mapRows(rows, AiTuitionContextItem.tryFromCacheRow);
  }

  @override
  Future<List<AiTaskContextItem>> readTasks({int limit = 20}) async {
    final database = await _database.instance;
    final rows = await database.query(
      'tasks',
      columns: const ['title', 'description', 'due_at', 'status', 'updated_at'],
      orderBy: 'status ASC, due_at IS NULL, due_at ASC, updated_at DESC',
      limit: _positiveLimit(limit),
    );
    return _mapRows(rows, AiTaskContextItem.tryFromRow);
  }

  int _positiveLimit(int value) => value < 1 ? 1 : value;

  List<T> _mapRows<T>(
    List<Map<String, Object?>> rows,
    T? Function(Map<String, Object?> row) mapper,
  ) {
    final items = <T>[];
    for (final row in rows) {
      final item = mapper(row);
      if (item != null) items.add(item);
    }
    return items;
  }
}

class AiScoreContextItem {
  const AiScoreContextItem({
    required this.semester,
    required this.semesterName,
    required this.subjectCode,
    required this.subjectName,
    required this.credits,
    required this.examScore,
    required this.midtermScore,
    required this.totalScore,
    required this.totalNumericScore,
    required this.totalLetterScore,
    required this.result,
    required this.components,
    this.sourceUpdatedAt,
    this.cachedAt,
  });

  final String semester;
  final String semesterName;
  final String subjectCode;
  final String subjectName;
  final String credits;
  final String examScore;
  final String midtermScore;
  final String totalScore;
  final String totalNumericScore;
  final String totalLetterScore;
  final String result;
  final List<AiScoreComponentContextItem> components;
  final DateTime? sourceUpdatedAt;
  final DateTime? cachedAt;

  static AiScoreContextItem? tryFromCacheRow(Map<String, Object?> row) {
    final payload = _payloadFrom(row['payload']);
    if (payload == null) return null;
    final subjectName = _value(payload, 'ten_mon');
    final subjectCode = _value(payload, 'ma_mon');
    if (subjectName.isEmpty && subjectCode.isEmpty) return null;

    final components = <AiScoreComponentContextItem>[];
    final rawComponents = payload['ds_diem_thanh_phan'];
    if (rawComponents is List) {
      for (final raw in rawComponents.take(8)) {
        if (raw is! Map) continue;
        final component = AiScoreComponentContextItem(
          symbol: _value(raw, 'ky_hieu'),
          name: _value(raw, 'ten_thanh_phan'),
          weight: _value(raw, 'trong_so'),
          score: _value(raw, 'diem_thanh_phan'),
        );
        if (component.hasValue) components.add(component);
      }
    }

    return AiScoreContextItem(
      semester: _value(payload, 'hoc_ky'),
      semesterName: _value(payload, 'ten_hoc_ky'),
      subjectCode: subjectCode,
      subjectName: subjectName,
      credits: _value(payload, 'so_tin_chi'),
      examScore: _value(payload, 'diem_thi'),
      midtermScore: _value(payload, 'diem_giua_ky'),
      totalScore: _value(payload, 'diem_tk'),
      totalNumericScore: _value(payload, 'diem_tk_so'),
      totalLetterScore: _value(payload, 'diem_tk_chu'),
      result: _value(payload, 'ket_qua'),
      components: components,
      sourceUpdatedAt: _date(row['source_updated_at']),
      cachedAt: _date(row['cached_at']),
    );
  }
}

class AiScoreComponentContextItem {
  const AiScoreComponentContextItem({
    required this.symbol,
    required this.name,
    required this.weight,
    required this.score,
  });

  final String symbol;
  final String name;
  final String weight;
  final String score;

  bool get hasValue =>
      symbol.isNotEmpty ||
      name.isNotEmpty ||
      weight.isNotEmpty ||
      score.isNotEmpty;
}

class AiTuitionContextItem {
  const AiTuitionContextItem({
    required this.semesterCode,
    required this.programGroup,
    required this.semesterName,
    required this.tuition,
    required this.waiver,
    required this.support,
    required this.amountDue,
    required this.scholarship,
    required this.amountPaid,
    required this.balance,
    required this.unitPrice,
    required this.note,
    this.sourceUpdatedAt,
    this.cachedAt,
  });

  final String semesterCode;
  final String programGroup;
  final String semesterName;
  final String tuition;
  final String waiver;
  final String support;
  final String amountDue;
  final String scholarship;
  final String amountPaid;
  final String balance;
  final String unitPrice;
  final String note;
  final DateTime? sourceUpdatedAt;
  final DateTime? cachedAt;

  static AiTuitionContextItem? tryFromCacheRow(Map<String, Object?> row) {
    final payload = _payloadFrom(row['payload']);
    if (payload == null) return null;
    final semesterCode = _value(payload, 'nhhk');
    final semesterName = _value(payload, 'ten_hoc_ky');
    if (semesterCode.isEmpty && semesterName.isEmpty) return null;
    return AiTuitionContextItem(
      semesterCode: semesterCode,
      programGroup: _value(payload, 'ten_nhom_ct'),
      semesterName: semesterName,
      tuition: _value(payload, 'hoc_phi'),
      waiver: _value(payload, 'mien_giam'),
      support: _value(payload, 'duoc_ho_tro'),
      amountDue: _value(payload, 'phai_thu'),
      scholarship: _value(payload, 'tong_hoc_bong'),
      amountPaid: _value(payload, 'da_thu'),
      balance: _value(payload, 'con_no'),
      unitPrice: _value(payload, 'don_gia'),
      note: _value(payload, 'ghi_chu'),
      sourceUpdatedAt: _date(row['source_updated_at']),
      cachedAt: _date(row['cached_at']),
    );
  }
}

class AiTaskContextItem {
  const AiTaskContextItem({
    required this.title,
    required this.description,
    required this.status,
    this.dueAt,
    this.updatedAt,
  });

  final String title;
  final String description;
  final String status;
  final DateTime? dueAt;
  final DateTime? updatedAt;

  static AiTaskContextItem? tryFromRow(Map<String, Object?> row) {
    final title = _value(row, 'title');
    if (title.isEmpty) return null;
    return AiTaskContextItem(
      title: title,
      description: _value(row, 'description'),
      status: _value(row, 'status'),
      dueAt: _date(row['due_at']),
      updatedAt: _date(row['updated_at']),
    );
  }
}

Map<String, dynamic>? _payloadFrom(Object? value) {
  try {
    final decoded = value is String ? jsonDecode(value) : value;
    if (decoded is! Map) return null;
    return decoded.map((key, item) => MapEntry(key.toString(), item));
  } catch (_) {
    return null;
  }
}

String _value(Map<dynamic, dynamic> values, String key) =>
    values[key]?.toString().trim() ?? '';

DateTime? _date(Object? value) =>
    value == null ? null : DateTime.tryParse(value.toString());
