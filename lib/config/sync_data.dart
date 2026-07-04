import 'package:aqedu/core/services_root/api_daotao/course_Register/get_course_register_fillter.dart';
import 'package:aqedu/core/services_root/api_daotao/course_Register/get_course_register_respone.dart';
import 'package:aqedu/core/services_root/api_daotao/course_Register/get_course_register_result_response.dart';
import 'package:aqedu/core/services_root/api_daotao/prerequisite_Subjects/get_prerequisite_respone.dart';
import 'package:aqedu/core/services_root/api_daotao/schedure/get_tkb_response.dart';
import 'package:aqedu/core/services_root/api_daotao/score/get_score_response.dart';
import 'package:aqedu/core/services_root/api_daotao/trainning_Program/get_training_program_respone.dart';
import 'package:aqedu/core/services_root/api_daotao/tuition/get_tuition.dart';
import 'package:aqedu/core/services_root/sqlite/schedure/schedure_sqlite.dart';
import 'package:aqedu/core/services_root/sqlite/sessions/services_get_cookie_token.dart';
import 'package:aqedu/features/infor/services/service_sqlite_information_student.dart';
import 'package:aqedu/features/notification/services/service_sql_notification_student.dart';

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
  final errors = <String>[];
  var total = 0;
  var success = 0;

  Future<void> runSync(String label, Future<void> Function() action) async {
    total++;
    try {
      await action();
      success++;
    } catch (error) {
      errors.add('$label: $error');
    }
  }

  await runSync(
    'notifications',
    ServiceSqlNotificationStudent.syncNotifications,
  );
  await runSync(
    'student_information',
    ServiceSqlInformationStudent.syncInformation,
  );

  String? cookie;
  String? token;
  try {
    cookie = await GETDB.getCookie();
    token = await GETDB.getToken();
  } catch (error) {
    errors.add('session: $error');
  }

  if (cookie != null && token != null) {
    final sessionCookie = cookie;
    final sessionToken = token;

    await runSync('schedule', () async {
      final response = await core_services_get_TkbResponse(
        sessionCookie,
        sessionToken,
      );
      if (response == null) {
        throw StateError('schedule response is empty');
      }
      await ServiceSqlTkb().syncFromApi(response);
    });
    await runSync('scores', () async {
      final response = await getScoreResponse(sessionCookie, sessionToken);
      if (response == null) throw StateError('scores response is empty');
    });
    await runSync('tuition', () async {
      final response = await getHocPhiResponse(sessionCookie, sessionToken);
      if (response == null) throw StateError('tuition response is empty');
    });
    await runSync('training_program', () async {
      final response = await getProgramTrainingResponse(
        sessionCookie,
        sessionToken,
      );
      if (response == null) {
        throw StateError('training program response is empty');
      }
    });
    await runSync('prerequisite_subjects', () async {
      final prerequisite = await getPrerequisiteResponse(
        sessionCookie,
        sessionToken,
        loaiTienQuyet: 1,
      );
      final parallelPrerequisite = await getPrerequisiteResponse(
        sessionCookie,
        sessionToken,
        loaiTienQuyet: 2,
      );
      if (prerequisite == null && parallelPrerequisite == null) {
        throw StateError('prerequisite response is empty');
      }
    });
    await runSync('course_register_filters', () async {
      final response = await getCourseRegisterFilterResponse(
        sessionCookie,
        sessionToken,
      );
      if (response == null) {
        throw StateError('course register filters response is empty');
      }
    });
    await runSync('course_register_classes', () async {
      final response = await getCourseRegisterResponse(
        sessionCookie,
        sessionToken,
      );
      if (response == null) {
        throw StateError('course register classes response is empty');
      }
    });
    await runSync('course_register_result', () async {
      final response = await getCourseRegisterResultResponse(
        sessionCookie,
        sessionToken,
      );
      if (response == null) {
        throw StateError('course register result response is empty');
      }
    });
  }

  return SyncDataResult(
    total: total,
    success: success,
    failed: total - success,
    errors: errors,
  );
}
