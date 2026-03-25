import 'package:flutter/material.dart';
class TextCommon extends StatefulWidget {
  final String txt;
  const TextCommon({super.key,required this.txt});

  @override
  State<TextCommon> createState() => _TextCommonState();
}

class _TextCommonState extends State<TextCommon> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.txt, style: TextStyle(
      color: Color(0xFF104492),
      fontSize: 15,
      fontWeight: FontWeight.bold,
    ),);
  }
}
