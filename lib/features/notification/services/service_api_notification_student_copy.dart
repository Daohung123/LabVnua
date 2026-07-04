import 'package:aqedu/core/logging/app_log.dart';
import "package:aqedu/core/services_root/api_daotao/notification/get_notification.dart";
import "package:aqedu/core/services_root/sqlite/sessions/services_get_cookie_token.dart";

import "../models/notification_student.dart";

class ServiceNotiStudent {
  final String _cookie;
  final String _token;

  ServiceNotiStudent._(this._cookie, this._token);

  static Future<ServiceNotiStudent> create() async {
    final cookie = await GETDB.getCookie();
    final token = await GETDB.getToken();

    return ServiceNotiStudent._(cookie, token);
  }

  Future<List<NotificationItem>> getNotification() async {
    try {
      NotificationResponse? notificationResponse =
          await getNotificationResponse(_cookie, _token);
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
