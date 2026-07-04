import 'package:aqedu/core/logging/app_log.dart';
import '../../../core/services_root/api_daotao/trainning_Program/get_training_program_respone.dart';
import '../models/model_program_data.dart';

class ProgramTrainingService {
  static Future<List<ProgramTrainingSemester>> getProgramTrainingSemesters(
    String cookie,
    String token,
  ) async {
    try {
      final ProgramTrainingResponse? response =
          await getProgramTrainingResponse(cookie, token);

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
