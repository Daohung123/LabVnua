import 'package:aqedu/core/logging/app_log.dart';
import 'package:aqedu/core/services_root/api_daotao/tuition/get_tuition.dart';
import 'package:aqedu/features/tuition/models/model_data.dart';
import 'package:aqedu/features/tuition/models/model_item.dart';
import 'package:aqedu/features/tuition/models/models_tuition.dart';

class HocPhiService {
  static Future<Data?> getHocPhiData(String cookie, String token) async {
    try {
      final HocPhiResponse? response = await getHocPhiResponse(cookie, token);

      if (response == null) {
        return null;
      }

      return response.data;
    } catch (e) {
      AppLog.ungDung(
        'Ghi nhận hoạt động runtime',
        khuVuc: 'lib/features/tuition/services/service_tuition.dart',
        duLieu: "Lỗi HocPhiService.getHocPhiData: $e",
      );
      return null;
    }
  }

  static Future<List<HocPhiHocKy>> getHocPhiHocKyList(
    String cookie,
    String token,
  ) async {
    try {
      final Data? data = await getHocPhiData(cookie, token);

      if (data == null) {
        return [];
      }

      final List<HocPhiHocKy> dsHocPhiHocKy = data.dsHocPhiHocKy;

      if (dsHocPhiHocKy.isEmpty) {
        return [];
      }

      return dsHocPhiHocKy;
    } catch (e) {
      AppLog.ungDung(
        'Ghi nhận hoạt động runtime',
        khuVuc: 'lib/features/tuition/services/service_tuition.dart',
        duLieu: "Lỗi HocPhiService.getHocPhiHocKyList: $e",
      );
      return [];
    }
  }
}
