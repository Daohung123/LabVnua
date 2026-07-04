import 'package:aqedu/core/logging/app_log.dart';
import '../../../core/services_root/api_daotao/course_Register/get_course_register_result_response.dart';
import '../models/model_course_register_results.dart';

class CourseRegisterResultService {
  static Future<CourseRegisterResultResponse?> getCourseRegisterResult(
    String cookie,
    String token,
  ) async {
    try {
      final CourseRegisterResultResponse? response =
          await getCourseRegisterResultResponse(cookie, token);

      return response;
    } catch (e) {
      AppLog.ungDung(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/features/course_register/services/service_courses_register_results.dart',
        duLieu: "Lỗi CourseRegisterResultService.getCourseRegisterResult: $e",
      );
      return null;
    }
  }
}
