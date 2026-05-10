import 'package:aqedu/core/services_root/sqlite/sessions/core_service_session.dart';

class ControllerSettings {
  static Future<void> logOut() async {
    SqliteServices sqliteServices = SqliteServices();
    await sqliteServices.deleteSession();
  }
}
