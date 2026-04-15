import 'package:aqedu/core/services/service_api_daotao.dart';
import 'package:flutter/material.dart';

class ScreenLoading extends StatefulWidget {
  const ScreenLoading({super.key});

  @override
  State<ScreenLoading> createState() => _ScreenLoadingState();
}

class _ScreenLoadingState extends State<ScreenLoading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          
          SizedBox.expand(
            child: Image.asset(
              'assets/bg.png', 
              fit: BoxFit.cover,
            ),
          ),

          // 🌑 Overlay (làm tối ảnh cho đẹp)
          Container(color: Colors.black.withOpacity(0.4)),

          // 🔄 Loading ở giữa
          const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 4,
            ),
          ),
        ],
      ),
    );
    ;
  }
}
