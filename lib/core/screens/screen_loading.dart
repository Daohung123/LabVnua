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
  static const Color primarySoft = Color(0xFF2E6FD3);
  static const Color background = Color(0xFFFDFEFF);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          // ===== BACKGROUND =====
          const Positioned.fill(
            child: _BackgroundLayer(),
          ),

          // ===== FLOATING BLUR ORBS =====
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, __) {
                final t = Curves.easeInOut.transform(_controller.value);

                return Stack(
                  children: [
                    _BlurOrb(
                      size: 260,
                      top: -80 + (t * 20),
                      left: -70,
                      color: primary.withOpacity(.10),
                    ),
                    _BlurOrb(
                      size: 180,
                      right: -50,
                      top: size.height * .18,
                      color: primarySoft.withOpacity(.08),
                    ),
                    _BlurOrb(
                      size: 220,
                      bottom: -100,
                      left: size.width * .15,
                      color: primary.withOpacity(.06),
                    ),
                  ],
                );
              },
            ),
          ),

          // ===== CONTENT =====
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (_, __) {
                      final value =
                          Curves.easeInOut.transform(_controller.value);

                      return Transform.translate(
                        offset: Offset(0, -4 + (value * 8)),
                        child: _MainCard(
                          animationValue: value,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          // ===== BOTTOM TEXT =====
          Positioned(
            left: 0,
            right: 0,
            bottom: 24,
            child: SafeArea(
              top: false,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (_, __) {
                  return _BottomIndicator(
                    animationValue: _controller.value,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackgroundLayer extends StatelessWidget {
  const _BackgroundLayer();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFFFFF),
            Color(0xFFF7FAFF),
            Color(0xFFEDF4FF),
          ],
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF0047A8).withOpacity(.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BlurOrb extends StatelessWidget {
  const _BlurOrb({
    required this.size,
    required this.color,
    this.top,
    this.bottom,
    this.left,
    this.right,
  });

  final double size;
  final Color color;

  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
      ),
    );
  }
}

class _MainCard extends StatelessWidget {
  const _MainCard({
    required this.animationValue,
  });

  final double animationValue;

  static const Color primary = Color(0xFF0047A8);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(34),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 18,
          sigmaY: 18,
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(26, 28, 26, 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(34),
            border: Border.all(
              color: Colors.white.withOpacity(.9),
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(.92),
                Colors.white.withOpacity(.82),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: primary.withOpacity(.10),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _AnimatedLogo(
                animationValue: animationValue,
              ),

              const SizedBox(height: 24),

              const Text(
                'Đang khởi động hệ thống',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0D2B52),
                  letterSpacing: -.5,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Ứng dụng đang tải dữ liệu và tối ưu trải nghiệm dành cho bạn.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: 1.6,
                  fontSize: 14.5,
                  color: Color(0xFF60708A),
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 26),

              _ProgressSection(
                animationValue: animationValue,
              ),

              const SizedBox(height: 24),

              _FeatureRow(),

              const SizedBox(height: 24),

              _WaveLoading(
                animationValue: animationValue,
              ),

              const SizedBox(height: 18),

              Text(
                'EduAI',
                style: TextStyle(
                  color: primary.withOpacity(.75),
                  letterSpacing: 2,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedLogo extends StatelessWidget {
  const _AnimatedLogo({
    required this.animationValue,
  });

  final double animationValue;

  static const Color primary = Color(0xFF0047A8);

  @override
  Widget build(BuildContext context) {
    final scale = 1 + (animationValue * .06);

    return Transform.scale(
      scale: scale,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primary.withOpacity(.08),
            ),
          ),

          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF0047A8),
                  Color(0xFF2E6FD3),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: primary.withOpacity(.28),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: const Icon(
              Icons.school_rounded,
              color: Colors.white,
              size: 38,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressSection extends StatelessWidget {
  const _ProgressSection({
    required this.animationValue,
  });

  final double animationValue;

  static const Color primary = Color(0xFF0047A8);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFFF8FBFF),
        border: Border.all(
          color: primary.withOpacity(.08),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(primary),
                  backgroundColor: primary.withOpacity(.12),
                ),
              ),

              const SizedBox(width: 14),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Đang tải dữ liệu',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Color(0xFF17345E),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Vui lòng chờ trong giây lát...',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF74839A),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 8,
              value: .55 + (animationValue * .35),
              backgroundColor: primary.withOpacity(.08),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  _FeatureRow();

  final List<_FeatureItemData> items = [
    _FeatureItemData(
      Icons.bolt_rounded,
      'Nhanh',
    ),
    _FeatureItemData(
      Icons.security_rounded,
      'An toàn',
    ),
    _FeatureItemData(
      Icons.auto_awesome_rounded,
      'Hiện đại',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: items
          .map(
            (e) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _FeatureItem(data: e),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _FeatureItemData {
  final IconData icon;
  final String title;

  _FeatureItemData(this.icon, this.title);
}

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({
    required this.data,
  });

  final _FeatureItemData data;

  static const Color primary = Color(0xFF0047A8);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 14,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: primary.withOpacity(.05),
      ),
      child: Column(
        children: [
          Icon(
            data.icon,
            color: primary,
            size: 20,
          ),
          const SizedBox(height: 8),
          Text(
            data.title,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF365277),
            ),
          ),
        ],
      ),
    );
  }
}

class _WaveLoading extends StatelessWidget {
  const _WaveLoading({
    required this.animationValue,
  });

  final double animationValue;

  static const Color primary = Color(0xFF0047A8);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 18,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          5,
          (index) {
            final phase =
                ((animationValue + index * .15) % 1);

            final curve = Curves.easeInOut.transform(
              phase < .5
                  ? phase * 2
                  : (1 - phase) * 2,
            );

            return AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: 5,
              height: 6 + (curve * 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: primary.withOpacity(.25 + (curve * .75)),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _BottomIndicator extends StatelessWidget {
  const _BottomIndicator({
    required this.animationValue,
  });

  final double animationValue;

  static const Color primary = Color(0xFF0047A8);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3,
            (index) {
              final active =
                  ((animationValue * 3) + index) % 3 < 1;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin:
                    const EdgeInsets.symmetric(horizontal: 5),
                width: active ? 20 : 8,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: primary.withOpacity(
                    active ? .9 : .22,
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 12),

        const Text(
          'Chuẩn bị trải nghiệm học tập tốt nhất',
          style: TextStyle(
            fontSize: 12.5,
            color: Color(0xFF70819A),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}