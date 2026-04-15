import 'dart:developer';
import 'package:aqedu/core/services/service_api_daotao.dart';
import 'package:aqedu/shared/services/cookie_token_services_shared.dart';
import '../models/Schedure_Student.dart';
import '../services/schedure_student_services.dart';

class CtrlSchedure {
  final String _cookie;
  final String _token;

  // private constructor
  CtrlSchedure._(this._cookie, this._token);

  // factory async để khởi tạo
  static Future<CtrlSchedure> create() async {
    final cookie = await GETDB.getCookie();
    final token = await GETDB.getToken();

    return CtrlSchedure._(cookie, token);
  }

  Future<List<ThoiKhoaBieu>> getTkbToday() async {
    try {
      TkbResponse? tkb =
          await core_services_get_TkbResponse(_cookie, _token);

      if (tkb == null) return [];

      return await TkbService.getSchedureInDay(
        await TkbService.getSchedureInWeek(tkb),
      );
    } catch (e) {
      log("Lỗi lấy TKB: $e");
      return [];
    }
  }

  Future<List<ThoiKhoaBieu>> getTkbInSemester() async{
    try{
      return await TkbService.getScheduleByDayInSemester(_cookie, _token);
    }
    catch(e){
      print(e);
      return [];
    }
  }
}
