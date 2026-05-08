import 'package:aqedu/core/services_root/sqlite/sessions/services_get_cookie_token.dart';
import 'package:aqedu/features/infor/models/model_inforStudentFill.dart';
import 'package:aqedu/features/infor/services/services_inforStudent.dart';

class CtrlInforStudent {
  final String _cookie;
  final String _token;

  CtrlInforStudent._(this._cookie, this._token);

  static Future<CtrlInforStudent> create() async {
    final cookie = await GETDB.getCookie();
    final token = await GETDB.getToken();
    return CtrlInforStudent._(cookie, token);
  }
  Future<InforStudentFillData?> getInforStudent() async {
    try {
      final InforStudentFillData? dataNotifications =
          await ServiceInforStudent.getInforStudentFill(_cookie, _token);
      return dataNotifications;
    } catch (e) {
      return null;
    }
  }
}