import 'package:aqedu/core/models/sqlite/Session.dart';
import 'package:aqedu/core/services/sqlite/sessions/core_service_session.dart';
import 'package:aqedu/features/auth/ctrls/ctrl_login.dart';

Future<bool> checkLogin() async {
  SqliteServices db = SqliteServices();
  SessionModel? customer = await db.getSession();
  if (customer == null) return false;
  print("user: ${customer!.user}");
  print("pass: ${customer.pass}");
  print("cookie: ${customer.cookie}");
  print("token: ${customer.token}");
  bool checkCount = await db.checkLogin();
  if (checkCount != true) {
    print("Lỗi count sql: $checkCount");
    return false;
  }
  return await ctrl_login(customer.user, customer.pass);
}
