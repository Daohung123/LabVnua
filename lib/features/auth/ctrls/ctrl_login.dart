import '../../../config/config_DB.dart';
import 'package:aqedu/core/services/service_api_daotao_post_get.dart';
import 'package:aqedu/shared/models/sqlite/cookie_token_model.dart';

Future<bool> ctrl_login(String username, String password) async {
  DBHelper sqlite = DBHelper();
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
