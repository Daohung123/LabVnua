import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../models/sqlite/Session.dart';
import '../../../constants/api/api_daotao.dart';

class ApiHelper {
  String? cookie;
  String? token;

  ApiHelper();
  ApiHelper.withSession(String cookie_in, String token_in) {
    cookie = cookie_in;
    token = token_in;
  }

  void updateSession(String newCookie, String newToken) {
    cookie = newCookie;
    token = newToken;
  }

  String _getCookie(String raw, String key) =>
      RegExp('$key=([^;]+)').firstMatch(raw)?.group(1) ?? '';

  Map<String, String> _getHeaders() {
    // VNUA: Trích xuất XSRF token từ xsrf-ctrl để tránh lỗi 500
    String xsrf = "";
    if (cookie != null) {
      final match = RegExp(r'xsrf-ctrl=([^;]+)').firstMatch(cookie!);
      if (match != null) xsrf = match.group(1) ?? "";
    }

    return {
      "cookie": cookie ?? "",
      "authorization": "Bearer $token",
      "x-xsrf-token": xsrf,
      "content-type": "application/json;charset=UTF-8",
      "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
      "accept": "application/json, text/plain, */*",
      "origin": "https://daotao.vnua.edu.vn",
      "referer": "https://daotao.vnua.edu.vn/",
      "x-requested-with": "XMLHttpRequest",
    };
  }

  Future<SessionModel?> login(String user, String pass) async {
    try {
      final auth = await http.get(Uri.parse(APIAUTH));
      final rawCookie = auth.headers['set-cookie']!;
      final session = _getCookie(rawCookie, "ASP.NET_SessionId");
      final code = base64.encode(utf8.encode(jsonEncode({
        "username": user, "password": pass, "uri": "https://daotao.vnua.edu.vn/#/home",
      }))).replaceAll("=", "%3D");
      final url = APILOGIN(code);
      final req = http.Request("GET", Uri.parse(url))..headers["cookie"] = rawCookie..followRedirects = false;
      final res = await http.Response.fromStream(await req.send());
      final location = res.headers['location'];
      if (location == null) return null;
      final query = Uri.splitQueryString(location.split('?')[1]);
      final newCookie = res.headers['set-cookie']!;
      cookie = "ASP.NET_SessionId=$session; xsrf-ctrl=${_getCookie(newCookie, "xsrf-ctrl")}; xsrf-sec=${_getCookie(newCookie, "xsrf-sec")}; xsrf-repl=0";
      token = jsonDecode(utf8.decode(base64.decode(query["CurrUser"]!)))["access_token"];
      return SessionModel(user: user, pass: pass, cookie: cookie!, token: token!);
    } catch (e) { return null; }
  }

  Future<dynamic> post(String path, Map body) async {
    try {
      final url = "$APIDAOTAO$path";
      print("ApiHelper POST: $url");
      
      final res = await http.post(
        Uri.parse(url),
        headers: _getHeaders(),
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 20));

      print("ApiHelper Status: ${res.statusCode}");
      final responseBody = utf8.decode(res.bodyBytes);

      if (responseBody.trim().startsWith('{')) {
        return jsonDecode(responseBody);
      }
      return responseBody;
    } catch (e) {
      print("ApiHelper Exception: $e");
      return null;
    }
  }
}
