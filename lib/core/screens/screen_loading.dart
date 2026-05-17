import 'dart:ui';
import 'package:flutter/material.dart';

class ScreenLoading extends StatefulWidget {
  const ScreenLoading({super.key});

  @override
  State<ScreenLoading> createState() => _ScreenLoadingState();
}

class _ScreenLoadingState extends State<ScreenLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const Color primary = Color(0xFF0047A8);
  static const Color background = Color(0xFFFDFEFF);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView( // Tránh lỗi Overflow
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo đơn giản hơn để giảm tải GPU
                  Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: primary,
                    ),
                    child: const Icon(Icons.school_rounded, color: Colors.white, size: 50),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Đang khởi động hệ thống',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D2B52),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Ứng dụng đang tải dữ liệu và tối ưu trải nghiệm dành cho bạn.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 40),
                  const CircularProgressIndicator(color: primary),
                  const SizedBox(height: 20),
                  const Text('Vui lòng chờ trong giây lát...', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
