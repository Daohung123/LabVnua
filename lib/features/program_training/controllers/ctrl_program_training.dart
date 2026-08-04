import 'dart:developer';

import '../models/model_program_data.dart';
import 'package:aqedu/features/program_training/services/service_program_training.dart';

class CtrlProgramTraining {
  CtrlProgramTraining._();

  static Future<CtrlProgramTraining> create() async => CtrlProgramTraining._();

  Future<List<ProgramTrainingSemester>> getProgramTraining() async {
    try {
      return await ProgramTrainingService.getProgramTrainingSemesters();
    } catch (e) {
      log("Lỗi getProgramTraining: $e");
      return [];
    }
  }
}
