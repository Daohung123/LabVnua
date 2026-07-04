import 'package:aqedu/core/services_root/api_daotao/root_daotao/daotao_post_get.dart';
import 'package:aqedu/core/models/sqlite/session.dart';

class DaotaoApiClient {
  DaotaoApiClient({ApiHelper? apiHelper})
    : _apiHelper = apiHelper ?? ApiHelper();

  DaotaoApiClient.withSession(String cookie, String token)
    : _apiHelper = ApiHelper.withSession(cookie, token);

  final ApiHelper _apiHelper;

  Future<SessionModel?> login(String username, String password) {
    return _apiHelper.login(username, password);
  }

  Future<dynamic> get(String url) => _apiHelper.get(url);

  Future<dynamic> post(String url, Map<String, dynamic> body) {
    return _apiHelper.post(url, body);
  }
}
