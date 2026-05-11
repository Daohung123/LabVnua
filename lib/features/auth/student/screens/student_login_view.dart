import 'package:aqedu/features/home/home_screen/screens/student_home_screen_view.dart';
import 'package:flutter/material.dart';
import 'package:aqedu/features/auth/student/ctrls/ctrl_login_Student.dart';

// ─────────────────────────────────────────────
//  CONSTANTS
// ─────────────────────────────────────────────
class _AppColors {
  static const primary = Color(0xFF0047A8);
  static const primaryLight = Color(0xFF1A63C5);
  static const primaryDark = Color(0xFF003380);
  static const surface = Color(0xFFF5F8FF);
  static const white = Colors.white;
  static const textPrimary = Color(0xFF0D1B3E);
  static const textSecondary = Color(0xFF6B7A99);
  static const inputBorder = Color(0xFFDDE3F0);
  static const error = Color(0xFFD32F2F);
  static const success = Color(0xFF2E7D32);
}

// ─────────────────────────────────────────────
//  MAIN SCREEN
// ─────────────────────────────────────────────
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _emailError;
  String? _passwordError;

  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  // ── Validation ──────────────────────────────
  bool _validate() {
    bool valid = true;
    setState(() {
      _emailError = null;
      _passwordError = null;

      if (_emailController.text.trim().isEmpty) {
        _emailError = 'Vui lòng nhập mã sinh viên / giảng viên';
        valid = false;
      }
      if (_passwordController.text.trim().isEmpty) {
        _passwordError = 'Vui lòng nhập mật khẩu';
        valid = false;
      }
    });
    return valid;
  }

  // ── Login handler ────────────────────────────
  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();
    if (!_validate()) return;

    setState(() => _isLoading = true);

    try {
      final success = await ctrl_login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!mounted) return;

      if (success) {
        _showSnackBar('Đăng nhập thành công', isSuccess: true);
        await Future.delayed(const Duration(milliseconds: 400));
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
          (_) => false,
        );
      } else {
        _showSnackBar('Sai tài khoản hoặc mật khẩu', isSuccess: false);
      }
    } catch (_) {
      if (mounted)
        _showSnackBar('Đã xảy ra lỗi. Vui lòng thử lại.', isSuccess: false);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, {required bool isSuccess}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle_outline : Icons.error_outline,
              color: _AppColors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              message,
              style: const TextStyle(
                color: _AppColors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        backgroundColor: isSuccess ? _AppColors.success : _AppColors.error,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  BUILD
  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _AppColors.surface,
      body: Stack(
        children: [
          // ── Background decoration ──
          const _BackgroundDecoration(),

          // ── Scrollable content ──
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo + title
                        _LogoHeader(),

                        const SizedBox(height: 40),

                        // Login card
                        _LoginCard(
                          emailController: _emailController,
                          passwordController: _passwordController,
                          emailFocus: _emailFocus,
                          passwordFocus: _passwordFocus,
                          emailError: _emailError,
                          passwordError: _passwordError,
                          obscurePassword: _obscurePassword,
                          isLoading: _isLoading,
                          onTogglePassword: () {
                            setState(
                              () => _obscurePassword = !_obscurePassword,
                            );
                          },
                          onLogin: _handleLogin,
                        ),

                        const SizedBox(height: 32),

                        // Footer
                        const _FooterText(),
                      ],
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
}

// ─────────────────────────────────────────────
//  BACKGROUND DECORATION WIDGET
// ─────────────────────────────────────────────
class _BackgroundDecoration extends StatelessWidget {
  const _BackgroundDecoration();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        // Top blue wave
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: size.height * 0.38,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF003380),
                  Color(0xFF0047A8),
                  Color(0xFF1A63C5),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(48),
                bottomRight: Radius.circular(48),
              ),
            ),
          ),
        ),

        // Subtle circle accents
        Positioned(
          top: -30,
          right: -40,
          child: Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.06),
            ),
          ),
        ),
        Positioned(
          top: 60,
          left: -50,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.04),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  LOGO HEADER WIDGET
// ─────────────────────────────────────────────
class _LogoHeader extends StatelessWidget {
  const _LogoHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Logo container
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Container(
            width: 90,
            height: 90,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            clipBehavior: Clip.antiAlias,
            child: Image.asset('assets/logovnua.png', fit: BoxFit.contain),
          ),
        ),

        const SizedBox(height: 20),

        // University name
        const Text(
          'HỌC VIỆN NÔNG NGHIỆP',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: 2.0,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        const Text(
          'VIỆT NAM',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 3.5,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 8),

        Container(
          height: 2,
          width: 48,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(2),
          ),
        ),

        const SizedBox(height: 10),

        Text(
          'Vietnam National University of Agriculture',
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.75),
            letterSpacing: 0.3,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  LOGIN CARD WIDGET
// ─────────────────────────────────────────────
class _LoginCard extends StatelessWidget {
  const _LoginCard({
    required this.emailController,
    required this.passwordController,
    required this.emailFocus,
    required this.passwordFocus,
    required this.emailError,
    required this.passwordError,
    required this.obscurePassword,
    required this.isLoading,
    required this.onTogglePassword,
    required this.onLogin,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode emailFocus;
  final FocusNode passwordFocus;
  final String? emailError;
  final String? passwordError;
  final bool obscurePassword;
  final bool isLoading;
  final VoidCallback onTogglePassword;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: _AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _AppColors.primary.withOpacity(0.10),
            blurRadius: 32,
            offset: const Offset(0, 12),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          const Text(
            'Đăng nhập',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: _AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Nhập thông tin tài khoản của bạn',
            style: TextStyle(fontSize: 13, color: _AppColors.textSecondary),
          ),

          const SizedBox(height: 28),

          // Email field
          _ModernInputField(
            controller: emailController,
            focusNode: emailFocus,
            nextFocus: passwordFocus,
            hintText: 'Mã sinh viên / Giảng viên',
            labelText: 'Tài khoản',
            prefixIcon: Icons.person_outline_rounded,
            errorText: emailError,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),

          const SizedBox(height: 20),

          // Password field
          _ModernInputField(
            controller: passwordController,
            focusNode: passwordFocus,
            hintText: 'Nhập mật khẩu',
            labelText: 'Mật khẩu',
            prefixIcon: Icons.lock_outline_rounded,
            errorText: passwordError,
            obscureText: obscurePassword,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => onLogin(),
            suffixIcon: IconButton(
              onPressed: onTogglePassword,
              icon: Icon(
                obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: _AppColors.textSecondary,
                size: 20,
              ),
              splashRadius: 20,
            ),
          ),

          const SizedBox(height: 32),

          // Login button
          _LoginButton(isLoading: isLoading, onPressed: onLogin),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  MODERN INPUT FIELD WIDGET
// ─────────────────────────────────────────────
class _ModernInputField extends StatefulWidget {
  const _ModernInputField({
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.labelText,
    required this.prefixIcon,
    this.nextFocus,
    this.errorText,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.suffixIcon,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocus;
  final String hintText;
  final String labelText;
  final IconData prefixIcon;
  final String? errorText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Widget? suffixIcon;
  final ValueChanged<String>? onSubmitted;

  @override
  State<_ModernInputField> createState() => _ModernInputFieldState();
}

class _ModernInputFieldState extends State<_ModernInputField> {
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() => _hasFocus = widget.focusNode.hasFocus);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null;
    final borderColor = hasError
        ? _AppColors.error
        : _hasFocus
        ? _AppColors.primary
        : _AppColors.inputBorder;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          widget.labelText,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: _hasFocus ? _AppColors.primary : _AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),

        // Input
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: _hasFocus
                ? [
                    BoxShadow(
                      color: _AppColors.primary.withOpacity(0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            onSubmitted:
                widget.onSubmitted ??
                (widget.nextFocus != null
                    ? (_) => widget.nextFocus!.requestFocus()
                    : null),
            style: const TextStyle(
              fontSize: 15,
              color: _AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: _hasFocus
                  ? const Color(0xFFF0F5FF)
                  : const Color(0xFFF7F9FC),
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                color: _AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Icon(
                  widget.prefixIcon,
                  color: _hasFocus
                      ? _AppColors.primary
                      : _AppColors.textSecondary,
                  size: 20,
                ),
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 48,
                minHeight: 48,
              ),
              suffixIcon: widget.suffixIcon,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: borderColor, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: borderColor, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: _AppColors.error,
                  width: 1.5,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: _AppColors.error, width: 2),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        // Error message
        if (hasError) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.info_outline, size: 13, color: _AppColors.error),
              const SizedBox(width: 4),
              Text(
                widget.errorText!,
                style: const TextStyle(
                  fontSize: 12,
                  color: _AppColors.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  LOGIN BUTTON WIDGET
// ─────────────────────────────────────────────
class _LoginButton extends StatelessWidget {
  const _LoginButton({required this.isLoading, required this.onPressed});

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0047A8), Color(0xFF1A63C5)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: _AppColors.primary.withOpacity(0.40),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Đăng nhập',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  FOOTER WIDGET
// ─────────────────────────────────────────────
class _FooterText extends StatelessWidget {
  const _FooterText();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '© ${DateTime.now().year} Học Viện Nông Nghiệp Việt Nam',
          style: const TextStyle(fontSize: 12, color: _AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        const Text(
          'EduAI — Hệ thống quản lý học tập',
          style: TextStyle(fontSize: 11, color: Color(0xFFB0BAD0)),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
