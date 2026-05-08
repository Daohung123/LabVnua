import "package:aqedu/features/notification/services/service_noti_student.dart";

import "../models/notification_student.dart";

class CtrlNotiStudent {
  final String _cookie;
  final String _token;

  CtrlNotiStudent(this._cookie, this._token);

  Future<List<NotificationItem>> getNotification() async {
    try {
      final List<NotificationItem> dataNotifications =
          await ServiceNotiStudent.getNotification(_cookie, _token);

      return dataNotifications;
    } catch (e) {
      return [];
    }
  }
}
