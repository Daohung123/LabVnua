import '../model/study_price.dart';
import '../helper/helper_api_daotao.dart';

Future<HocPhiResponse?> ctrlStudyPrice(String cookie, String token) async {
  try {
    //goi api
    ApiHelper daotao = ApiHelper.withSession(cookie, token);
    final res = await daotao.post("/rms/w-locdstonghophocphisv", {});
    HocPhiResponse hocPhiResponse = HocPhiResponse.fromJson(res);
    return hocPhiResponse;
  } catch (e) {
    print("error: $e");
    return null;
  }
}
