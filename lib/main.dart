import 'package:aqedu/views/login_view.dart';
import 'package:aqedu/views/role_view.dart';
import 'package:flutter/material.dart';
import 'package:aqedu/http_override.dart';
import 'dart:io';
void main() async {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
