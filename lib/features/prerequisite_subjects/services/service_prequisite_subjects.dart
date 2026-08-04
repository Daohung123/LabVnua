import 'package:aqedu/core/logging/app_log.dart';
import 'package:aqedu/core/database/portal_local_read_store.dart';
import '../models/model_prequisite_subjects.dart';

class PrerequisiteService {
  static Future<List<PrerequisiteSubject>> getPrerequisiteSubjects({
    int loaiTienQuyet = 1,
  }) async {
    try {
      final PrerequisiteResponse? response = await const PortalLocalReadStore()
          .prerequisiteSubjects(loaiTienQuyet);

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
