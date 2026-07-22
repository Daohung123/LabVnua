import 'package:aqedu/core/constants/api/api_daotao.dart';

enum ApiRequestSemantics { read, mutation }

class ApiReadResourceRegistry {
  const ApiReadResourceRegistry._();

  static ApiRequestSemantics semanticsFor(String path) {
    if (path == APICOURSEREGISTERACTION) {
      return ApiRequestSemantics.mutation;
    }
    return ApiRequestSemantics.read;
  }

  static String resourceKeyFor(String path) {
    final resources = {
      APISCHEDURE: 'schedule',
      APISCOREDATA: 'scores',
      APINOTIFICATION: 'notifications',
      APIINFORMATION: 'student_profile',
      APITUITON: 'tuition',
      APITRAININGPROGRAM: 'training_program',
      APIPREREQUISTESUBJECT: 'prerequisite_subjects',
      APICOURSEREGISTERFILLTER: 'course_register_filters',
      APICOURSEREGISTERCLASSES: 'course_register_catalog',
      APICOUREGISTERRESULT: 'course_register_result',
    };
    return resources[path] ?? 'portal:${path.hashCode}';
  }
}
