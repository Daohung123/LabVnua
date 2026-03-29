import 'dart:async';
import 'package:flutter/material.dart';

// avt
String avt = 'assets/avt.jpg';

// Bo tron
double circle = 10;

//user name
String Lastname = "Đào";
String MiddleName = "Văn";
String FirstName = "Hùng";

//Color background
Color bg_color = Color(0xFFe9eaec);

//Size Screen with percent
double width_screen_percent(BuildContext context,double percent_Screen){
  double widthscreen = MediaQuery.of(context).size.width * percent_Screen;
  return widthscreen;
}

double height_screen_percent(BuildContext context,double percent_Screen){
  double heightscreen = MediaQuery.of(context).size.height * percent_Screen;
  return heightscreen;
}

//Schedure
const double width_time_schedure = 185;
const double height_time_schedure = 185;
const double width_detail_subject = 200;
const double height_detail_subject = 185;

// Widget detail_subject = DetailSubjectSchedure(nameSubject: "Lập trình mạng",room: "TT414",teacherName: "Trần Vũ Hà");
// Widget detail_subject2 = DetailSubjectSchedure(nameSubject: "Quản trị mạng",room: "ND302",teacherName: "Phạm Quang Dũng");

Color time_schedure_color = Color(0xFF838383);
double font_time_schedure = 13;
