import 'package:aqedu/features/schedure/models/Schedure_Student.dart';
import './service_api_daotao_post_get.dart';
import 'dart:convert';

Future<TkbResponse?> core_services_get_TkbResponse(
  String cookie,
  String token,
) async {
  try {
    final api = ApiHelper.withSession(cookie, token);

    final res = await api.post("/sch/w-locdstkbtuanusertheohocky", {
      "filter": {"hoc_ky": 20252, "ten_hoc_ky": ""},
      "additional": {
        "paging": {"limit": 100, "page": 1},
        "ordering": [
          {"name": null, "order_type": null},
        ],
      },
    });

    /// debug
    print("TYPE: ${res.runtimeType}");
    print("BODY: $res");

    /// ❌ HTML (hết session)
    if (res.toString().contains("<!DOCTYPE")) {
      print("Session hết hạn (HTML response)");
      return null;
    }

    /// parse json
    final jsonData = res is String
        ? jsonDecode(res)
        : res as Map<String, dynamic>;

    /// ❌ API báo lỗi
    if (jsonData["result"] == false) {
      print("API lỗi: ${jsonData["message"]}");

      /// 🔥 xử lý riêng expired
      if (jsonData["message"] == "expired") {
        print("Token hết hạn → cần login lại");
      }

      return null;
    }

    /// ❌ data null
    if (jsonData["data"] == null) {
      print("Data null");
      return null;
    }

    /// ✅ OK
    return TkbResponse.fromJson(jsonData);
  } catch (e) {
    print("Lỗi lấy TKB: $e");
    return null;
  }
}
