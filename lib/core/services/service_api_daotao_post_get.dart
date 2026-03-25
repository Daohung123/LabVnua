import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../shared/models/sqlite/cookie_token_model.dart';

class ApiHelper {
  String? cookie;
  String? token;

  ApiHelper() {}
  ApiHelper.withSession(String cookie_in, String token_in) {
    this.cookie = cookie_in;
    this.token = token_in;
  }

  String _getCookie(String raw, String key) =>
      RegExp('$key=([^;]+)').firstMatch(raw)?.group(1) ?? '';

  /// LOGIN
  Future<SessionModel?> login(String user, String pass) async {
    try {
      final auth = await http.get(
        Uri.parse("https://daotao.vnua.edu.vn/api/auth/authconfig"),
      );

      final rawCookie = auth.headers['set-cookie']!;
      final session = _getCookie(rawCookie, "ASP.NET_SessionId");

      final code = base64
          .encode(
            utf8.encode(
              jsonEncode({
                "username": user,
                "password": pass,
                "uri": "https://daotao.vnua.edu.vn/#/home",
              }),
            ),
          )
          .replaceAll("=", "%3D");

      final url =
          "https://daotao.vnua.edu.vn/api/pn-signin?code=$code&gopage=&mgr=1";

      final req = http.Request("GET", Uri.parse(url))
        ..headers["cookie"] = rawCookie
        ..followRedirects = false;

      final res = await http.Response.fromStream(await req.send());

      final location = res.headers['location'];
      if (location == null) return null;

      final query = Uri.splitQueryString(location.split('?')[1]);

      final newCookie = res.headers['set-cookie']!;
      final xsrfCtrl = _getCookie(newCookie, "xsrf-ctrl");
      final xsrfSec = _getCookie(newCookie, "xsrf-sec");

      cookie =
          "ASP.NET_SessionId=$session; xsrf-ctrl=$xsrfCtrl; xsrf-sec=$xsrfSec; xsrf-repl=0";

      final currUser = jsonDecode(
        utf8.decode(base64.decode(query["CurrUser"]!)),
      );

      token = currUser["access_token"];

      /// tạo SessionModel
      return SessionModel(cookie: cookie!, token: token!);
    } catch (e) {
      print("Ngon Luon! Sai mat khau r");
      return null;
    }
  }

  /// GET API
  Future<dynamic> get(String path) async {
    final res = await http.get(
      Uri.parse("https://daotao.vnua.edu.vn/api$path"),
      headers: {"cookie": cookie ?? "", "authorization": "Bearer $token"},
    );

    return jsonDecode(res.body);
  }

  /// POST API
  Future<dynamic> post(String path, Map body) async {
    final res = await http.post(
      Uri.parse("https://daotao.vnua.edu.vn/api$path"),
      headers: {
        "cookie": cookie ?? "",
        "authorization": "Bearer $token",
        "content-type": "application/json",
      },
      body: jsonEncode(body),
    );

    return jsonDecode(res.body);
  }
}
