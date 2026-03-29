import 'dart:developer';
import 'package:aqedu/core/services/service_api_daotao.dart';
import 'package:aqedu/shared/services/cookie_token_services_shared.dart';
import '../models/Schedure_Student.dart';
import '../services/schedure_student_services.dart';

Future<List<ThoiKhoaBieu>> getTkbToday() async {
  try {
    String cookie = await GETDB.getCookie();
    String token = await GETDB.getToken();
    TkbResponse? tkb = await core_services_get_TkbResponse(cookie, token);
    if (tkb == null) return [];
    return TkbService.getSchedureByDay(tkb);
  } catch (e) {
    log("Lỗi lấy TKB: $e");
    return [];
  }
}

