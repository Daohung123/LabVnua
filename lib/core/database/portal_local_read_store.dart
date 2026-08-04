import 'package:aqedu/core/database/api_read_resource_registry.dart';
import 'package:aqedu/core/database/api_read_snapshot_store.dart';
import 'package:aqedu/core/database/portal_snapshot_repository.dart';
import 'package:aqedu/core/services_root/api_daotao/daotao_read_payloads.dart';
import 'package:aqedu/features/course_register/models/model_course_register.dart';
import 'package:aqedu/features/course_register/models/model_course_register_fillter.dart';
import 'package:aqedu/features/course_register/models/model_course_register_results.dart';
import 'package:aqedu/features/infor/models/models_infor_student.dart';
import 'package:aqedu/features/notification/models/notification_student.dart';
import 'package:aqedu/features/prerequisite_subjects/models/model_prequisite_subjects.dart';
import 'package:aqedu/features/program_training/models/model_program_data.dart';
import 'package:aqedu/features/schedure/models/schedure_student.dart';
import 'package:aqedu/features/score_data/models/model_score_student.dart';
import 'package:aqedu/features/tuition/models/models_tuition.dart';

class PortalLocalReadStore {
  const PortalLocalReadStore({this.snapshotStore});

  static const _emptyRequest = <String, dynamic>{};
  final ApiReadSnapshotStore? snapshotStore;

  static Map<String, dynamic> notificationRequest() => {
    'filter': {'id': null, 'is_noi_dung': true, 'is_web': true},
    'additional': {
      'paging': {'limit': 100, 'page': 1},
      'ordering': [
        {'name': 'ngay_gui', 'order_type': 1},
      ],
    },
  };

  static Map<String, dynamic> trainingProgramRequest() => {
    'filter': {'loai_chuong_trinh_dao_tao': 1},
    'additional': {
      'paging': {'limit': 500, 'page': 1},
      'ordering': [
        {'name': null, 'order_type': null},
      ],
    },
  };

  static Map<String, dynamic> prerequisiteRequest(int type) => {
    'loai_tien_quyet': type,
    'additional': {
      'paging': {'limit': 40, 'page': 1},
      'ordering': [
        {'name': null, 'order_type': null},
      ],
    },
  };

  static Map<String, dynamic> courseRegisterCatalogRequest() => {
    'is_CVHT': false,
    'additional': {
      'paging': {'limit': 99999, 'page': 1},
      'ordering': [
        {'name': '', 'order_type': ''},
      ],
    },
  };

  static Map<String, dynamic> courseRegisterResultRequest() => {
    'is_CVHT': false,
    'is_Clear': false,
  };

  Future<TkbResponse?> schedule() => _load(
    resourceKey: ApiReadResourceRegistry.schedule,
    requestBody: daotaoSchedulePayload(),
    decoder: (json) => TkbResponse.fromJson(_map(json)),
  );

  Future<ScoreResponse?> scores() => _load(
    resourceKey: ApiReadResourceRegistry.scores,
    requestBody: _emptyRequest,
    decoder: (json) => ScoreResponse.fromJson(_map(json)),
  );

  Future<NotificationResponse?> notifications() => _load(
    resourceKey: ApiReadResourceRegistry.notifications,
    requestBody: notificationRequest(),
    decoder: (json) => NotificationResponse.fromJson(_map(json)),
  );

  Future<StudentResponse?> studentProfile() => _load(
    resourceKey: ApiReadResourceRegistry.studentProfile,
    requestBody: _emptyRequest,
    decoder: (json) => StudentResponse.fromJson(_map(json)),
  );

  Future<HocPhiResponse?> tuition() => _load(
    resourceKey: ApiReadResourceRegistry.tuition,
    requestBody: _emptyRequest,
    decoder: (json) => HocPhiResponse.fromJson(_map(json)),
  );

  Future<ProgramTrainingResponse?> trainingProgram() => _load(
    resourceKey: ApiReadResourceRegistry.trainingProgram,
    requestBody: trainingProgramRequest(),
    decoder: (json) => ProgramTrainingResponse.fromJson(_map(json)),
  );

  Future<PrerequisiteResponse?> prerequisiteSubjects(int type) => _load(
    resourceKey: '${ApiReadResourceRegistry.prerequisiteSubjects}:$type',
    requestBody: prerequisiteRequest(type),
    decoder: (json) => PrerequisiteResponse.fromJson(_map(json)),
  );

  Future<List<CourseRegisterFilter>?> courseRegisterFilters() => _load(
    resourceKey: ApiReadResourceRegistry.courseRegisterFilters,
    requestBody: _emptyRequest,
    decoder: (json) => _list(
      json,
    ).map((item) => CourseRegisterFilter.fromJson(_map(item))).toList(),
  );

  Future<CourseRegisterResponse?> courseRegisterCatalog() => _load(
    resourceKey: ApiReadResourceRegistry.courseRegisterCatalog,
    requestBody: courseRegisterCatalogRequest(),
    decoder: (json) => CourseRegisterResponse.fromJson(_map(json)),
  );

  Future<CourseRegisterResultResponse?> courseRegisterResult() => _load(
    resourceKey: ApiReadResourceRegistry.courseRegisterResult,
    requestBody: courseRegisterResultRequest(),
    decoder: (json) => CourseRegisterResultResponse.fromJson(_map(json)),
  );

  Future<T?> _load<T>({
    required String resourceKey,
    required Object? requestBody,
    required PortalSnapshotDecoder<T> decoder,
  }) {
    return PortalSnapshotRepository<T>(
      resourceKey: resourceKey,
      requestBody: requestBody,
      decoder: decoder,
      snapshotStore: snapshotStore,
    ).load();
  }

  static Map<String, dynamic> _map(Object value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    throw const FormatException('Expected JSON object');
  }

  static List<Object> _list(Object value) {
    if (value is List) return value.whereType<Object>().toList();
    throw const FormatException('Expected JSON list');
  }
}
