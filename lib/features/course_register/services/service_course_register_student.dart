import 'package:aqedu/core/logging/app_log.dart';
import 'package:aqedu/core/services_root/api_daotao/information_Student/get_information.dart';
import 'package:aqedu/features/infor/models/models_infor_student.dart';

class CourseRegisterStudentService {
  static Future<StudentData?> getStudentData(
    String cookie,
    String token,
  ) async {
    try {
      final StudentResponse? response = await getInformationResponse(
        cookie,
        token,
      );

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
