import 'package:aqedu/core/logging/app_log.dart';
import 'package:aqedu/core/database/portal_local_read_store.dart';
import '../models/model_course_register_fillter.dart';

class CourseRegisterFilterService {
  static Future<List<CourseRegisterFilter>> getFilters() async {
    try {
      final List<CourseRegisterFilter>? response =
          await const PortalLocalReadStore().courseRegisterFilters();

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
