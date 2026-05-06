import "package:aqedu/core/services_root/api_daotao/notification/getNotification.dart";

import "../models/notification_student.dart";

class ServiceNotiStudent {
  static Future<List<NotificationItem>> getNotification(
    String cookie,
    String token,
  ) async {
    try {
      NotificationResponse? notificationResponse =
          await getNotificationResponse(cookie, token);
      if (notificationResponse == null) {
        print("service_notification_error: null data");
        return [];
      }

      NotificationData? notificationResponseData = notificationResponse.data;
      if (notificationResponseData == null) {
        print("service_notification_error: null data");
        return [];
      }

      List<NotificationItem>? list = notificationResponseData.dsThongBao;
      if (list == null) {
        print("service_notification_error: null data");
        return [];
      }
      return list;
    } catch (e) {
      print("service_notification_error: ${e}");
      return [];
    }
  }
}
