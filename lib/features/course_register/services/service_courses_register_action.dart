import 'package:aqedu/core/logging/app_log.dart';
import '../../../core/services_root/api_daotao/course_Register/get_course_register_action.dart';
import '../models/model_course_register_action.dart';

class CourseRegisterActionService {
  static Future<CourseRegisterActionResponse?> actionCourseRegister(
    String cookie,
    String token, {
    required String idToHoc,
    required bool isChecked,
    required int svNganh,
    required String idRs,
  }) async {
    try {
      final CourseRegisterActionResponse? response =
          await actionCourseRegisterResponse(
            cookie,
            token,
            idToHoc: idToHoc,
            isChecked: isChecked,
            svNganh: svNganh,
            idRs: idRs,
          );

      return response;
    } catch (e) {
      AppLog.ungDung(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/features/course_register/services/service_courses_register_action.dart',
        duLieu: "Lỗi CourseRegisterActionService.actionCourseRegister: $e",
      );
      return null;
    }
  }
}
