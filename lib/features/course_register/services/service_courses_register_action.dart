import '../../../core/services_root/api_daotao/course_Register/getCourseRegisterAction.dart';
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
      print("Lỗi CourseRegisterActionService.actionCourseRegister: $e");
      return null;
    }
  }
}