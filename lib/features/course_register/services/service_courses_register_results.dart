import 'package:aqedu/core/logging/app_log.dart';
import 'package:aqedu/core/database/portal_local_read_store.dart';
import '../models/model_course_register_results.dart';

class CourseRegisterResultService {
  static Future<CourseRegisterResultResponse?> getCourseRegisterResult() async {
    try {
      final CourseRegisterResultResponse? response =
          await const PortalLocalReadStore().courseRegisterResult();

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
