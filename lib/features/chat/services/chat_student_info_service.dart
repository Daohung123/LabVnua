import 'package:aqedu/core/services_root/api_daotao/information_Student/getInformation.dart';
import 'package:aqedu/core/services_root/sqlite/infomationStudent/information_sqlite.dart';
import 'package:aqedu/core/services_root/sqlite/sessions/core_service_session.dart';
import 'package:aqedu/features/infor/models/models_inforStudent.dart';

class ChatStudentInfoService {
  ChatStudentInfoService({
    ServiceSqlInformationStudentRoot? studentSqlService,
    SqliteServices? sessionService,
  })  : _studentSqlService = studentSqlService ?? ServiceSqlInformationStudentRoot(),
        _sessionService = sessionService ?? SqliteServices();

  final ServiceSqlInformationStudentRoot _studentSqlService;
  final SqliteServices _sessionService;

  Future<StudentData?> getCurrentStudentData() async {
    final localStudent = await _studentSqlService.getStudent();
    if (localStudent != null && localStudent.maSv.trim().isNotEmpty) {
      return localStudent;
    }

    final session = await _sessionService.getSession();
    if (session == null || session.cookie.trim().isEmpty || session.token.trim().isEmpty) {
      return null;
    }

    final response = await getInformationResponse(
      session.cookie,
      session.token,
    );

    final studentData = response?.data;
    if (studentData != null && studentData.maSv.trim().isNotEmpty) {
      await _studentSqlService.insertStudent(studentData);
    }

    return studentData;
  }
}
