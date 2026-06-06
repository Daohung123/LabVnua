import 'package:aqedu/core/services_root/api_daotao/information_Student/getInformation.dart';
import 'package:aqedu/features/infor/models/models_inforStudent.dart';

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
      print("Lỗi CourseRegisterStudentService.getStudentData: $e");
      return null;
    }
  }
}