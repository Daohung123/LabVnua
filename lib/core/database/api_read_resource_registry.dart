import 'package:aqedu/core/constants/api/api_daotao.dart';
import 'package:aqedu/core/constants/api/api_daotao_teacher.dart';

enum ApiRequestSemantics { read, mutation }

class ApiReadResourceRegistry {
  const ApiReadResourceRegistry._();

  static const schedule = 'schedule';
  static const scores = 'scores';
  static const notifications = 'notifications';
  static const studentProfile = 'student_profile';
  static const tuition = 'tuition';
  static const trainingProgram = 'training_program';
  static const prerequisiteSubjects = 'prerequisite_subjects';
  static const courseRegisterFilters = 'course_register_filters';
  static const courseRegisterCatalog = 'course_register_catalog';
  static const courseRegisterResult = 'course_register_result';
  static const teacherProfile = 'teacher_profile';
  static const teacherFunctions = 'teacher_functions';
  static const teacherNotifications = 'teacher_notifications';

  static ApiRequestSemantics semanticsFor(String path) {
    if (path == APICOURSEREGISTERACTION) {
      return ApiRequestSemantics.mutation;
    }
    return ApiRequestSemantics.read;
  }

  static String resourceKeyFor(String path, {Object? requestBody}) {
    if (path == APIPREREQUISTESUBJECT && requestBody is Map) {
      final type = requestBody['loai_tien_quyet'];
      return '$prerequisiteSubjects:${type ?? 'default'}';
    }
    if (path == APITEACHERNOTIFICATION && requestBody is Map) {
      final filter = requestBody['filter'];
      if (filter is Map && filter['is_web'] == false) {
        return teacherNotifications;
      }
    }
    final resources = {
      APISCHEDURE: schedule,
      APISCOREDATA: scores,
      APINOTIFICATION: notifications,
      APIINFORMATION: studentProfile,
      APITUITON: tuition,
      APITRAININGPROGRAM: trainingProgram,
      APIPREREQUISTESUBJECT: prerequisiteSubjects,
      APICOURSEREGISTERFILLTER: courseRegisterFilters,
      APICOURSEREGISTERCLASSES: courseRegisterCatalog,
      APICOUREGISTERRESULT: courseRegisterResult,
      APITEACHERINFORMATION: teacherProfile,
      APITEACHERFUNCTIONS: teacherFunctions,
    };
    return resources[path] ?? 'portal:${path.hashCode}';
  }
}
