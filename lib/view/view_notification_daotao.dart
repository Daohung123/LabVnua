import 'dart:io';

import '../model/Notification_from_Admin.dart';
import '../ctrl/ctrl_Notification_Daotao.dart';

Future<void> viewNotificationLog(String cookie, String token) async {
  final ctrlNoti = await ctrlGetNotifications(cookie, token);

  if (ctrlNoti == null) {
    print("Không lấy được danh sách thông báo!");
    return;
  }

  final response = ctrlNoti;

  print("========= DANH SÁCH THÔNG BÁO =========");

  final data = response.data;

  print("Total Items : ${data.totalItems}");
  print("Total Pages : ${data.totalPages}");
  print("Unread      : ${data.notification}");

  print("---------------------------------------");

  for (var tb in data.dsThongBao) {
    print("ID        : ${tb.id}");
    print("Tiêu đề   : ${tb.tieuDe}");
    print("Người gửi : ${tb.nguoiGui}");
    print("Ngày gửi  : ${tb.ngayGui}");
    print("Đã đọc    : ${tb.isDaDoc}");
    print("---------------------------------------");
  }
}
