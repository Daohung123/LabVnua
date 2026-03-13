import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lab_dart_basic/view/view_study_price.dart';
//models
import './model/Cookie_Token.dart';

//helpers
import './helper/helper_api_daotao.dart';
import 'dart:io';
import 'ctrl/ctrl_infor.dart';

//views
import 'view/view_infor_student.dart';
import 'view/view_schedure.dart';
import './view/view_study_price.dart';
import './view/view_notification_daotao.dart';

void main() async {
  //Dang nhap
  print("Đang đăng nhập...");
  ApiHelper daotao = ApiHelper();
  SessionModel? sessionModel = await daotao.login("", "");
  String cookie = sessionModel!.cookie;
  String token = sessionModel!.token;
  int a = 1;
  //Dieu huong
  while (a != 0) {
    print("Menu điều hướng:");
    print("Xin mời chọn chức năng");
    print("0. Thoát");
    print("1. Hiển thị cookie");
    print("2. Hiển thị thông tin sinh viên");
    print("3. Hiển thị thời khóa biểu");
    print("4. Hiển thị học phí");
    print("5. Thông báo từ nhà quản trị");
    print("");
    int b = int.parse(stdin.readLineSync()!);
    a = b;
    switch (b) {
      case 1:
        print("Cookie nè: \n${sessionModel?.cookie}");
        print("\n\nToken nè: \n${sessionModel?.token}");
        break;
      case 2:
        await view_infor_student(cookie, token);
        break;
      case 3:
        await viewSchedure(cookie, token);
        break;
      case 4:
        await viewHocPhi(cookie, token);
        break;
      case 5:
        await viewNotificationLog(cookie, token);
        break;
    }
    print("\n");
  }
  print("Thoát luôn");
}
