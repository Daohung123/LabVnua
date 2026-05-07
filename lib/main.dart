import 'dart:io';
import 'package:aqedu/features/infor/screens/view_inforStudent.dart';
import 'package:aqedu/features/score_data/screens/view_score_student.dart';
import 'package:flutter/material.dart';
import './config/http_override.dart';
import 'app.dart';

// Khởi động app
// Init config
// Gọi runApp()

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp( MaterialApp( debugShowCheckedModeBanner: false,home: MyWidget()));
}

