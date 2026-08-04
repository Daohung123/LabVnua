import 'dart:async';

import 'package:aqedu/core/database/api_read_resource_registry.dart';
import 'package:aqedu/core/database/api_read_snapshot_store.dart';
import 'package:aqedu/core/database/portal_local_read_store.dart';
import 'package:aqedu/core/database/portal_read_sync_coordinator.dart';
import 'package:aqedu/core/database/portal_snapshot_repository.dart';
import 'package:aqedu/core/database/portal_sync_state_store.dart';
import 'package:aqedu/core/constants/api/api_daotao.dart';
import 'package:aqedu/core/models/sqlite/session.dart';
import 'package:aqedu/core/services_root/api_daotao/daotao_read_payloads.dart';
import 'package:aqedu/core/services_root/api_daotao/notification/data_polling_service.dart';
import 'package:aqedu/core/services_root/sqlite/sessions/core_service_session.dart';
import 'package:aqedu/features/notification/models/data_change_models.dart';
import 'package:aqedu/features/notification/services/background_sync_service.dart';
import 'package:aqedu/features/notification/services/notification_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workmanager/workmanager.dart';

void main() {
  group('PortalReadSyncCoordinator', () {
    test(
      'marks the manifest complete only after every resource is local',
      () async {
        final state = _FakePortalSyncStateStore();
        final coordinator = PortalReadSyncCoordinator(
          sessionService: _FakeSessionService(_session()),
          stateStore: state,
          resources: [_resource('scores'), _resource('tuition')],
        );

        final result = await coordinator.syncFull();

        expect(result.isComplete, isTrue);
        expect(result.successfulResources, ['scores', 'tuition']);
        expect(
          state.state.isCompleteFor(PortalReadSyncCoordinator.manifestVersion),
          isTrue,
        );
        expect(state.resourceStatus, {'scores': true, 'tuition': true});
      },
    );

    test(
      'keeps the prior complete snapshot state when a refresh fails',
      () async {
        final state = _FakePortalSyncStateStore(
          state: PortalSyncState(
            manifestVersion: PortalReadSyncCoordinator.manifestVersion,
            lastCompletedAt: DateTime(2026, 7, 23),
          ),
        );
        final coordinator = PortalReadSyncCoordinator(
          sessionService: _FakeSessionService(_session()),
          stateStore: state,
          resources: [
            _resource('scores'),
            _resource('tuition', response: null),
          ],
        );

        final result = await coordinator.syncFull();

        expect(result.isComplete, isFalse);
        expect(result.failedResources, ['tuition']);
        expect(state.state.lastCompletedAt, DateTime(2026, 7, 23));
        expect(state.state.lastFailedResource, 'tuition');
        expect(
          state.state.isCompleteFor(PortalReadSyncCoordinator.manifestVersion),
          isTrue,
        );
        expect(state.resourceStatus['scores'], isTrue);
        expect(state.resourceStatus['tuition'], isFalse);
      },
    );

    test(
      'does not report a missing secure session as a complete sync',
      () async {
        final coordinator = PortalReadSyncCoordinator(
          sessionService: _FakeSessionService(null),
          stateStore: _FakePortalSyncStateStore(),
          resources: [_resource('scores')],
        );

        final result = await coordinator.syncFull();

        expect(result.isComplete, isFalse);
        expect(result.failedResources, ['session']);
      },
    );
  });

  group('Portal snapshots', () {
    test('course registration action stays an online-only mutation', () {
      expect(
        ApiReadResourceRegistry.semanticsFor(APICOURSEREGISTERACTION),
        ApiRequestSemantics.mutation,
      );
    });

    test(
      'decodes only the owner-scoped snapshot returned by the store',
      () async {
        final repository = PortalSnapshotRepository<String>(
          resourceKey: 'scores',
          requestBody: const {},
          snapshotStore: _FakeSnapshotStore(
            ApiReadSnapshot(
              resourceKey: 'scores',
              requestHash: 'request',
              payloadJson: '{"value":"local"}',
              payloadHash: 'payload',
              fetchedAt: DateTime(2026, 7, 23),
            ),
          ),
          decoder: (json) => (json as Map<String, dynamic>)['value']! as String,
        );

        expect(await repository.load(), 'local');
      },
    );

    test('keeps prerequisite snapshots distinct by request type', () {
      expect(
        ApiReadResourceRegistry.resourceKeyFor(
          '/rms/w-locdsmontienquyet',
          requestBody: {'loai_tien_quyet': 1},
        ),
        'prerequisite_subjects:1',
      );
      expect(
        ApiReadResourceRegistry.resourceKeyFor(
          '/rms/w-locdsmontienquyet',
          requestBody: {'loai_tien_quyet': 2},
        ),
        'prerequisite_subjects:2',
      );
    });

    test('hashes portal read request bodies that contain nested nulls', () {
      final requests = [
        daotaoSchedulePayload(),
        PortalLocalReadStore.notificationRequest(),
        PortalLocalReadStore.trainingProgramRequest(),
        PortalLocalReadStore.prerequisiteRequest(1),
        PortalLocalReadStore.prerequisiteRequest(2),
      ];

      for (final request in requests) {
        expect(ApiReadSnapshotStore.requestHashFor(request), hasLength(64));
      }

      expect(
        ApiReadSnapshotStore.requestHashFor({
          'b': null,
          'a': [
            {'z': null, 'y': 1},
          ],
        }),
        ApiReadSnapshotStore.requestHashFor({
          'a': [
            {'y': 1, 'z': null},
          ],
          'b': null,
        }),
      );
    });

    test('parses a feature response from SQLite without an API call', () async {
      final store = PortalLocalReadStore(
        snapshotStore: _FakeSnapshotStore(
          ApiReadSnapshot(
            resourceKey: ApiReadResourceRegistry.scores,
            requestHash: 'request',
            payloadJson: '{"data":{"ds_diem_hocky":[]}}',
            payloadHash: 'payload',
            fetchedAt: DateTime(2026, 7, 23),
          ),
        ),
      );

      final scores = await store.scores();

      expect(scores, isNotNull);
      expect(scores!.data!.dsDiemHocky, isEmpty);
    });
  });

  group('Background full-sync scheduling', () {
    test('declares one-hour unmetered periodic work', () {
      expect(
        BackgroundSyncService.periodicSyncInterval,
        const Duration(hours: 1),
      );
      expect(BackgroundSyncService.periodicNetworkType, NetworkType.unmetered);
    });

    test('skips a foreground refresh without Wi-Fi', () async {
      final coordinator = _FakeBackgroundCoordinator();
      final service = _backgroundService(
        coordinator: coordinator,
        connectivity: () async => [ConnectivityResult.mobile],
      );

      final result = await service.checkNow();

      expect(result.success, isTrue);
      expect(coordinator.syncCalls, 0);
    });

    test('runs due foreground work once and prevents overlap', () async {
      final pending = Completer<PortalSyncResult>();
      final started = Completer<void>();
      final coordinator = _FakeBackgroundCoordinator(
        pending: pending,
        started: started,
      );
      final service = _backgroundService(
        coordinator: coordinator,
        connectivity: () async => [ConnectivityResult.wifi],
      );

      final first = service.syncIfDue();
      await started.future;
      final overlapping = await service.checkNow();

      expect(overlapping.success, isTrue);
      expect(coordinator.syncCalls, 1);

      pending.complete(_completeSyncResult());
      expect((await first).success, isTrue);
    });
  });
}

PortalReadSyncResource _resource(String key, {Object? response = 'response'}) {
  return PortalReadSyncResource(
    key: key,
    fetch: (_) async => response,
    validateAndProject: () async => true,
  );
}

SessionModel _session() => SessionModel(
  user: 'test-user',
  pass: 'test-password',
  cookie: 'test-cookie',
  token: 'test-token',
);

class _FakeSessionService extends SqliteServices {
  _FakeSessionService(this.session);

  final SessionModel? session;

  @override
  Future<SessionModel?> getSession() async => session;
}

class _FakePortalSyncStateStore extends PortalSyncStateStore {
  _FakePortalSyncStateStore({PortalSyncState? state})
    : state = state ?? const PortalSyncState(manifestVersion: 0);

  PortalSyncState state;
  final Map<String, bool> resourceStatus = {};

  @override
  Future<PortalSyncState> read() async => state;

  @override
  Future<void> markAttempt() async {
    state = PortalSyncState(
      manifestVersion: state.manifestVersion,
      lastAttemptedAt: DateTime(2026, 7, 23, 1),
      lastCompletedAt: state.lastCompletedAt,
      lastFailedResource: state.lastFailedResource,
    );
  }

  @override
  Future<void> markResourceResult({
    required String resourceKey,
    required bool success,
  }) async {
    resourceStatus[resourceKey] = success;
  }

  @override
  Future<void> markComplete({required int manifestVersion}) async {
    state = PortalSyncState(
      manifestVersion: manifestVersion,
      lastAttemptedAt: state.lastAttemptedAt,
      lastCompletedAt: DateTime(2026, 7, 23, 2),
    );
  }

  @override
  Future<void> markIncomplete({
    required int manifestVersion,
    required String failedResource,
  }) async {
    state = PortalSyncState(
      manifestVersion: manifestVersion,
      lastAttemptedAt: state.lastAttemptedAt,
      lastCompletedAt: state.lastCompletedAt,
      lastFailedResource: failedResource,
    );
  }
}

class _FakeSnapshotStore extends ApiReadSnapshotStore {
  _FakeSnapshotStore(this.snapshot);

  final ApiReadSnapshot snapshot;

  @override
  Future<ApiReadSnapshot?> readSnapshot({
    required String resourceKey,
    Object? requestBody,
  }) async => snapshot;
}

BackgroundSyncService _backgroundService({
  required _FakeBackgroundCoordinator coordinator,
  required ConnectivityCheck connectivity,
}) {
  return BackgroundSyncService(
    portalSyncCoordinator: coordinator,
    pollingService: _FakePollingService(),
    notificationService: _FakeNotificationService(),
    connectivityCheck: connectivity,
  );
}

PortalSyncResult _completeSyncResult() => const PortalSyncResult(
  total: 0,
  successfulResources: [],
  failedResources: [],
  isFullSync: true,
);

class _FakeBackgroundCoordinator extends PortalReadSyncCoordinator {
  _FakeBackgroundCoordinator({this.pending, this.started})
    : super(resources: const <PortalReadSyncResource>[]);

  final Completer<PortalSyncResult>? pending;
  final Completer<void>? started;
  int syncCalls = 0;

  @override
  Future<bool> isDue({Duration interval = const Duration(hours: 1)}) async =>
      true;

  @override
  Future<PortalSyncResult> syncFull({
    void Function(PortalSyncProgress progress)? onProgress,
  }) {
    syncCalls++;
    if (started != null && !started!.isCompleted) {
      started!.complete();
    }
    return pending?.future ?? Future.value(_completeSyncResult());
  }
}

class _FakePollingService extends DataPollingService {
  @override
  Future<Map<WatchedDataType, List<WatchedDataItem>>> fetchAll() async =>
      const {};
}

class _FakeNotificationService extends NotificationService {
  @override
  Future<void> init({
    void Function(String? payload)? onNotificationTap,
  }) async {}
}
