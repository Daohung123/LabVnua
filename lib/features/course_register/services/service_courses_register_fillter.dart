import '../../../core/services_root/api_daotao/course_Register/getCourseRegisterFillter.dart';
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
      print("Lỗi CourseRegisterFilterService.getFilters: $e");
      return [];
    }
  }
}