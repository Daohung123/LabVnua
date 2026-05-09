import 'dart:developer';

import 'package:aqedu/core/services_root/sqlite/sessions/services_get_cookie_token.dart';
import 'package:aqedu/features/score_data/models/model_score_student.dart';
import 'package:aqedu/features/score_data/services/service_score_student.dart';


class CtrlScoreStudent {
  final String _cookie;
  final String _token;

  CtrlScoreStudent._(this._cookie, this._token);

  static Future<CtrlScoreStudent> create() async {
    final cookie = await GETDB.getCookie();
    final token = await GETDB.getToken();

    return CtrlScoreStudent._(cookie, token);
  }

  Future<List<SemesterScore>> getScores() async {
    try {
      return await ScoreService.getSemesterScores(
        _cookie,
        _token,
      );
    } catch (e) {
      log("Lỗi getScores: $e");
      return [];
    }
  }
}