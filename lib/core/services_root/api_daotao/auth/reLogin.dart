import 'package:aqedu/core/models/sqlite/Session.dart';
import 'package:aqedu/core/services_root/sqlite/sessions/core_service_session.dart';
import 'package:aqedu/features/auth/student/ctrls/ctrl_login_Student.dart';

Future<bool> reLogin() async {
  SqliteServices sqlite = SqliteServices();
  SessionModel? customer = await sqlite.getSession();
  if (customer == null) {
    print("Lỗi dữ liệu customer null!!");
    return false;
  }
  return await ctrl_login(customer.user, customer.pass);
}
