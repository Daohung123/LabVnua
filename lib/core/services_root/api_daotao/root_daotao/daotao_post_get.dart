import 'dart:convert';

import 'package:aqedu/core/logging/app_log.dart';
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
      AppLog.api(
        'Bắt đầu đăng nhập hệ thống đào tạo',
        khuVuc: 'API đào tạo',
        duLieu: {'co_tai_khoan': user.trim().isNotEmpty},
      );
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
      AppLog.api(
        'Đăng nhập hệ thống đào tạo thành công',
        khuVuc: 'API đào tạo',
        duLieu: {'co_cookie': cookie != null, 'co_token': token != null},
      );

      ///syncData

      /// tạo SessionModel
      return SessionModel(
        user: user,
        pass: pass,
        cookie: cookie!,
        token: token!,
      );
    } catch (e, stackTrace) {
      AppLog.loi(
        'Đăng nhập hệ thống đào tạo gặp lỗi',
        khuVuc: 'API đào tạo',
        loi: e,
        stackTrace: stackTrace,
      );
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
    AppLog.api(
      'Bắt đầu gọi API đào tạo',
      khuVuc: 'API đào tạo',
      duLieu: {
        'phuong_thuc': method,
        'duong_dan': path,
        'co_body': requestBody.isNotEmpty,
      },
    );

    try {
      final response = method == 'GET'
          ? await http.get(uri, headers: _headers())
          : await http.post(
              uri,
              headers: _headers(contentTypeJson: true),
              body: jsonEncode(requestBody),
            );
      AppLog.api(
        'API đào tạo đã phản hồi',
        khuVuc: 'API đào tạo',
        duLieu: {
          'phuong_thuc': method,
          'duong_dan': path,
          'ma_trang_thai': response.statusCode,
          'do_dai_phan_hoi': response.body.length,
        },
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
        AppLog.coSoDuLieu(
          'Đã lưu phản hồi API đào tạo vào cache SQLite',
          khuVuc: 'API đào tạo',
          duLieu: {
            'phuong_thuc': method,
            'duong_dan': path,
            'ma_trang_thai': response.statusCode,
          },
        );
        final cachedBody = await _cacheService.getResponseBody(
          method: method,
          path: path,
          requestBody: requestBody,
        );
        return _decode(cachedBody ?? response.body);
      }

      return _decode(response.body);
    } catch (error, stackTrace) {
      AppLog.loi(
        'Gọi API đào tạo gặp lỗi',
        khuVuc: 'API đào tạo',
        duLieu: {'phuong_thuc': method, 'duong_dan': path},
        loi: error,
        stackTrace: stackTrace,
        ketQua: 'Đang kiểm tra cache SQLite để fallback.',
      );
      final cachedBody = await _cacheService.getResponseBody(
        method: method,
        path: path,
        requestBody: requestBody,
      );
      if (cachedBody != null) {
        AppLog.coSoDuLieu(
          'Dùng phản hồi API từ cache SQLite',
          khuVuc: 'API đào tạo',
          duLieu: {
            'phuong_thuc': method,
            'duong_dan': path,
            'do_dai_cache': cachedBody.length,
          },
        );
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
