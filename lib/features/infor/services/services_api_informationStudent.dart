import 'package:aqedu/core/services_root/api_daotao/information_Student/getInformation.dart';
import 'package:aqedu/core/services_root/sqlite/sessions/services_get_cookie_token.dart';

import '../models/models_inforStudent.dart';
import '../models/model_inforStudentFill.dart';

class ServiceApiInforStudent {
  final String _cookie;
  final String _token;

  ServiceApiInforStudent._(this._cookie, this._token);

  static Future<ServiceApiInforStudent> create() async {
    final cookie = await GETDB.getCookie();
    final token = await GETDB.getToken();
    return ServiceApiInforStudent._(cookie, token);
  }


  Future<StudentData?> getStudentInformation() async {
    try {
      StudentResponse? response = await getInformationResponse(_cookie, _token);
      
      if (response == null) {
        print('service_api_infor: response null');
        return null;
      }
      print("API infor student response: $response.data");

      final data = response.data;
      if (data == null) {
        print('service_api_infor: data null');
        return null;
      }

      return data;
    } catch (e) {
      print('service_api_infor_error: $e');
      return null;
    }
  }

}
