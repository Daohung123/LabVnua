import 'package:aqedu/core/database/portal_local_read_store.dart';
import 'package:aqedu/core/services_root/sqlite/infomationStudent/information_sqlite.dart';
import 'package:aqedu/features/infor/models/models_infor_student.dart';

class ChatStudentInfoService {
  ChatStudentInfoService({ServiceSqlInformationStudentRoot? studentSqlService})
    : _studentSqlService =
          studentSqlService ?? ServiceSqlInformationStudentRoot();

  final ServiceSqlInformationStudentRoot _studentSqlService;

  Future<StudentData?> getCurrentStudentData() async {
    final localStudent = await _studentSqlService.getStudent();
    if (localStudent != null && localStudent.maSv.trim().isNotEmpty) {
      return localStudent;
    }

    final response = await const PortalLocalReadStore().studentProfile();

    final studentData = response?.data;
    if (studentData != null && studentData.maSv.trim().isNotEmpty) {
      await _studentSqlService.insertStudent(studentData);
    }

    return studentData;
  }
}
