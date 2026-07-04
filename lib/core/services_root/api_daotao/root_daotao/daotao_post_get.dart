import 'dart:convert';

import 'package:aqedu/core/services_root/sqlite/api_cache/api_response_cache.dart';
import 'package:http/http.dart' as http;

import '../../../models/sqlite/session.dart';
import '../../../constants/api/api_daotao.dart';

class ApiHelper {
  String? cookie;
  String? token;
  final ApiResponseCacheService _cacheService = ApiResponseCacheService();

  ApiHelper();
  ApiHelper.withSession(String cookieIn, String tokenIn) {
    cookie = cookieIn;
    token = tokenIn;
  }

  String _getCookie(String raw, String key) =>
      RegExp('$key=([^;]+)').firstMatch(raw)?.group(1) ?? '';

  /// LOGIN
  Future<SessionModel?> login(String user, String pass) async {
    try {
      final auth = await http.get(Uri.parse(APIAUTH));

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

      final url = APILOGIN(code);

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

      ///syncData

      /// tạo SessionModel
      return SessionModel(
        user: user,
        pass: pass,
        cookie: cookie!,
        token: token!,
      );
    } catch (e) {
      return null;
    }
  }

  /// GET API
  Future<dynamic> get(String path) async {
    return _request('GET', path);
  }

  /// POST API
  Future<dynamic> post(String path, Map body) async {
    return _request('POST', path, body: body);
  }

  Future<dynamic> _request(String method, String path, {Map? body}) async {
    final uri = Uri.parse("$APIDAOTAO$path");
    final requestBody = body ?? const {};

    try {
      final response = method == 'GET'
          ? await http.get(uri, headers: _headers())
          : await http.post(
              uri,
              headers: _headers(contentTypeJson: true),
              body: jsonEncode(requestBody),
            );

      if (_shouldCache(response)) {
        await _cacheService.saveResponse(
          method: method,
          path: path,
          requestBody: requestBody,
          responseBody: response.body,
          responseStatus: response.statusCode,
          sourceUrl: uri.toString(),
        );
        final cachedBody = await _cacheService.getResponseBody(
          method: method,
          path: path,
          requestBody: requestBody,
        );
        return _decode(cachedBody ?? response.body);
      }

      return _decode(response.body);
    } catch (_) {
      final cachedBody = await _cacheService.getResponseBody(
        method: method,
        path: path,
        requestBody: requestBody,
      );
      if (cachedBody != null) {
        return _decode(cachedBody);
      }
      rethrow;
    }
  }

  Map<String, String> _headers({bool contentTypeJson = false}) {
    return {
      "cookie": cookie ?? "",
      "authorization": "Bearer $token",
      if (contentTypeJson) "content-type": "application/json",
    };
  }

  bool _shouldCache(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) return false;
    if (response.body.trim().isEmpty) return false;
    if (response.body.contains("<!DOCTYPE")) return false;

    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map && decoded['result'] == false) return false;
      return true;
    } catch (_) {
      return false;
    }
  }

  dynamic _decode(String rawBody) {
    try {
      return jsonDecode(rawBody);
    } catch (_) {
      return rawBody;
    }
  }
}
