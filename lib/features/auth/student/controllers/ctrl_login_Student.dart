import 'package:aqedu/core/models/sqlite/session.dart';
import 'package:aqedu/core/services_root/api_daotao/root_daotao/daotao_post_get.dart';
import 'package:aqedu/core/services_root/sqlite/sessions/core_service_session.dart';
import 'package:aqedu/core/services_root/supabase/supabase_config.dart';
import 'package:aqedu/features/chat/services/chat_notification_service.dart';
import 'package:aqedu/features/chat/services/chat_realtime_connection_service.dart';
import 'package:aqedu/features/chat/services/chat_user_sync_service.dart';
import 'package:flutter/foundation.dart';

// ignore: non_constant_identifier_names
Future<bool> ctrl_login(String username, String password) async {
  SqliteServices sqlite = SqliteServices();
  ApiHelper daotao = ApiHelper();
  SessionModel? res = await daotao.login(username, password);
  if (res == null) return false;
  await sqlite.deleteSession();
  await sqlite.saveSession(res);
  final session = await sqlite.getSession();
  // print(session?.cookie);
  // print(session?.token);
  // print("Tai khoan: ${session?.user}");
  // print("Mat khau: ${session?.pass}");

  if (session?.cookie == null && session?.token == null) return false;

  try {
    final isSupabaseReady = await SupabaseConfig.init();
    if (isSupabaseReady) {
      final chatUser = await ChatUserSyncService().syncCurrentSessionUser();
      await ChatRealtimeConnectionService.instance.connect(chatUser);
      await ChatNotificationService.instance.startForUser(chatUser);
    }
  } catch (error, stackTrace) {
    debugPrint('Chat user sync failed: $error');
    debugPrintStack(stackTrace: stackTrace);
  }

  return true;
}
