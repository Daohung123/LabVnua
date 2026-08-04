import 'package:aqedu/core/database/portal_read_sync_coordinator.dart';

class SyncDataResult {
  const SyncDataResult({
    required this.total,
    required this.success,
    required this.failed,
    required this.errors,
  });

  final int total;
  final int success;
  final int failed;
  final List<String> errors;

  bool get hasFailures => failed > 0;
}

Future<SyncDataResult> syncData() async {
  final result = await PortalReadSyncCoordinator().syncFull();
  return SyncDataResult(
    total: result.total,
    success: result.success,
    failed: result.failed,
    errors: result.failedResources,
  );
}
