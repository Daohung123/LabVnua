import 'package:aqedu/core/database/portal_read_sync_coordinator.dart';
import 'package:aqedu/core/theme/app_theme.dart';
import 'package:aqedu/features/home/home_screen/screens/student_home_screen_view.dart';
import 'package:flutter/material.dart';

class PortalInitialSyncScreen extends StatefulWidget {
  const PortalInitialSyncScreen({super.key, this.coordinator});

  final PortalReadSyncCoordinator? coordinator;

  @override
  State<PortalInitialSyncScreen> createState() =>
      _PortalInitialSyncScreenState();
}

class _PortalInitialSyncScreenState extends State<PortalInitialSyncScreen> {
  late final PortalReadSyncCoordinator _coordinator =
      widget.coordinator ?? PortalReadSyncCoordinator();
  PortalSyncProgress? _progress;
  PortalSyncResult? _result;
  bool _running = false;

  @override
  void initState() {
    super.initState();
    _startSync();
  }

  Future<void> _startSync() async {
    if (_running) return;
    setState(() {
      _running = true;
      _result = null;
    });
    final result = await _coordinator.syncFull(
      onProgress: (progress) {
        if (!mounted) return;
        setState(() => _progress = progress);
      },
    );
    if (!mounted) return;
    if (result.isComplete) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
        (_) => false,
      );
      return;
    }
    setState(() {
      _running = false;
      _result = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = _progress;
    final failed = _result?.failedResources ?? const <String>[];
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(
                        Icons.sync_rounded,
                        size: 48,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'Đang chuẩn bị dữ liệu học tập',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        _running
                            ? 'Dữ liệu sẽ được lưu an toàn trên thiết bị trước khi bạn sử dụng ứng dụng.'
                            : 'Chưa thể hoàn tất đồng bộ. Hãy kiểm tra kết nối và thử lại.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.lg20),
                      if (_running) ...[
                        const Center(child: CircularProgressIndicator()),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          progress == null
                              ? 'Đang bắt đầu đồng bộ…'
                              : 'Đã lưu ${progress.completed}/${progress.total}: ${progress.resourceKey}',
                          textAlign: TextAlign.center,
                        ),
                      ] else ...[
                        if (failed.isNotEmpty)
                          Text(
                            'Chưa lưu được: ${failed.join(', ')}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        const SizedBox(height: AppSpacing.md),
                        FilledButton.icon(
                          onPressed: _startSync,
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('Thử lại đồng bộ'),
                        ),
                      ],
                    ],
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
