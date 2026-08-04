import 'package:aqedu/core/logging/app_log.dart';
import 'package:aqedu/core/database/portal_local_read_store.dart';
import 'package:aqedu/features/score_data/models/model_score_student.dart';

class ScoreService {
  static Future<List<SemesterScore>> getSemesterScores() async {
    try {
      final ScoreResponse? response = await const PortalLocalReadStore()
          .scores();

      if (response == null) {
        return [];
      }

      final List<SemesterScore>? semesters = response.data?.dsDiemHocky;

      if (semesters == null || semesters.isEmpty) {
        return [];
      }

      return semesters;
    } catch (e) {
      AppLog.ungDung(
        'Ghi nhận hoạt động runtime',
        khuVuc: 'lib/features/score_data/services/service_score_student.dart',
        duLieu: "Lỗi ScoreService.getSemesterScores: $e",
      );
      return [];
    }
  }
}
