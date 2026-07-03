import 'package:aqedu/core/services_root/sqlite/sessions/core_service_session.dart';
import 'package:aqedu/features/chat/services/chat_notification_service.dart';
import 'package:aqedu/features/chat/services/chat_realtime_connection_service.dart';

class ControllerSettings {
  static Future<void> logOut() async {
    await ChatNotificationService.instance.stop();
    await ChatRealtimeConnectionService.instance.disconnect();
    SqliteServices sqliteServices = SqliteServices();
    await sqliteServices.deleteSession();
  }
}
