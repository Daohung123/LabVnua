import 'package:app_settings/app_settings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NoWifiScreen extends StatefulWidget {
  const NoWifiScreen({super.key});

  @override
  State<NoWifiScreen> createState() => _NoWifiScreenState();
}

class _NoWifiScreenState extends State<NoWifiScreen>
    with TickerProviderStateMixin {
  bool _loading = false;

  // Animation controllers
  late final AnimationController _fadeController;
  late final AnimationController _slideController;
  late final AnimationController _pulseController;

  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _pulseAnim;
  late final Animation<double> _scaleAnim;

  // Brand colors
  static const Color _brandBlue = Color(0xFF0047A8);
  static const Color _brandBlueSoft = Color(0xFFE8F0FB);
  static const Color _brandBlueMid = Color(0xFFB3CAF0);
  static const Color _textPrimary = Color(0xFF0D1B2A);
  static const Color _textSecondary = Color(0xFF6B7A8D);

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);

    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.18), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _pulseAnim = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _scaleAnim = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
    );

    // Staggered entry
    Future.delayed(const Duration(milliseconds: 80), () {
      if (mounted) {
        _fadeController.forward();
        _slideController.forward();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _checkWifiAgain() async {
    setState(() => _loading = true);

    final result = await Connectivity().checkConnectivity();
    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;

    if (result.contains(ConnectivityResult.wifi)) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          backgroundColor: _textPrimary,
          content: const Row(
            children: [
              Icon(Icons.wifi_off_rounded, color: Colors.white70, size: 18),
              SizedBox(width: 10),
              Text(
                'WiFi vẫn chưa được bật',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (mounted) setState(() => _loading = false);
  }

  void _openWifiSettings() {
    AppSettings.openAppSettings(type: AppSettingsType.wifi);
  }

  void _dismiss() {
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isLargeScreen = size.width > 480;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ── Background gradient mesh ──────────────────────────────────
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFF0F5FF), Colors.white, Colors.white],
                  stops: [0.0, 0.45, 1.0],
                ),
              ),
            ),
          ),

          // ── Decorative circle top-left ────────────────────────────────
          Positioned(
            top: -60,
            left: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _brandBlueSoft.withOpacity(0.55),
              ),
            ),
          ),

          // ── Decorative circle bottom-right ────────────────────────────
          Positioned(
            bottom: -80,
            right: -50,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _brandBlueSoft.withOpacity(0.4),
              ),
            ),
          ),

          // ── Main content ──────────────────────────────────────────────
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: isLargeScreen ? 40 : 24,
                    vertical: 32,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: SlideTransition(
                      position: _slideAnim,
                      child: ScaleTransition(
                        scale: _scaleAnim,
                        child: _buildCard(context),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _brandBlue.withOpacity(0.08),
            blurRadius: 40,
            spreadRadius: 0,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Icon section ────────────────────────────────────────────
          _buildIconSection(),

          const SizedBox(height: 28),

          // ── Title ───────────────────────────────────────────────────
          const Text(
            'WiFi đang tắt',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: _textPrimary,
              letterSpacing: -0.4,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 10),

          // ── Description ─────────────────────────────────────────────
          const Text(
            'Vui lòng bật WiFi để tiếp tục\nsử dụng phần mềm.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: _textSecondary,
              height: 1.55,
              fontWeight: FontWeight.w400,
            ),
          ),

          const SizedBox(height: 36),

          // ── Status chip ─────────────────────────────────────────────
          _buildStatusChip(),

          const SizedBox(height: 32),

          // ── Primary button ──────────────────────────────────────────
          _buildPrimaryButton(),

          const SizedBox(height: 12),

          // ── Secondary button ────────────────────────────────────────
          _buildSecondaryButton(),

          const SizedBox(height: 8),

          // ── Dismiss text ────────────────────────────────────────────
          _buildDismissButton(),
        ],
      ),
    );
  }

  Widget _buildIconSection() {
    return ScaleTransition(
      scale: _pulseAnim,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer glow ring
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _brandBlueSoft,
            ),
          ),
          // Inner circle
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _brandBlue.withOpacity(0.12),
            ),
          ),
          // Icon
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: _brandBlue,
            ),
            child: const Icon(
              Icons.wifi_off_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3CD),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: const Color(0xFFFFD966).withOpacity(0.6),
          width: 1,
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 8, color: Color(0xFFE6A817)),
          SizedBox(width: 7),
          Text(
            'Không có kết nối mạng',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF8A6200),
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: _openWifiSettings,
        style: ElevatedButton.styleFrom(
          backgroundColor: _brandBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          overlayColor: Colors.white.withOpacity(0.15),
        ),
        icon: const Icon(Icons.wifi_rounded, size: 20),
        label: const Text(
          'Bật WiFi',
          style: TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: _loading ? null : _checkWifiAgain,
        style: OutlinedButton.styleFrom(
          foregroundColor: _brandBlue,
          side: BorderSide(
            color: _loading ? _brandBlueMid.withOpacity(0.4) : _brandBlueMid,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          overlayColor: _brandBlue.withOpacity(0.06),
        ),
        icon: _loading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  valueColor: AlwaysStoppedAnimation<Color>(_brandBlue),
                ),
              )
            : const Icon(Icons.refresh_rounded, size: 20),
        label: Text(
          _loading ? 'Đang kiểm tra...' : 'Kiểm tra lại',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ),
    );
  }

  Widget _buildDismissButton() {
    return TextButton(
      onPressed: _dismiss,
      style: TextButton.styleFrom(
        foregroundColor: _textSecondary,
        overlayColor: Colors.grey.withOpacity(0.08),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: const Text(
        'Để sau',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}
