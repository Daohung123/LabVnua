import 'package:aqedu/core/logging/app_log.dart';
import 'package:aqedu/core/services_root/api_daotao/prerequisite_Subjects/get_prerequisite_respone.dart';
import '../models/model_prequisite_subjects.dart';

class PrerequisiteService {
  static Future<List<PrerequisiteSubject>> getPrerequisiteSubjects(
    String cookie,
    String token, {
    int loaiTienQuyet = 1,
  }) async {
    try {
      final PrerequisiteResponse? response = await getPrerequisiteResponse(
        cookie,
        token,
        loaiTienQuyet: loaiTienQuyet,
      );

      if (response == null) {
        return [];
      }

      final List<PrerequisiteSubject>? subjects = response.data?.dsMonTienQuyet;

      if (subjects == null || subjects.isEmpty) {
        return [];
      }

      return subjects;
    } catch (e) {
      AppLog.ungDung(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/features/prerequisite_subjects/services/service_prequisite_subjects.dart',
        duLieu: "Lỗi PrerequisiteService.getPrerequisiteSubjects: $e",
      );
      return [];
    }
  }
}
