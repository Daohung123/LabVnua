import 'package:aqedu/core/logging/app_log.dart';
import 'package:aqedu/core/database/portal_local_read_store.dart';
import 'package:aqedu/features/infor/models/models_infor_student.dart';

class CourseRegisterStudentService {
  static Future<StudentData?> getStudentData() async {
    try {
      final StudentResponse? response = await const PortalLocalReadStore()
          .studentProfile();

      if (response == null) {
        return null;
      }

      return response.data;
    } catch (e) {
      AppLog.ungDung(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/features/course_register/services/service_course_register_student.dart',
        duLieu: "Lỗi CourseRegisterStudentService.getStudentData: $e",
      );
      return null;
    }
  }
}
