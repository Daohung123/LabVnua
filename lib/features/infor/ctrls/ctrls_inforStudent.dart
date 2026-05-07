import '../models/model_inforStudentFill.dart';
import '../services/services_inforStudent.dart';

class StudentController {

  Future<InforStudentFillData> getProfile() async {

    final response = StudentStaticData.getInforStudentFill();

    return response.data;
  }
}