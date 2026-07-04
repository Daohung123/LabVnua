import 'package:aqedu/core/logging/app_log.dart';
import '../../../core/services_root/api_daotao/course_Register/get_course_register_fillter.dart';
import '../models/model_course_register_fillter.dart';

class CourseRegisterFilterService {
  static Future<List<CourseRegisterFilter>> getFilters(
    String cookie,
    String token,
  ) async {
    try {
      final List<CourseRegisterFilter>? response =
          await getCourseRegisterFilterResponse(cookie, token);

      if (response == null || response.isEmpty) {
        return [];
      }

      return response;
    } catch (e) {
      AppLog.ungDung(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/features/course_register/services/service_courses_register_fillter.dart',
        duLieu: "Lỗi CourseRegisterFilterService.getFilters: $e",
      );
      return [];
    }
  }
}
