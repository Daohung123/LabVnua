import '../../../core/services_root/api_daotao/trainning_Program/getTrainingProgramRespone.dart';
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
      print("Lỗi ProgramTrainingService.getProgramTrainingSemesters: $e");
      return [];
    }
  }
}