import '../helper/helper_api_daotao.dart';
import '../model/Notification_from_Admin.dart';

Future<NotificationResponse?> ctrlGetNotifications(
  String cookie,
  String token,
) async {
  try {
    ApiHelper daotao = ApiHelper.withSession(cookie, token);

    final res = await daotao.post("/notify/w-locdsnhan", {
      "paging": {"limit": 10, "page": 1},
    });

    NotificationResponse notificationResponse = NotificationResponse.fromJson(
      res,
    );

    return notificationResponse;
  } catch (e) {
    print("Notification Error: $e");
    return null;
  }
}
