import 'package:aqedu/core/screens/screen_loading.dart';
import 'package:aqedu/features/home/screens/student_home_screen_view.dart';
import 'package:aqedu/features/home/screens/student_home_view.dart';
import 'package:flutter/material.dart';
import './features/auth/screens/student_login_view.dart';
import './features/auth/screens/role_view.dart';
import './core/services/service_api_daotao.dart';

//Đây là gốc của toàn bộ UI
class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  bool? checkResult;
  @override
  void initState() {
    super.initState();
    check();
  }

  Future<void> check() async {
    bool result = await checkLogin();
    setState(() {
      checkResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (checkResult == null) {
      return const ScreenLoading();
    }
    if (checkResult == true)
      return HomeScreen();
    else
      return RoleView();
  }
}
