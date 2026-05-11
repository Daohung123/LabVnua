import 'dart:ui';
import 'package:flutter/material.dart';

class DevelopingView extends StatefulWidget {
  const DevelopingView({Key? key}) : super(key: key);

  @override
  State<DevelopingView> createState() => _DevelopingViewState();
}

class _DevelopingViewState extends State<DevelopingView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _floatAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Khởi tạo AnimationController với thời gian 2 giây, lặp lại liên tục và đảo ngược
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Hiệu ứng lơ lửng (lên xuống)
    _floatAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -0.08),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Hiệu ứng nhịp thở (to nhỏ nhẹ nhàng)
    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // 1. Background Gradient hiện đại
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2E3192), // Xanh đậm
              Color(0xFF1BFFFF), // Cyan sáng
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SlideTransition(
              position: _floatAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                // 2. Hiệu ứng Glassmorphism (Kính mờ)
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 30,
                            spreadRadius: 5,
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 3. Icon thay thế cho ảnh
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.rocket_launch_rounded,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 30),
                          
                          // 4. Tiêu đề
                          const Text(
                            "Coming Soon",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // 5. Lời nhắn chân thành
                          Text(
                            "Dev đang uống cà phê và nỗ lực gõ phím để hoàn thiện chức năng này.\nMong bạn thông cảm nhé!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.5,
                              color: Colors.white.withOpacity(0.85),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 35),
                          
                          // 6. Custom Animated Loading Dots
                          const CustomBouncingDots(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget Custom: Hiệu ứng 3 dấu chấm nhảy múa mượt mà
class CustomBouncingDots extends StatefulWidget {
  const CustomBouncingDots({Key? key}) : super(key: key);

  @override
  State<CustomBouncingDots> createState() => _CustomBouncingDotsState();
}

class _CustomBouncingDotsState extends State<CustomBouncingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDot(int index) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Tính toán độ trễ cho từng dấu chấm để tạo hiệu ứng lượn sóng
        final double offset = (index * 0.2);
        final double value = (_controller.value + offset) % 1.0;
        
        // Dùng hàm sin để tạo đường cong mượt mà lên xuống
        final double dy = 10 * (0.5 - (0.5 - value).abs());

        return Transform.translate(
          offset: Offset(0, -dy * 2), // Nhân 2 để biên độ nhảy cao hơn một chút
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.5),
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) => _buildDot(index)),
    );
  }
}