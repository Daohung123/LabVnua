import 'dart:async';
import 'dart:ui';

import 'package:aqedu/core/services_root/notification/notification_router.dart';
import 'package:flutter/material.dart';

import 'package:aqedu/core/theme/app_components.dart';
class InAppNotificationOverlay {
  InAppNotificationOverlay._();

  static OverlayEntry? _currentEntry;
  static Timer? _dismissTimer;

  static void show({
    required BuildContext context,
    required ChatNotificationPayload payload,
    required VoidCallback onTap,
  }) {
    _currentEntry?.remove();
    _dismissTimer?.cancel();

    final overlay = Overlay.of(context, rootOverlay: true);
    if (overlay == null) return;

    _currentEntry = OverlayEntry(
      builder: (context) {
        return _ChatNotificationBanner(
          payload: payload,
          onTap: () {
            onTap();
            dismiss();
          },
          onDismiss: dismiss,
        );
      },
    );

    overlay.insert(_currentEntry!);
    _dismissTimer = Timer(const Duration(seconds: 5), dismiss);
  }

  static void dismiss() {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    _currentEntry?.remove();
    _currentEntry = null;
  }
}

class _ChatNotificationBanner extends StatefulWidget {
  const _ChatNotificationBanner({
    required this.payload,
    required this.onTap,
    required this.onDismiss,
  });

  final ChatNotificationPayload payload;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  @override
  State<_ChatNotificationBanner> createState() => _ChatNotificationBannerState();
}

class _ChatNotificationBannerState extends State<_ChatNotificationBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 360),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));
    _opacityAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _opacityAnimation,
            child: GestureDetector(
              onTap: widget.onTap,
              onVerticalDragUpdate: (details) {
                if (details.delta.dy < -8) {
                  widget.onDismiss();
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        color: AppColors.white.withOpacity(0.88),
                        border: Border.all(
                          color: AppColors.white.withOpacity(0.40),
                          width: 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(0.14),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          _NotificationAvatar(url: widget.payload.senderAvatarUrl),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.payload.senderName,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  widget.payload.messagePreview,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.black87,
                                    height: 1.35,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Material(
                            color: AppColors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              onTap: widget.onDismiss,
                              child: const Padding(
                                padding: EdgeInsets.all(AppSpacing.sm),
                                child: Icon(Icons.close_rounded, size: 18, color: AppColors.black54),
                              ),
                            ),
                          )
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

class _NotificationAvatar extends StatelessWidget {
  const _NotificationAvatar({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final hasAvatar = url.trim().isNotEmpty;

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.ai],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipOval(
        child: hasAvatar
            ? Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (context, _, __) {
                  return const Center(
                    child: Icon(Icons.person, color: AppColors.white70, size: 26),
                  );
                },
              )
            : const Center(
                child: Icon(Icons.person, color: AppColors.white70, size: 26),
              ),
      ),
    );
  }
}
