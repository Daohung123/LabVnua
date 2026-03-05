import 'package:aqedu/env.dart';
import 'package:aqedu/helper/helper_widgets/Button/btn_Common.dart';
import 'package:aqedu/helper/helper_widgets/appBar/avt.dart';
import 'package:aqedu/helper/helper_widgets/appBar/name_user.dart';
import 'package:aqedu/helper/helper_widgets/appBar/notification.dart';
import 'package:aqedu/helper/helper_widgets/appBar/scan.dart';
import 'package:aqedu/helper/helper_widgets/appBar/time_fomat.dart';
import 'package:flutter/material.dart';
import 'package:aqedu/helper/helper_widgets/Button/btn_Common.dart';
import 'package:aqedu/helper/helper_widgets/Schedure/schedure.dart';
import 'package:aqedu/helper/helper_widgets/study_tool/study_tool.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff104492),
        toolbarHeight: 95,
        leadingWidth: 210,
        leading: Padding(
          padding: EdgeInsetsGeometry.all(5),
          child: Padding(
            padding: EdgeInsetsGeometry.all(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Avatar(),
                    Container(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NameUser(),
                        Text(
                          "Welcome back!",
                          style: TextStyle(color: Colors.white70, fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(height: 5),
                TimeFormat(
                  leading: const Icon(Icons.access_time, size: 18),
                  backgroundColor: Colors.white,
                  textStyle: TextStyle(fontSize: 10, color: Colors.black),
                ),
              ],
            ),
          ),
        ),
        title: Align(
          alignment: Alignment.topRight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [Noti(), Scan()],
              ),
              // SizedBox(
              //   height: 32,
              //   width: width_screen_percent(context, 8),
              //   child: btnCommon(
              //     text: "Thêm tiện ích",
              //     width_text: 8.5,
              //     onPressed: () {
              //       print('Them tien ich');
              //     },
              //     colors_background: Colors.white,
              //     colors_text: Colors.black,
              //   ),
              // ),
              SizedBox(height: 2.5),
            ],
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: bg_color,
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsetsGeometry.all(10),
              child: Column(
                children: [
                  Schedure(),
                  SizedBox(height: 10),
                  StudyTool(),
                ],
              )
            ),
          ),
        ),
      ),
    );
  }
}
