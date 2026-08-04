import 'package:aqedu/core/database/api_read_resource_registry.dart';
import 'package:aqedu/core/database/portal_local_read_store.dart';
import 'package:aqedu/core/database/portal_sync_state_store.dart';
import 'package:aqedu/core/models/sqlite/session.dart';
import 'package:aqedu/core/services_root/api_daotao/course_Register/get_course_register_fillter.dart';
import 'package:aqedu/core/services_root/api_daotao/course_Register/get_course_register_respone.dart';
import 'package:aqedu/core/services_root/api_daotao/course_Register/get_course_register_result_response.dart';
import 'package:aqedu/core/services_root/api_daotao/information_Student/get_information.dart';
import 'package:aqedu/core/services_root/api_daotao/notification/get_notification.dart';
import 'package:aqedu/core/services_root/api_daotao/prerequisite_Subjects/get_prerequisite_respone.dart';
import 'package:aqedu/core/services_root/api_daotao/schedure/get_tkb_response.dart';
import 'package:aqedu/core/services_root/api_daotao/score/get_score_response.dart';
import 'package:aqedu/core/services_root/api_daotao/trainning_Program/get_training_program_respone.dart';
import 'package:aqedu/core/services_root/api_daotao/tuition/get_tuition.dart';
import 'package:aqedu/core/services_root/sqlite/infomationStudent/information_sqlite.dart';
import 'package:aqedu/core/services_root/sqlite/notification/notification_sqlite.dart';
import 'package:aqedu/core/services_root/sqlite/schedure/schedure_sqlite.dart';
import 'package:aqedu/core/services_root/sqlite/sessions/core_service_session.dart';
import 'package:aqedu/features/notification/models/notification_student.dart';

class PortalSyncProgress {
  const PortalSyncProgress({
    required this.resourceKey,
    required this.completed,
    required this.total,
  });

  final String resourceKey;
  final int completed;
  final int total;
}

class PortalSyncResult {
  const PortalSyncResult({
    required this.total,
    required this.successfulResources,
    required this.failedResources,
    required this.isFullSync,
  });

  final int total;
  final List<String> successfulResources;
  final List<String> failedResources;
  final bool isFullSync;

  int get success => successfulResources.length;
  int get failed => failedResources.length;
  bool get isComplete => failedResources.isEmpty && success == total;
}

typedef PortalReadFetcher = Future<Object?> Function(SessionModel session);
typedef PortalLocalValidator = Future<bool> Function();

class PortalReadSyncResource {
  const PortalReadSyncResource({
    required this.key,
    required this.fetch,
    required this.validateAndProject,
  });

  final String key;
  final PortalReadFetcher fetch;
  final PortalLocalValidator validateAndProject;
}

class PortalReadSyncCoordinator {
  PortalReadSyncCoordinator({
    SqliteServices? sessionService,
    PortalSyncStateStore? stateStore,
    List<PortalReadSyncResource>? resources,
  }) : _sessionService = sessionService ?? SqliteServices(),
       _stateStore = stateStore ?? PortalSyncStateStore(),
       _resources = resources ?? _studentResources();

  static const manifestVersion = 1;
  static Future<PortalSyncResult>? _inFlight;

  final SqliteServices _sessionService;
  final PortalSyncStateStore _stateStore;
  final List<PortalReadSyncResource> _resources;

  Future<bool> hasCompletedInitialSync() async {
    final state = await _stateStore.read();
    return state.isCompleteFor(manifestVersion);
  }

  Future<bool> isDue({Duration interval = const Duration(hours: 1)}) async {
    final state = await _stateStore.read();
    final completedAt = state.lastCompletedAt;
    if (!state.isCompleteFor(manifestVersion) || completedAt == null) {
      return true;
    }
    return DateTime.now().difference(completedAt) >= interval;
  }

  Future<PortalSyncResult> syncFull({
    void Function(PortalSyncProgress progress)? onProgress,
  }) {
    return _runOnce(
      resources: _resources,
      markFullSyncState: true,
      onProgress: onProgress,
    );
  }

  Future<PortalSyncResult> refreshCourseRegistration() {
    final resources = _resources
        .where(
          (resource) =>
              resource.key == ApiReadResourceRegistry.courseRegisterFilters ||
              resource.key == ApiReadResourceRegistry.courseRegisterCatalog ||
              resource.key == ApiReadResourceRegistry.courseRegisterResult,
        )
        .toList();
    return _runOnce(resources: resources, markFullSyncState: false);
  }

  Future<PortalSyncResult> _runOnce({
    required List<PortalReadSyncResource> resources,
    required bool markFullSyncState,
    void Function(PortalSyncProgress progress)? onProgress,
  }) {
    final active = _inFlight;
    if (active != null) return active;

    final future = _sync(
      resources: resources,
      markFullSyncState: markFullSyncState,
      onProgress: onProgress,
    );
    _inFlight = future;
    return future.whenComplete(() {
      if (identical(_inFlight, future)) {
        _inFlight = null;
      }
    });
  }

  Future<PortalSyncResult> _sync({
    required List<PortalReadSyncResource> resources,
    required bool markFullSyncState,
    void Function(PortalSyncProgress progress)? onProgress,
  }) async {
    final session = await _sessionService.getSession();
    if (session == null || session.cookie.isEmpty || session.token.isEmpty) {
      return PortalSyncResult(
        total: resources.length,
        successfulResources: const [],
        failedResources: const ['session'],
        isFullSync: markFullSyncState,
      );
    }

    await _stateStore.markAttempt();
    final successful = <String>[];
    final failed = <String>[];

    for (var index = 0; index < resources.length; index++) {
      final resource = resources[index];
      try {
        final response = await resource.fetch(session);
        if (response == null || !(await resource.validateAndProject())) {
          throw StateError('portal read did not create a valid local snapshot');
        }
        successful.add(resource.key);
        await _stateStore.markResourceResult(
          resourceKey: resource.key,
          success: true,
        );
      } catch (_) {
        failed.add(resource.key);
        await _stateStore.markResourceResult(
          resourceKey: resource.key,
          success: false,
        );
      }
      onProgress?.call(
        PortalSyncProgress(
          resourceKey: resource.key,
          completed: index + 1,
          total: resources.length,
        ),
      );
    }

    if (markFullSyncState) {
      if (failed.isEmpty) {
        await _stateStore.markComplete(manifestVersion: manifestVersion);
      } else {
        await _stateStore.markIncomplete(
          manifestVersion: manifestVersion,
          failedResource: failed.first,
        );
      }
    }

    return PortalSyncResult(
      total: resources.length,
      successfulResources: successful,
      failedResources: failed,
      isFullSync: markFullSyncState,
    );
  }

  static List<PortalReadSyncResource> _studentResources() {
    final local = PortalLocalReadStore();
    return [
      PortalReadSyncResource(
        key: ApiReadResourceRegistry.schedule,
        fetch: (session) =>
            core_services_get_TkbResponse(session.cookie, session.token),
        validateAndProject: () async {
          final response = await local.schedule();
          if (response == null) return false;
          await ServiceSqlTkb().syncFromApi(response);
          return true;
        },
      ),
      PortalReadSyncResource(
        key: ApiReadResourceRegistry.scores,
        fetch: (session) => getScoreResponse(session.cookie, session.token),
        validateAndProject: () async => await local.scores() != null,
      ),
      PortalReadSyncResource(
        key: ApiReadResourceRegistry.notifications,
        fetch: (session) =>
            getNotificationResponse(session.cookie, session.token),
        validateAndProject: () async {
          final response = await local.notifications();
          if (response == null) return false;
          await ServiceSqlNotificationStudentRoot().insertListNotification(
            response.data?.dsThongBao ?? <NotificationItem>[],
          );
          return true;
        },
      ),
      PortalReadSyncResource(
        key: ApiReadResourceRegistry.studentProfile,
        fetch: (session) =>
            getInformationResponse(session.cookie, session.token),
        validateAndProject: () async {
          final response = await local.studentProfile();
          final data = response?.data;
          if (data == null) return false;
          await ServiceSqlInformationStudentRoot().insertStudent(data);
          return true;
        },
      ),
      PortalReadSyncResource(
        key: ApiReadResourceRegistry.tuition,
        fetch: (session) => getHocPhiResponse(session.cookie, session.token),
        validateAndProject: () async => await local.tuition() != null,
      ),
      PortalReadSyncResource(
        key: ApiReadResourceRegistry.trainingProgram,
        fetch: (session) =>
            getProgramTrainingResponse(session.cookie, session.token),
        validateAndProject: () async => await local.trainingProgram() != null,
      ),
      PortalReadSyncResource(
        key: '${ApiReadResourceRegistry.prerequisiteSubjects}:1',
        fetch: (session) => getPrerequisiteResponse(
          session.cookie,
          session.token,
          loaiTienQuyet: 1,
        ),
        validateAndProject: () async =>
            await local.prerequisiteSubjects(1) != null,
      ),
      PortalReadSyncResource(
        key: '${ApiReadResourceRegistry.prerequisiteSubjects}:2',
        fetch: (session) => getPrerequisiteResponse(
          session.cookie,
          session.token,
          loaiTienQuyet: 2,
        ),
        validateAndProject: () async =>
            await local.prerequisiteSubjects(2) != null,
      ),
      PortalReadSyncResource(
        key: ApiReadResourceRegistry.courseRegisterFilters,
        fetch: (session) =>
            getCourseRegisterFilterResponse(session.cookie, session.token),
        validateAndProject: () async =>
            await local.courseRegisterFilters() != null,
      ),
      PortalReadSyncResource(
        key: ApiReadResourceRegistry.courseRegisterCatalog,
        fetch: (session) =>
            getCourseRegisterResponse(session.cookie, session.token),
        validateAndProject: () async =>
            await local.courseRegisterCatalog() != null,
      ),
      PortalReadSyncResource(
        key: ApiReadResourceRegistry.courseRegisterResult,
        fetch: (session) =>
            getCourseRegisterResultResponse(session.cookie, session.token),
        validateAndProject: () async =>
            await local.courseRegisterResult() != null,
      ),
    ];
  }
}
