import 'package:aqedu/core/services_root/api_daotao/score/getScoreResponse.dart';
import 'package:aqedu/features/score_data/models/model_score_student.dart';


class ScoreService {
  static Future<List<SemesterScore>> getSemesterScores(
    String cookie,
    String token,
  ) async {
    try {
      final ScoreResponse? response = await getScoreResponse(cookie, token);

      if (response == null) {
        return [];
      }

      final List<SemesterScore>? semesters = response.data?.dsDiemHocky;

      if (semesters == null || semesters.isEmpty) {
        return [];
      }

      return semesters;
    } catch (e) {
      print("Lỗi ScoreService.getSemesterScores: $e");
      return [];
    }
  }
}