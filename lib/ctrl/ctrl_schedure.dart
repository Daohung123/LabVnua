import 'dart:convert';
import '../helper/helper_api_daotao.dart';
import '../model/schedure_Student.dart';

Future<TkbResponse?> ctrlTkb(String cookie, String token) async {
  try {
    ApiHelper api = ApiHelper.withSession(cookie, token);

    var res = await api.post("/sch/w-locdstkbtuanusertheohocky", {
      "filter": {"hoc_ky": 20252, "ten_hoc_ky": ""},
      "additional": {
        "paging": {"limit": 100, "page": 1},
        "ordering": [
          {"name": null, "order_type": null},
        ],
      },
    });

    /// debug response
    print("TYPE: ${res.runtimeType}");
    print("BODY: $res");

    /// nếu server trả HTML -> session lỗi
    if (res.toString().contains("<!DOCTYPE")) {
      print("API trả về HTML -> Cookie hoặc Token hết hạn");
      return null;
    }

    /// đảm bảo dữ liệu là Map
    Map<String, dynamic> jsonData = res is String ? jsonDecode(res) : res;

    return TkbResponse.fromJson(jsonData);
  } catch (e) {
    print("Lỗi lấy TKB: $e");
    return null;
  }
}
