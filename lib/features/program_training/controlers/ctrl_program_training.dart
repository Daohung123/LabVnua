import 'dart:developer';

import 'package:aqedu/core/services_root/sqlite/sessions/services_get_cookie_token.dart';
import '../models/model_program_data.dart';
import 'package:aqedu/features/program_training/services/service_program_training.dart';

class CtrlProgramTraining {
  final String _cookie;
  final String _token;

  CtrlProgramTraining._(this._cookie, this._token);

  static Future<CtrlProgramTraining> create() async {
    final cookie = await GETDB.getCookie();
    final token = await GETDB.getToken();

    return CtrlProgramTraining._(cookie, token);
  }

  Future<List<ProgramTrainingSemester>> getProgramTraining() async {
    try {
      return await ProgramTrainingService.getProgramTrainingSemesters(
        _cookie,
        _token,
      );
    } catch (e) {
      log("Lỗi getProgramTraining: $e");
      return [];
    }
  }
}