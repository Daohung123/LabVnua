import 'package:aqedu/core/logging/app_log.dart';
import 'package:aqedu/core/models/sqlite/session.dart';
import 'package:aqedu/core/services_root/sqlite/sessions/core_service_session.dart';
import 'package:aqedu/features/auth/student/controllers/ctrl_login_student.dart';

Future<bool> reLogin() async {
  SqliteServices sqlite = SqliteServices();
  SessionModel? customer = await sqlite.getSession();
  if (customer == null) {
    AppLog.api(
      'Ghi nhận hoạt động runtime',
      khuVuc: 'lib/core/services_root/api_daotao/auth/re_login.dart',
      duLieu: "Lỗi dữ liệu customer null!!",
    );
    return false;
  }
  return await ctrl_login(customer.user, customer.pass);
}
