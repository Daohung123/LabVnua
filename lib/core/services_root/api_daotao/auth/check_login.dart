import 'package:aqedu/core/models/sqlite/session.dart';
import 'package:aqedu/core/services_root/sqlite/sessions/core_service_session.dart';
import 'package:aqedu/features/auth/student/controllers/ctrl_login_student.dart';

Future<bool> checkLogin() async {
  SqliteServices db = SqliteServices();
  SessionModel? customer = await db.getSession();
  if (customer == null) return false;
  bool checkCount = await db.checkLogin();
  if (checkCount != true) {
    print("Lỗi count sql: $checkCount");
    return false;
  }
  return await ctrl_login(customer.user, customer.pass);
}
