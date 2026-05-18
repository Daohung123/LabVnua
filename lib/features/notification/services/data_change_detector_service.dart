import 'dart:convert';

import 'package:aqedu/features/notification/models/data_change_models.dart';
import 'package:crypto/crypto.dart';

class DataChangeDetectorService {
  List<DataChange> compare({
    required WatchedDataType dataType,
    required List<WatchedDataItem> oldItems,
    required List<WatchedDataItem> newItems,
  }) {
    final oldById = {for (final item in oldItems) item.entityId: item};
    final newById = {for (final item in newItems) item.entityId: item};
    final now = DateTime.now();
    final changes = <DataChange>[];

    for (final entry in newById.entries) {
      final oldItem = oldById[entry.key];
      final newItem = entry.value;

      if (oldItem == null) {
        changes.add(
          _buildChange(
            dataType: dataType,
            changeType: DataChangeType.added,
            newItem: newItem,
            createdAt: now,
          ),
        );
      } else if (oldItem.payloadHash != newItem.payloadHash) {
        changes.add(
          _buildChange(
            dataType: dataType,
            changeType: DataChangeType.updated,
            oldItem: oldItem,
            newItem: newItem,
            createdAt: now,
          ),
        );
      }
    }

    for (final entry in oldById.entries) {
      if (!newById.containsKey(entry.key)) {
        changes.add(
          _buildChange(
            dataType: dataType,
            changeType: DataChangeType.removed,
            oldItem: entry.value,
            createdAt: now,
          ),
        );
      }
    }

    return changes;
  }

  WatchedDataItem buildItem({
    required WatchedDataType dataType,
    required String entityId,
    required String title,
    required Map<String, dynamic> payload,
    DateTime? sourceUpdatedAt,
  }) {
    final normalizedPayload = normalize(payload);

    return WatchedDataItem(
      dataType: dataType,
      entityId: entityId,
      title: title,
      payload: normalizedPayload,
      payloadHash: hashPayload(normalizedPayload),
      sourceUpdatedAt: sourceUpdatedAt,
    );
  }

  Map<String, dynamic> normalize(Map<String, dynamic> payload) {
    return _sortValue(payload) as Map<String, dynamic>;
  }

  String hashPayload(Map<String, dynamic> payload) {
    final encoded = jsonEncode(_sortValue(payload));
    return sha256.convert(utf8.encode(encoded)).toString();
  }

  DataChange _buildChange({
    required WatchedDataType dataType,
    required DataChangeType changeType,
    WatchedDataItem? oldItem,
    WatchedDataItem? newItem,
    required DateTime createdAt,
  }) {
    final entityId = newItem?.entityId ?? oldItem!.entityId;
    final oldHash = oldItem?.payloadHash;
    final newHash = newItem?.payloadHash;
    final changeId = _buildChangeId(
      dataType: dataType,
      changeType: changeType,
      entityId: entityId,
      oldHash: oldHash,
      newHash: newHash,
    );

    return DataChange(
      id: changeId,
      changeId: changeId,
      dataType: dataType,
      changeType: changeType,
      entityId: entityId,
      title: newItem?.title ?? oldItem?.title ?? dataType.label,
      message: buildMessage(dataType, changeType, oldItem, newItem),
      oldHash: oldHash,
      newHash: newHash,
      oldPayload: oldItem?.payload,
      newPayload: newItem?.payload,
      createdAt: createdAt,
    );
  }

  String buildMessage(
    WatchedDataType dataType,
    DataChangeType changeType,
    WatchedDataItem? oldItem,
    WatchedDataItem? newItem,
  ) {
    final title = newItem?.title ?? oldItem?.title ?? dataType.label;

    switch (dataType) {
      case WatchedDataType.score:
        if (changeType == DataChangeType.added)
          return 'Xuất hiện điểm mới môn $title';
        if (changeType == DataChangeType.removed)
          return 'Điểm môn $title đã bị gỡ khỏi hệ thống';
        return 'Điểm môn $title đã được cập nhật';
      case WatchedDataType.schedule:
        final field = _firstChangedField(oldItem, newItem, {
          'ma_phong': 'phòng',
          'ngay_hoc': 'ngày học',
          'tiet_bat_dau': 'tiết bắt đầu',
          'ten_giang_vien': 'giảng viên',
        });
        if (changeType == DataChangeType.added)
          return 'Xuất hiện lịch học mới môn $title';
        if (changeType == DataChangeType.removed)
          return 'Lịch học môn $title đã bị hủy';
        return 'Lịch học môn $title đã thay đổi${field == null ? '' : ' $field'}';
      case WatchedDataType.examSchedule:
        if (changeType == DataChangeType.added)
          return 'Xuất hiện lịch thi mới môn $title';
        if (changeType == DataChangeType.removed)
          return 'Lịch thi môn $title đã bị hủy';
        return 'Lịch thi môn $title đã thay đổi';
      case WatchedDataType.tuition:
        return 'Học phí $title đã cập nhật';
      case WatchedDataType.trainingNotification:
        if (changeType == DataChangeType.added)
          return 'Có thông báo đào tạo mới: $title';
        if (changeType == DataChangeType.removed)
          return 'Thông báo đào tạo "$title" đã bị gỡ';
        return 'Thông báo đào tạo "$title" đã được cập nhật';
      case WatchedDataType.courseRegister:
        if (changeType == DataChangeType.added)
          return 'Xuất hiện lớp học phần mới: $title';
        if (changeType == DataChangeType.removed)
          return 'Lớp học phần $title đã bị gỡ';
        return 'Đăng ký học phần $title đã cập nhật';
    }
  }

  String _buildChangeId({
    required WatchedDataType dataType,
    required DataChangeType changeType,
    required String entityId,
    String? oldHash,
    String? newHash,
  }) {
    final raw =
        '${dataType.value}|${changeType.value}|$entityId|$oldHash|$newHash';
    return sha256.convert(utf8.encode(raw)).toString();
  }

  String? _firstChangedField(
    WatchedDataItem? oldItem,
    WatchedDataItem? newItem,
    Map<String, String> fieldLabels,
  ) {
    if (oldItem == null || newItem == null) return null;

    for (final entry in fieldLabels.entries) {
      if (oldItem.payload[entry.key] != newItem.payload[entry.key]) {
        return entry.value;
      }
    }

    return null;
  }

  Object? _sortValue(Object? value) {
    if (value is Map) {
      final sorted = <String, dynamic>{};
      final keys = value.keys.map((e) => e.toString()).toList()..sort();
      for (final key in keys) {
        sorted[key] = _sortValue(value[key]);
      }
      return sorted;
    }

    if (value is List) {
      return value.map(_sortValue).toList();
    }

    return value;
  }
}
