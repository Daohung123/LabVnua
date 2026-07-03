import 'dart:convert';

import 'package:aqedu/core/constants/api/api_daotao_teacher.dart';
import 'package:aqedu/core/services_root/api_daotao/root_daotao/daotao_post_get.dart';
import 'package:aqedu/features/teacher/models/teacher_api_models.dart';

class TeacherApiService {
  TeacherApiService({ApiHelper? api}) : _api = api;

  final ApiHelper? _api;

  Future<TeacherProfileResponse?> getTeacherProfile(
    String cookie,
    String token,
  ) async {
    final jsonData = await _postTeacherApi(
      cookie: cookie,
      token: token,
      path: APITEACHERINFORMATION,
      payload: const <String, dynamic>{},
    );
    if (jsonData == null) return null;
    return TeacherProfileResponse.fromJson(jsonData);
  }

  Future<TeacherFunctionResponse?> getTeacherFunctions(
    String cookie,
    String token,
  ) async {
    final jsonData = await _postTeacherApi(
      cookie: cookie,
      token: token,
      path: APITEACHERFUNCTIONS,
      payload: const <String, dynamic>{},
    );
    if (jsonData == null) return null;
    return TeacherFunctionResponse.fromJson(jsonData);
  }

  Future<TeacherNotificationResponse?> getTeacherNotifications(
    String cookie,
    String token,
  ) async {
    final jsonData = await _postTeacherApi(
      cookie: cookie,
      token: token,
      path: APITEACHERNOTIFICATION,
      payload: const <String, dynamic>{
        'filter': {'id': null, 'is_noi_dung': false, 'is_web': false},
        'additional': {
          'paging': {'limit': 0, 'page': 1},
          'ordering': [
            {'name': '', 'order_type': 0},
          ],
        },
      },
    );
    if (jsonData == null) return null;
    return TeacherNotificationResponse.fromJson(jsonData);
  }

  Future<Map<String, dynamic>?> _postTeacherApi({
    required String cookie,
    required String token,
    required String path,
    required Map<String, dynamic> payload,
  }) async {
    try {
      final api = _api ?? ApiHelper.withSession(cookie, token);
      final response = await api.post(path, payload);
      final jsonData = _decodeResponse(response);
      if (jsonData == null) return null;
      if (jsonData['result'] == false) return null;
      if (jsonData['data'] == null) return null;
      return jsonData;
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic>? _decodeResponse(dynamic response) {
    if (response == null) return null;
    if (response.toString().contains('<!DOCTYPE')) return null;

    final dynamic decoded;
    if (response is String) {
      decoded = jsonDecode(response);
    } else {
      decoded = response;
    }

    if (decoded is Map<String, dynamic>) return decoded;
    if (decoded is Map) return Map<String, dynamic>.from(decoded);
    return null;
  }
}
