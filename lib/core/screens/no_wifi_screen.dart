import 'package:app_settings/app_settings.dart';
import 'package:aqedu/core/theme/app_components.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NoWifiScreen extends StatefulWidget {
  const NoWifiScreen({super.key});

  @override
  State<NoWifiScreen> createState() => _NoWifiScreenState();
}

class _NoWifiScreenState extends State<NoWifiScreen> {
  bool _loading = false;

  Future<void> _checkWifiAgain() async {
    if (_loading) return;
    setState(() => _loading = true);

    final result = await Connectivity().checkConnectivity();
    if (!mounted) return;

    final connected = !result.contains(ConnectivityResult.none);
    setState(() => _loading = false);

    if (connected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã kết nối mạng. Vui lòng mở lại dữ liệu.')),
      );
      Navigator.of(context).maybePop(true);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Thiết bị vẫn chưa có kết nối mạng.'),
      ),
    );
  }

  void _openWifiSettings() {
    AppSettings.openAppSettings(type: AppSettingsType.wifi);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Kết nối mạng'),
        actions: [
          IconButton(
            tooltip: 'Đóng ứng dụng',
            onPressed: () => SystemNavigator.pop(),
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppSpacing.screenPadding,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: AppCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primarySoft,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                      child: const Icon(
                        Icons.wifi_off_rounded,
                        size: 32,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg20),
                    Text(
                      'Không có kết nối mạng',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Hãy bật Wi-Fi hoặc dữ liệu di động để đồng bộ thông tin mới nhất. Dữ liệu đã lưu vẫn có thể được sử dụng khi hệ thống hỗ trợ.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    AppButton.block(
                      label: 'Mở cài đặt Wi-Fi',
                      icon: Icons.settings_rounded,
                      onPressed: _openWifiSettings,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _loading ? null : _checkWifiAgain,
                        icon: _loading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.refresh_rounded),
                        label: Text(
                          _loading ? 'Đang kiểm tra…' : 'Kiểm tra lại',
                        ),
                      ),
                    ),
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
