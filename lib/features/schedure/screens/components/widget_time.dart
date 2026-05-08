import 'package:aqedu/core/constants/UI/sizes/size_function.dart';
import 'package:aqedu/core/constants/UI/styles/colors.dart';
import 'package:aqedu/core/constants/features/schedure/schedure.dart';
import 'package:flutter/material.dart';

class WidgetTimeSchedure extends StatefulWidget {
  final String start_time;
  final String end_time;

  const WidgetTimeSchedure({super.key, required this.start_time , required this.end_time});

  @override
  State<WidgetTimeSchedure> createState() => _WidgetTimeSchedureState();
}

class _WidgetTimeSchedureState extends State<WidgetTimeSchedure> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width_screen_percent(context, 0.8),
      height: height_time_schedure,
      child: Padding(
        padding: EdgeInsetsGeometry.all(5),
        child: Column(
          spacing: 5,
          children: [
            Text(
              "Thời gian",
              style: TextStyle(
                color: time_schedure_color,
                fontSize: font_time_schedure,
              ),
            ),
            Text(
              widget.start_time,
              style: TextStyle(
                color: Colors.black,
                fontSize: font_time_schedure,
              ),
            ),
            Text(
              widget.end_time,
              style: TextStyle(
                color: Colors.black,
                fontSize: font_time_schedure,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
