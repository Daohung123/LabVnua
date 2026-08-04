import 'dart:developer';

import '../models/model_prequisite_subjects.dart';
import '../services/service_prequisite_subjects.dart';

class CtrlPrerequisite {
  CtrlPrerequisite._();

  static Future<CtrlPrerequisite> create() async => CtrlPrerequisite._();

  Future<List<PrerequisiteSubject>> getPrerequisiteSubjects({
    int loaiTienQuyet = 1,
  }) async {
    try {
      return await PrerequisiteService.getPrerequisiteSubjects(
        loaiTienQuyet: loaiTienQuyet,
      );
    } catch (e) {
      log("Lỗi getPrerequisiteSubjects: $e");
      return [];
    }
  }
}
