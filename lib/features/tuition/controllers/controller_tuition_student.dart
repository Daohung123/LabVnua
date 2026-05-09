import 'dart:developer';

import 'package:aqedu/core/services_root/sqlite/sessions/services_get_cookie_token.dart';
import 'package:aqedu/features/tuition/models/model_data.dart';
import 'package:aqedu/features/tuition/models/model_item.dart';
import 'package:aqedu/features/tuition/services/service_tuition.dart';


class CtrlHocPhi {
  final String _cookie;
  final String _token;

  CtrlHocPhi._(this._cookie, this._token);

  static Future<CtrlHocPhi> create() async {
    final cookie = await GETDB.getCookie();
    final token = await GETDB.getToken();

    return CtrlHocPhi._(cookie, token);
  }

  Future<Data?> getHocPhiData() async {
    try {
      return await HocPhiService.getHocPhiData(
        _cookie,
        _token,
      );
    } catch (e) {
      log("Lỗi getHocPhiData: $e");
      return null;
    }
  }

  Future<List<HocPhiHocKy>> getHocPhiHocKyList() async {
    try {
      return await HocPhiService.getHocPhiHocKyList(
        _cookie,
        _token,
      );
    } catch (e) {
      log("Lỗi getHocPhiHocKyList: $e");
      return [];
    }
  }
}