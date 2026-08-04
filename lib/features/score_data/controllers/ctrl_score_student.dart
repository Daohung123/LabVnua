import 'dart:developer';

import 'package:aqedu/features/score_data/models/model_score_student.dart';
import 'package:aqedu/features/score_data/services/service_score_student.dart';

class CtrlScoreStudent {
  CtrlScoreStudent._();

  static Future<CtrlScoreStudent> create() async => CtrlScoreStudent._();

  Future<List<SemesterScore>> getScores() async {
    try {
      return await ScoreService.getSemesterScores();
    } catch (e) {
      log("Lỗi getScores: $e");
      return [];
    }
  }
}
