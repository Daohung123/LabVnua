import '../models/model_score_student.dart';
import '../services/service_score_student.dart';

class ScoreController {

  Future<ScoreData> getScore() async {

    final response = ScoreStaticData.getScore();

    return response.data!;
  }
}