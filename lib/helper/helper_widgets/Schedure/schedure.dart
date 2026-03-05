import 'package:aqedu/env.dart';
import 'package:aqedu/helper/helper_widgets/Container_mod/Container_mod1.dart';
import 'package:aqedu/helper/helper_widgets/Text/text_common.dart';
import 'package:flutter/material.dart';

class Schedure extends StatefulWidget {
  const Schedure({super.key});

  @override
  State<Schedure> createState() => _SchedureState();
}

class _SchedureState extends State<Schedure> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width_screen_percent(context, 85),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(circle),
      ),
      child: Padding(
        padding: EdgeInsetsGeometry.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children: [
            TextCommon(txt: "Thời khóa biểu"),
            Container(
              width: width_screen_percent(context, 90),
              height: width_time_schedure * 1.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(circle),
                color: bg_color,
              ),
              child: Padding(
                padding: EdgeInsetsGeometry.all(10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //Thoi gian
                      ContainerMod1(
                        my_child: time_schedure,
                        my_width: width_time_schedure,
                        my_heigth: height_time_schedure,
                      ),

                      //Chi tiet mon hoc
                      Padding(
                        padding: EdgeInsetsGeometry.all(5),
                        child: detail_subject,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: width_screen_percent(context, 90),
              height: width_time_schedure * 1.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(circle),
                color: bg_color,
              ),
              child: Padding(
                padding: EdgeInsetsGeometry.all(10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //Thoi gian
                      ContainerMod1(
                        my_child: time_schedure2,
                        my_width: width_time_schedure,
                        my_heigth: height_time_schedure,
                      ),

                      //Chi tiet mon hoc
                      Padding(
                        padding: EdgeInsetsGeometry.all(5),
                        child: detail_subject2,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
