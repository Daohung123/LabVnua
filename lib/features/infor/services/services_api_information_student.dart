import 'package:aqedu/core/logging/app_log.dart';
import 'package:aqedu/core/database/portal_local_read_store.dart';

import '../models/models_infor_student.dart';

class ServiceApiInforStudent {
  ServiceApiInforStudent._();

  static Future<ServiceApiInforStudent> create() async =>
      ServiceApiInforStudent._();

  Future<StudentData?> getStudentInformation() async {
    try {
      StudentResponse? response = await const PortalLocalReadStore()
          .studentProfile();

      if (response == null) {
        AppLog.ungDung(
          'Ghi nhận hoạt động runtime',
          khuVuc:
              'lib/features/infor/services/services_api_information_student.dart',
          duLieu: 'service_api_infor: response null',
        );
        return null;
      }
      final data = response.data;
      return data;
    } catch (e) {
      AppLog.ungDung(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/features/infor/services/services_api_information_student.dart',
        duLieu: 'service_api_infor_error: $e',
      );
      return null;
    }
  }
}
