import 'package:aqedu/core/logging/app_log.dart';
import 'package:aqedu/core/database/portal_local_read_store.dart';

import "../models/notification_student.dart";

class ServiceNotiStudent {
  ServiceNotiStudent._();

  static Future<ServiceNotiStudent> create() async => ServiceNotiStudent._();

  Future<List<NotificationItem>> getNotification() async {
    try {
      NotificationResponse? notificationResponse =
          await const PortalLocalReadStore().notifications();
      if (notificationResponse == null) {
        AppLog.thongBao(
          'Ghi nhận hoạt động runtime',
          khuVuc:
              'lib/features/notification/services/service_api_notification_student_copy.dart',
          duLieu: "service_notification_error: null data",
        );
        return [];
      }

      NotificationData? notificationResponseData = notificationResponse.data;
      if (notificationResponseData == null) {
        AppLog.thongBao(
          'Ghi nhận hoạt động runtime',
          khuVuc:
              'lib/features/notification/services/service_api_notification_student_copy.dart',
          duLieu: "service_notification_error: null data",
        );
        return [];
      }

      List<NotificationItem>? list = notificationResponseData.dsThongBao;
      if (list == null) {
        AppLog.thongBao(
          'Ghi nhận hoạt động runtime',
          khuVuc:
              'lib/features/notification/services/service_api_notification_student_copy.dart',
          duLieu: "service_notification_error: null data",
        );
        return [];
      }
      return list;
    } catch (e) {
      AppLog.thongBao(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/features/notification/services/service_api_notification_student_copy.dart',
        duLieu: "service_notification_error: $e",
      );
      return [];
    }
  }
}
