import 'package:aqedu/core/services_root/sqlite/sessions/services_get_cookie_token.dart';
import 'package:aqedu/features/infor/models/model_inforStudentFill.dart';
import 'package:aqedu/features/infor/services/service_sqlite_informationStudent.dart';
import 'package:aqedu/features/infor/services/services_api_informationStudent.dart';

class CtrlInforStudent {
 
  static Future<InforStudentFillData?> getInforStudent() async {
    try {
      final InforStudentFillData? dataNotifications =
          await ServiceSqlInformationStudent.getInforStudentFill();
      return dataNotifications;
    } catch (e) {
      return null;
    }
  }
}