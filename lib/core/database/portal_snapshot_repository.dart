import 'dart:convert';

import 'package:aqedu/core/database/api_read_snapshot_store.dart';

typedef PortalSnapshotDecoder<T> = T Function(Object json);

class PortalSnapshotRepository<T> {
  PortalSnapshotRepository({
    required this.resourceKey,
    required this.requestBody,
    required PortalSnapshotDecoder<T> decoder,
    ApiReadSnapshotStore? snapshotStore,
  }) : _decoder = decoder,
       _snapshotStore = snapshotStore ?? ApiReadSnapshotStore();

  final String resourceKey;
  final Object? requestBody;
  final PortalSnapshotDecoder<T> _decoder;
  final ApiReadSnapshotStore _snapshotStore;

  Future<T?> load() async {
    final snapshot = await _snapshotStore.readSnapshot(
      resourceKey: resourceKey,
      requestBody: requestBody,
    );
    if (snapshot == null) return null;
    try {
      return _decoder(jsonDecode(snapshot.payloadJson));
    } on FormatException {
      return null;
    } on TypeError {
      return null;
    }
  }
}
