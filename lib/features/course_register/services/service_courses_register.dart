import 'package:aqedu/core/logging/app_log.dart';
import 'package:aqedu/core/database/portal_local_read_store.dart';
import '../models/model_course_register.dart';

class CourseRegisterService {
  static Future<List<CourseRegisterClass>> getClasses() async {
    try {
      final CourseRegisterResponse? response =
          await const PortalLocalReadStore().courseRegisterCatalog();

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

  static Future<CourseRegisterResponse?> getCourseRegisterFull() async {
    try {
      return await const PortalLocalReadStore().courseRegisterCatalog();
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
