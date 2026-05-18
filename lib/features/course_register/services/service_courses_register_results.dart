import '../../../core/services_root/api_daotao/course_Register/getCourseRegisterResultResponse.dart';
import '../models/model_course_register_results.dart';

class CourseRegisterResultService { 
  static Future<CourseRegisterResultResponse?> getCourseRegisterResult(
    String cookie,
    String token,
  ) async {
    try {
      final CourseRegisterResultResponse? response =
          await getCourseRegisterResultResponse(
        cookie,
        token,
      );

      return response;
    } catch (e) {
      print("Lỗi CourseRegisterResultService.getCourseRegisterResult: $e");
      return null;
    }
  }
}