import 'dart:developer';

import 'package:aqedu/core/services_root/sqlite/sessions/services_get_cookie_token.dart';
import '../models/model_prequisite_subjects.dart';
import '../services/service_prequisite_subjects.dart';

class CtrlPrerequisite {
  final String _cookie;
  final String _token;

  CtrlPrerequisite._(this._cookie, this._token);

  static Future<CtrlPrerequisite> create() async {
    final cookie = await GETDB.getCookie();
    final token = await GETDB.getToken();

    return CtrlPrerequisite._(cookie, token);
  }

  Future<List<PrerequisiteSubject>> getPrerequisiteSubjects({
    int loaiTienQuyet = 1,
  }) async {
    try {
      return await PrerequisiteService.getPrerequisiteSubjects(
        _cookie,
        _token,
        loaiTienQuyet: loaiTienQuyet,
      );
    } catch (e) {
      log("Lỗi getPrerequisiteSubjects: $e");
      return [];
    }
  }
}