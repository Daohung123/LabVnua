import 'dart:io';

class MyHttpOverrides extends HttpOverrides {
  @override
  //giải quyết vấn đề cho phép truy cập api daotao
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}