import 'package:aqedu/core/logging/app_log.dart';
import 'package:aqedu/core/database/portal_local_read_store.dart';
import '../models/model_program_data.dart';

class ProgramTrainingService {
  static Future<List<ProgramTrainingSemester>>
  getProgramTrainingSemesters() async {
    try {
      final ProgramTrainingResponse? response =
          await const PortalLocalReadStore().trainingProgram();

      if (response == null) {
        return [];
      }

      final List<ProgramTrainingSemester>? semesters =
          response.data?.dsCtdtHocky;

      if (semesters == null || semesters.isEmpty) {
        return [];
      }

      return semesters;
    } catch (e) {
      AppLog.ungDung(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/features/program_training/services/service_program_training.dart',
        duLieu: "Lỗi ProgramTrainingService.getProgramTrainingSemesters: $e",
      );
      return [];
    }
  }
}
