import '../helper/helper_api_daotao.dart';
import '../model/infor_Student.dart/student_response.dart';

Future<StudentResponse?> ctrl_infor_Student(
  String? cookie,
  String? token,
) async {
  try {
    if (cookie == null || token == null) {
      print("Cookie hoặc token null");
      return null;
    }

    ApiHelper daotao = ApiHelper.withSession(cookie, token);

    final json = await daotao.post("/dkmh/w-locsinhvieninfo", {});

    StudentResponse studentResponse = StudentResponse.fromJson(json);

    return studentResponse;
  } catch (e) {
    print("Loi: $e");
    return null;
  }
}
