import '../../../core/services_root/api_daotao/course_Register/getCourseRegisterRespone.dart';
import '../models/model_course_register.dart';

class CourseRegisterService {
  static Future<List<CourseRegisterClass>> getClasses(
    String cookie,
    String token,
  ) async {
    try {
      final CourseRegisterResponse? response =
          await getCourseRegisterResponse(cookie, token);

      if (response == null) {
        return [];
      }

      final List<CourseRegisterClass>? classes = response.data?.dsNhomTo;

      if (classes == null || classes.isEmpty) {
        return [];
      }

      return classes;
    } catch (e) {
      print("Lỗi CourseRegisterService.getClasses: $e");
      return [];
    }
  }
}