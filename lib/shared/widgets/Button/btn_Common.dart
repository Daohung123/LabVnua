import 'package:flutter/material.dart';
import 'package:aqedu/config/env.dart';

Widget btnCommon({required String text,required double width_text, required VoidCallback onPressed, required Color colors_background, required Color colors_text}) {
  return ElevatedButton(
    onPressed: onPressed,
    child: Text(text,style: TextStyle(color: colors_text,fontSize: width_text)),
    style: ElevatedButton.styleFrom(
      backgroundColor: colors_background,
      foregroundColor: colors_text,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(circle)),
    ),
  );
}
