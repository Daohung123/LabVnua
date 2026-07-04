import 'package:aqedu/core/logging/app_log.dart';
import '../../../core/services_root/api_daotao/course_Register/get_course_register_respone.dart';
import '../models/model_course_register.dart';

class CourseRegisterService {
  static Future<List<CourseRegisterClass>> getClasses(
    String cookie,
    String token,
  ) async {
    try {
      final CourseRegisterResponse? response = await getCourseRegisterResponse(
        cookie,
        token,
      );

      if (response == null) {
        return [];
      }

      final List<CourseRegisterClass>? classes = response.data?.dsNhomTo;

      if (classes == null || classes.isEmpty) {
        return [];
      }

      return classes;
    } catch (e) {
      AppLog.ungDung(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/features/course_register/services/service_courses_register.dart',
        duLieu: "Lỗi CourseRegisterService.getClasses: $e",
      );
      return [];
    }
  }

  static Future<CourseRegisterResponse?> getCourseRegisterFull(
    String cookie,
    String token,
  ) async {
    try {
      return await getCourseRegisterResponse(cookie, token);
    } catch (e) {
      AppLog.ungDung(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/features/course_register/services/service_courses_register.dart',
        duLieu: "Lỗi CourseRegisterService.getCourseRegisterFull: $e",
      );
      return null;
    }
  }
}
