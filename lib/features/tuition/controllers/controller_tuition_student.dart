import 'dart:developer';

import 'package:aqedu/features/tuition/models/model_data.dart';
import 'package:aqedu/features/tuition/models/model_item.dart';
import 'package:aqedu/features/tuition/services/service_tuition.dart';

class CtrlHocPhi {
  CtrlHocPhi._();

  static Future<CtrlHocPhi> create() async => CtrlHocPhi._();

  Future<Data?> getHocPhiData() async {
    try {
      return await HocPhiService.getHocPhiData();
    } catch (e) {
      log("Lỗi getHocPhiData: $e");
      return null;
    }
  }

  Future<List<HocPhiHocKy>> getHocPhiHocKyList() async {
    try {
      return await HocPhiService.getHocPhiHocKyList();
    } catch (e) {
      log("Lỗi getHocPhiHocKyList: $e");
      return [];
    }
  }
}
