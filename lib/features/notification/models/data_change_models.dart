import 'dart:convert';

enum WatchedDataType {
  score,
  schedule,
  examSchedule,
  tuition,
  trainingNotification,
  courseRegister,
}

enum DataChangeType { added, updated, removed }

extension WatchedDataTypeX on WatchedDataType {
  String get value {
    switch (this) {
      case WatchedDataType.score:
        return 'score';
      case WatchedDataType.schedule:
        return 'schedule';
      case WatchedDataType.examSchedule:
        return 'exam_schedule';
      case WatchedDataType.tuition:
        return 'tuition';
      case WatchedDataType.trainingNotification:
        return 'training_notification';
      case WatchedDataType.courseRegister:
        return 'course_register';
    }
  }

  String get cacheTable {
    switch (this) {
      case WatchedDataType.score:
        return 'cached_scores';
      case WatchedDataType.schedule:
        return 'cached_schedule';
      case WatchedDataType.examSchedule:
        return 'cached_exam_schedule';
      case WatchedDataType.tuition:
        return 'cached_tuition';
      case WatchedDataType.trainingNotification:
        return 'cached_training_notifications';
      case WatchedDataType.courseRegister:
        return 'cached_course_register';
    }
  }

  String get label {
    switch (this) {
      case WatchedDataType.score:
        return 'Điểm học tập';
      case WatchedDataType.schedule:
        return 'Lịch học';
      case WatchedDataType.examSchedule:
        return 'Lịch thi';
      case WatchedDataType.tuition:
        return 'Học phí';
      case WatchedDataType.trainingNotification:
        return 'Thông báo đào tạo';
      case WatchedDataType.courseRegister:
        return 'Đăng ký học phần';
    }
  }
}

extension DataChangeTypeX on DataChangeType {
  String get value {
    switch (this) {
      case DataChangeType.added:
        return 'added';
      case DataChangeType.updated:
        return 'updated';
      case DataChangeType.removed:
        return 'removed';
    }
  }
}

WatchedDataType watchedDataTypeFromString(String value) {
  return WatchedDataType.values.firstWhere(
    (item) => item.value == value,
    orElse: () => WatchedDataType.trainingNotification,
  );
}

DataChangeType dataChangeTypeFromString(String value) {
  return DataChangeType.values.firstWhere(
    (item) => item.value == value,
    orElse: () => DataChangeType.updated,
  );
}

class WatchedDataItem {
  final WatchedDataType dataType;
  final String entityId;
  final String title;
  final Map<String, dynamic> payload;
  final String payloadHash;
  final DateTime? sourceUpdatedAt;

  const WatchedDataItem({
    required this.dataType,
    required this.entityId,
    required this.title,
    required this.payload,
    required this.payloadHash,
    this.sourceUpdatedAt,
  });

  String get cacheId => '${dataType.value}:$entityId';

  Map<String, dynamic> toCacheMap(DateTime cachedAt) {
    return {
      'id': cacheId,
      'data_type': dataType.value,
      'entity_id': entityId,
      'title': title,
      'payload': jsonEncode(payload),
      'payload_hash': payloadHash,
      'source_updated_at': sourceUpdatedAt?.toIso8601String(),
      'cached_at': cachedAt.toIso8601String(),
    };
  }

  factory WatchedDataItem.fromCacheMap(
    WatchedDataType dataType,
    Map<String, dynamic> map,
  ) {
    return WatchedDataItem(
      dataType: dataType,
      entityId: map['entity_id'] as String,
      title: map['title'] as String? ?? '',
      payload: jsonDecode(map['payload'] as String) as Map<String, dynamic>,
      payloadHash: map['payload_hash'] as String,
      sourceUpdatedAt: map['source_updated_at'] == null
          ? null
          : DateTime.tryParse(map['source_updated_at'] as String),
    );
  }
}

class DataChange {
  final String id;
  final String changeId;
  final WatchedDataType dataType;
  final DataChangeType changeType;
  final String entityId;
  final String title;
  final String message;
  final String? oldHash;
  final String? newHash;
  final Map<String, dynamic>? oldPayload;
  final Map<String, dynamic>? newPayload;
  final bool isRead;
  final DateTime createdAt;
  final DateTime? notifiedAt;

  const DataChange({
    required this.id,
    required this.changeId,
    required this.dataType,
    required this.changeType,
    required this.entityId,
    required this.title,
    required this.message,
    this.oldHash,
    this.newHash,
    this.oldPayload,
    this.newPayload,
    this.isRead = false,
    required this.createdAt,
    this.notifiedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'change_id': changeId,
      'data_type': dataType.value,
      'change_type': changeType.value,
      'entity_id': entityId,
      'title': title,
      'message': message,
      'old_hash': oldHash,
      'new_hash': newHash,
      'old_payload': oldPayload == null ? null : jsonEncode(oldPayload),
      'new_payload': newPayload == null ? null : jsonEncode(newPayload),
      'is_read': isRead ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'notified_at': notifiedAt?.toIso8601String(),
    };
  }

  factory DataChange.fromMap(Map<String, dynamic> map) {
    return DataChange(
      id: map['id'] as String,
      changeId: map['change_id'] as String,
      dataType: watchedDataTypeFromString(map['data_type'] as String),
      changeType: dataChangeTypeFromString(map['change_type'] as String),
      entityId: map['entity_id'] as String,
      title: map['title'] as String? ?? '',
      message: map['message'] as String? ?? '',
      oldHash: map['old_hash'] as String?,
      newHash: map['new_hash'] as String?,
      oldPayload: map['old_payload'] == null
          ? null
          : jsonDecode(map['old_payload'] as String) as Map<String, dynamic>,
      newPayload: map['new_payload'] == null
          ? null
          : jsonDecode(map['new_payload'] as String) as Map<String, dynamic>,
      isRead: map['is_read'] == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
      notifiedAt: map['notified_at'] == null
          ? null
          : DateTime.tryParse(map['notified_at'] as String),
    );
  }
}
