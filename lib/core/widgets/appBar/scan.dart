import 'package:flutter/material.dart';
class Scan extends StatefulWidget {
  const Scan({super.key});

  @override
  State<Scan> createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: (){print("scan");}, icon: Icon(Icons.qr_code_scanner_outlined), iconSize: 30,color: Colors.white,);
  }
}
