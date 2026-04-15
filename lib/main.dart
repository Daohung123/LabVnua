import 'dart:io';
import 'package:flutter/material.dart';
import 'package:aqedu/features/auth/screens/student_login_view.dart';
import './config/http_override.dart';
import 'app.dart';

// Khởi động app
// Init config
// Gọi runApp()

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp( MaterialApp(home: MyWidget()));
}

