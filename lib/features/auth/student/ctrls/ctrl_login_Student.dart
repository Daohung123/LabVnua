import 'package:aqedu/core/models/sqlite/Session.dart';
import 'package:aqedu/core/services/api_daotao/root_daotao/daotao_post_get.dart';
import 'package:aqedu/core/services/sqlite/sessions/core_service_session.dart';

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
  print("Tai khoan: ${session?.user}");
  print("Mat khau: ${session?.pass}");

  if (session?.cookie == null && session?.token == null) return false;

  return true;
}
