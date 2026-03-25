import'package:flutter/material.dart';
import './features/auth/screens/student_login_view.dart';
import './features/auth/screens/role_view.dart';

//Đây là gốc của toàn bộ UI
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: RoleView(),
    );
  }
}