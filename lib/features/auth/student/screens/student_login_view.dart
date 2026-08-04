import 'package:aqedu/core/logging/app_log.dart';
import 'package:aqedu/core/theme/app_components.dart';
import 'package:aqedu/features/auth/student/controllers/ctrl_login_student.dart';
import 'package:aqedu/features/auth/student/screens/portal_initial_sync_screen.dart';
import 'package:flutter/material.dart';

/// Allows widget tests and alternate authentication providers to inject login.
typedef AuthLoginHandler =
    Future<bool> Function(String username, String password);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.loginHandler});

  final AuthLoginHandler? loginHandler;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
    AppLog.vongDoi('Màn hình đăng nhập được mở', khuVuc: 'Đăng nhập');
  }

  @override
  void dispose() {
    AppLog.vongDoi('Màn hình đăng nhập được đóng', khuVuc: 'Đăng nhập');
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  bool _validate() {
    var valid = true;

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

    if (!valid) {
      AppLog.thaoTacNguoiDung(
        'Người dùng gửi form đăng nhập chưa hợp lệ',
        khuVuc: 'Đăng nhập',
        duLieu: {
          'thieu_tai_khoan': _emailError != null,
          'thieu_mat_khau': _passwordError != null,
        },
        ketQua: 'Hiển thị lỗi nhập liệu trên form.',
      );
    }

    return valid;
  }

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();
    if (!_validate()) return;

    AppLog.thaoTacNguoiDung(
      'Người dùng bấm nút đăng nhập',
      khuVuc: 'Đăng nhập',
      duLieu: {'co_tai_khoan': _emailController.text.trim().isNotEmpty},
    );

    setState(() => _isLoading = true);

    try {
      final login = widget.loginHandler ?? ctrl_login;
      final success = await login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!mounted) return;

      if (success) {
        AppLog.thaoTacNguoiDung(
          'Đăng nhập từ màn hình đăng nhập thành công',
          khuVuc: 'Đăng nhập',
          ketQua: 'Chuẩn bị chuyển sang màn hình chính.',
        );
        _showSnackBar('Đăng nhập thành công', isSuccess: true);
        await Future<void>.delayed(const Duration(milliseconds: 400));
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute<void>(
            builder: (_) => const PortalInitialSyncScreen(),
          ),
          (_) => false,
        );
      } else {
        AppLog.thaoTacNguoiDung(
          'Đăng nhập từ màn hình đăng nhập không thành công',
          khuVuc: 'Đăng nhập',
          ketQua: 'Hiển thị thông báo sai tài khoản hoặc mật khẩu.',
        );
        _showSnackBar('Sai tài khoản hoặc mật khẩu', isSuccess: false);
      }
    } catch (error, stackTrace) {
      AppLog.loi(
        'Đăng nhập từ màn hình đăng nhập gặp lỗi',
        khuVuc: 'Đăng nhập',
        loi: error,
        stackTrace: stackTrace,
      );
      if (mounted) {
        _showSnackBar('Đã xảy ra lỗi. Vui lòng thử lại.', isSuccess: false);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, {required bool isSuccess}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                isSuccess ? Icons.check_circle_outline : Icons.error_outline,
                color: AppColors.white,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: isSuccess ? AppColors.success : AppColors.error,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.xxl,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: AutofillGroup(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _BrandHeader(),
                    const SizedBox(height: AppSpacing.xxl),
                    AppCard(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Đăng nhập',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Sử dụng tài khoản cổng thông tin đào tạo của bạn.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          OutlinedButton.icon(
                            key: const Key('vnied-login-disabled'),
                            onPressed: null,
                            icon: const Icon(Icons.account_balance_outlined),
                            label: const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Đăng nhập VNied'),
                                Text(
                                  'Chờ cấu hình OAuth2',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          const _SectionDivider(label: 'Hoặc dùng tài khoản'),
                          const SizedBox(height: AppSpacing.xl),
                          Text(
                            'Tài khoản',
                            style: theme.textTheme.labelLarge,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          TextField(
                            controller: _emailController,
                            focusNode: _emailFocus,
                            enabled: !_isLoading,
                            autofillHints: const [AutofillHints.username],
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            onChanged: (_) {
                              if (_emailError != null) {
                                setState(() => _emailError = null);
                              }
                            },
                            onSubmitted: (_) => _passwordFocus.requestFocus(),
                            decoration: InputDecoration(
                              hintText: 'Mã sinh viên / giảng viên',
                              errorText: _emailError,
                              prefixIcon: const Icon(Icons.person_outline),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Text(
                            'Mật khẩu',
                            style: theme.textTheme.labelLarge,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          TextField(
                            controller: _passwordController,
                            focusNode: _passwordFocus,
                            enabled: !_isLoading,
                            autofillHints: const [AutofillHints.password],
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.done,
                            onChanged: (_) {
                              if (_passwordError != null) {
                                setState(() => _passwordError = null);
                              }
                            },
                            onSubmitted: (_) => _handleLogin(),
                            decoration: InputDecoration(
                              hintText: 'Nhập mật khẩu',
                              errorText: _passwordError,
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                tooltip: _obscurePassword
                                    ? 'Hiện mật khẩu'
                                    : 'Ẩn mật khẩu',
                                onPressed: _isLoading
                                    ? null
                                    : () {
                                        AppLog.thaoTacNguoiDung(
                                          'Người dùng bật hoặc tắt hiển thị mật khẩu',
                                          khuVuc: 'Đăng nhập',
                                          duLieu: {
                                            'hien_mat_khau': !_obscurePassword,
                                          },
                                        );
                                        setState(
                                          () => _obscurePassword =
                                              !_obscurePassword,
                                        );
                                      },
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleLogin,
                              child: _isLoading
                                  ? const SizedBox.square(
                                      dimension: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.white,
                                      ),
                                    )
                                  : const Text('Đăng nhập'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    const _PrivacyNote(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          width: 76,
          height: 76,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.border),
            boxShadow: AppShadows.lightShadow,
          ),
          child: Image.asset(
            'assets/logovnua.png',
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => const Icon(
              Icons.school_outlined,
              color: AppColors.primary,
              size: 40,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Cổng thông tin đào tạo',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Học tập, dịch vụ và tiện ích sinh viên trong một ứng dụng.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}

class _PrivacyNote extends StatelessWidget {
  const _PrivacyNote();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.shield_outlined,
          size: 16,
          color: AppColors.textTertiary,
        ),
        const SizedBox(width: AppSpacing.sm),
        Flexible(
          child: Text(
            'Thông tin đăng nhập được sử dụng để xác thực với hệ thống đào tạo.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ),
      ],
    );
  }
}
