import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:aqedu/core/theme/app_components.dart';

class QRScannerView extends StatefulWidget {
  const QRScannerView({super.key});

  @override
  State<QRScannerView> createState() => _QRScannerViewState();
}

class _QRScannerViewState extends State<QRScannerView>
    with TickerProviderStateMixin {
  late final MobileScannerController controller;

  late final AnimationController scanAnimationController;
  late final Animation<double> scanAnimation;

  bool isScanned = false;
  bool isTorchOn = false;
  bool isFrontCamera = false;

  String? lastCode;

  @override
  void initState() {
    super.initState();

    controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
    );

    scanAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    scanAnimation = Tween<double>(begin: -140, end: 140).animate(
      CurvedAnimation(parent: scanAnimationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    scanAnimationController.dispose();
    super.dispose();
  }

  Future<void> onDetect(BarcodeCapture capture) async {
    if (isScanned) return;

    final List<Barcode> barcodes = capture.barcodes;

    for (final barcode in barcodes) {
      final String? code = barcode.rawValue;

      if (code != null) {
        isScanned = true;

        setState(() {
          lastCode = code;
        });

        await controller.stop();

        if (!mounted) return;

        _showResultBottomSheet(code);

        break;
      }
    }
  }

  Future<void> _toggleTorch() async {
    await controller.toggleTorch();

    setState(() {
      isTorchOn = !isTorchOn;
    });
  }

  Future<void> _switchCamera() async {
    await controller.switchCamera();

    setState(() {
      isFrontCamera = !isFrontCamera;
    });
  }

  Future<void> _resumeScanner() async {
    isScanned = false;

    await controller.start();

    setState(() {});
  }

  void _showResultBottomSheet(String code) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return TweenAnimationBuilder(
          duration: AppAnimations.durationMedium,
          tween: Tween<double>(begin: 0.8, end: 1),
          curve: AppAnimations.easeOut,
          builder: (context, value, child) {
            return Transform.scale(scale: value, child: child);
          },
          child: Container(
            margin: const EdgeInsets.all(AppSpacing.lg),
            padding: const EdgeInsets.all(AppSpacing.lg20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              boxShadow: AppShadows.elevatedShadow,
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 70,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppGradients.heroGradient,
                      boxShadow: AppShadows.heroShadow,
                    ),
                    child: const Icon(
                      Icons.qr_code_2_rounded,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 24),

                  AppText.sectionTitle(
                    'Quét QR thành công',
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 10),

                  AppText.bodyMedium(
                    'Dữ liệu được đọc từ mã QR',
                    textAlign: TextAlign.center,
                    color: AppColors.textSecondary,
                  ),

                  const SizedBox(height: 20),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: SelectableText(
                      code,
                      style: AppTextStyles.bodyMedium.copyWith(
                        height: 1.6,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: AppButton.secondary(
                          label: 'Đóng',
                          icon: Icons.close_rounded,
                          onPressed: () async {
                            Navigator.pop(context);

                            await _resumeScanner();
                          },
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: AppButton.primary(
                          label: 'Quét tiếp',
                          icon: Icons.qr_code_scanner_rounded,
                          onPressed: () async {
                            Navigator.pop(context);

                            await _resumeScanner();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildScannerOverlay() {
    return Center(
      child: SizedBox(
        width: 280,
        height: 280,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.xl),
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),

            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.xl),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: Container(color: Colors.white.withOpacity(0.02)),
                ),
              ),
            ),

            AnimatedBuilder(
              animation: scanAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, scanAnimation.value),
                  child: child,
                );
              },
              child: Container(
                width: 240,
                height: 4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      AppColors.success,
                      Colors.transparent,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.success.withOpacity(0.6),
                      blurRadius: 12,
                    ),
                  ],
                ),
              ),
            ),

            Positioned(top: 0, left: 0, child: _buildCorner(true, true)),

            Positioned(top: 0, right: 0, child: _buildCorner(false, true)),

            Positioned(bottom: 0, left: 0, child: _buildCorner(true, false)),

            Positioned(bottom: 0, right: 0, child: _buildCorner(false, false)),
          ],
        ),
      ),
    );
  }

  Widget _buildCorner(bool left, bool top) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border(
          left: left
              ? BorderSide(color: AppColors.success, width: 5)
              : BorderSide.none,
          right: !left
              ? BorderSide(color: AppColors.success, width: 5)
              : BorderSide.none,
          top: top
              ? BorderSide(color: AppColors.success, width: 5)
              : BorderSide.none,
          bottom: !top
              ? BorderSide(color: AppColors.success, width: 5)
              : BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildTopHeader() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            AppIconButton.filled(
              icon: Icons.arrow_back_ios_new_rounded,
              backgroundColor: Colors.black.withOpacity(0.4),
              onPressed: () {
                Navigator.pop(context);
              },
            ),

            const Spacer(),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.qr_code_scanner_rounded,
                    color: Colors.white,
                    size: 18,
                  ),

                  const SizedBox(width: 8),

                  AppText.labelMedium('QR Scanner', color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.xxl),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(AppRadius.xxl),
                  border: Border.all(color: Colors.white.withOpacity(0.12)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText.sectionTitle(
                      'Đưa mã QR vào khung',
                      color: Colors.white,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 10),

                    AppText.bodySmall(
                      'Hệ thống sẽ tự động nhận diện mã QR',
                      color: Colors.white.withOpacity(0.75),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildControlButton(
                          icon: isTorchOn
                              ? Icons.flash_on_rounded
                              : Icons.flash_off_rounded,
                          label: 'Flash',
                          onTap: _toggleTorch,
                          active: isTorchOn,
                        ),

                        _buildControlButton(
                          icon: Icons.cameraswitch_rounded,
                          label: 'Camera',
                          onTap: _switchCamera,
                          active: isFrontCamera,
                        ),

                        _buildControlButton(
                          icon: Icons.refresh_rounded,
                          label: 'Reset',
                          onTap: _resumeScanner,
                          active: false,
                        ),
                      ],
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

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool active,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppAnimations.durationShort,
        curve: AppAnimations.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: active ? AppColors.primary : Colors.white.withOpacity(0.1),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 24),

            const SizedBox(height: 8),

            AppText.labelSmall(label, color: Colors.white),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(controller: controller, onDetect: onDetect),

          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.65),
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withOpacity(0.8),
                ],
              ),
            ),
          ),

          _buildTopHeader(),

          _buildScannerOverlay(),

          _buildBottomControls(),
        ],
      ),
    );
  }
}
