import 'dart:ui';
import 'dart:math' as math;

import 'package:aqedu/core/theme/app_components.dart';
import 'package:aqedu/features/chat/controllers/chat_room_controller.dart';
import 'package:aqedu/features/chat/widgets/chat_message_bubble.dart';
import 'package:aqedu/features/chat/widgets/chat_message_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ============================================================
// CHAT ROOM SCREEN — Premium Messenger UI
// ============================================================

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({
    super.key,
    required this.receiverStudentId,
  });

  final String receiverStudentId;

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen>
    with TickerProviderStateMixin {
  late final ChatRoomController _controller;
  final ScrollController _scrollController = ScrollController();

  bool _showScrollToBottom = false;
  double _appBarOpacity = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = ChatRoomController(
      receiverStudentId: widget.receiverStudentId,
    )..init();
    _controller.addListener(_scheduleScrollToBottom);
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_scheduleScrollToBottom)
      ..dispose();
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  void _handleScroll() {
    final offset = _scrollController.offset;
    final max = _scrollController.position.maxScrollExtent;

    final show = offset < max - 300;
    if (show != _showScrollToBottom) {
      setState(() => _showScrollToBottom = show);
    }

    final opacity = (1.0 - (offset / 60).clamp(0.0, 0.15)).clamp(0.85, 1.0);
    if ((opacity - _appBarOpacity).abs() > 0.01) {
      setState(() => _appBarOpacity = opacity);
    }
  }

  void _scheduleScrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: AppAnimations.durationMedium,
        curve: Curves.easeOutCubic,
      );
    });
  }

  void _scrollToBottom() {
    HapticFeedback.lightImpact();
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: AppAnimations.durationMedium,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Layer 0 — Ambient background
          const _BackgroundDecorations(),

          // Layer 1 — Main content
          Column(
            children: [
              _ModernChatAppBar(
                receiverStudentId: widget.receiverStudentId,
                controller: _controller,
                opacity: _appBarOpacity,
              ),
              Expanded(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    if (_controller.isLoading &&
                        _controller.messages.isEmpty) {
                      return const _LoadingShimmer();
                    }
                    return Column(
                      children: [
                        if (_controller.errorMessage != null)
                          _ErrorBanner(message: _controller.errorMessage!),
                        Expanded(
                          child: _AnimatedMessageList(
                            controller: _controller,
                            scrollController: _scrollController,
                          ),
                        ),
                        if (_controller.receiverUser != null)
                          _PremiumInputBar(
                            isSending: _controller.isSending,
                            onSend: _controller.sendMessage,
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),

          // Layer 2 — Scroll to bottom FAB
          _ScrollToBottomFab(
            visible: _showScrollToBottom,
            onTap: _scrollToBottom,
          ),
        ],
      ),
    );
  }
}

// ============================================================
// BACKGROUND DECORATIONS
// ============================================================

class _BackgroundDecorations extends StatefulWidget {
  const _BackgroundDecorations();

  @override
  State<_BackgroundDecorations> createState() =>
      _BackgroundDecorationsState();
}

class _BackgroundDecorationsState extends State<_BackgroundDecorations>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
    _pulse = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, _) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xffEEF4FF), Color(0xffF5F8FC), Color(0xffF0F7FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              // Top-right ambient glow
              Positioned(
                top: -80,
                right: -60,
                child: _GlowCircle(
                  size: 280,
                  color: AppColors.primary,
                  opacity: 0.06 + (_pulse.value * 0.03),
                ),
              ),
              // Mid-left glow
              Positioned(
                top: 300,
                left: -100,
                child: _GlowCircle(
                  size: 220,
                  color: AppColors.primaryLight,
                  opacity: 0.04 + (_pulse.value * 0.02),
                ),
              ),
              // Bottom-right glow
              Positioned(
                bottom: 100,
                right: -60,
                child: _GlowCircle(
                  size: 200,
                  color: AppColors.primary,
                  opacity: 0.05 + (_pulse.value * 0.02),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GlowCircle extends StatelessWidget {
  const _GlowCircle({
    required this.size,
    required this.color,
    required this.opacity,
  });

  final double size;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(opacity),
      ),
    );
  }
}

// ============================================================
// MODERN CHAT APP BAR — Glassmorphism Floating AppBar
// ============================================================

class _ModernChatAppBar extends StatelessWidget {
  const _ModernChatAppBar({
    required this.receiverStudentId,
    required this.controller,
    required this.opacity,
  });

  final String receiverStudentId;
  final ChatRoomController controller;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return AnimatedOpacity(
      opacity: opacity,
      duration: AppAnimations.durationShort,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: EdgeInsets.only(
              top: topPadding + 10,
              left: 12,
              right: 12,
              bottom: 14,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.30),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, _) {
                final user = controller.receiverUser;
                return Row(
                  children: [
                    // Back button
                    _GlassButton(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Avatar with online indicator
                    Hero(
                      tag: 'chat-avatar-$receiverStudentId',
                      child: _AvatarWithStatus(
                        name: user?.fullName ?? 'U',
                        isOnline: true,
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Name & status
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            user?.fullName ?? 'Trò chuyện',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.1,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: AppColors.success,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.success.withOpacity(0.6),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                'Đang hoạt động',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withOpacity(0.85),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassButton extends StatefulWidget {
  const _GlassButton({required this.child, required this.onTap});

  final Widget child;
  final VoidCallback onTap;

  @override
  State<_GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<_GlassButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.92 : 1.0,
        duration: AppAnimations.durationExtraShort,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.18),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.25),
              width: 0.5,
            ),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

class _AvatarWithStatus extends StatelessWidget {
  const _AvatarWithStatus({required this.name, required this.isOnline});

  final String name;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              name.substring(0, 1).toUpperCase(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        if (isOnline)
          Positioned(
            right: 1,
            bottom: 1,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.success.withOpacity(0.5),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

// ============================================================
// ANIMATED MESSAGE LIST
// ============================================================

class _AnimatedMessageList extends StatelessWidget {
  const _AnimatedMessageList({
    required this.controller,
    required this.scrollController,
  });

  final ChatRoomController controller;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    if (controller.messages.isEmpty) {
      return const _EmptyState();
    }

    return ListView.builder(
      controller: scrollController,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      itemCount: controller.messages.length,
      itemBuilder: (context, index) {
        final message = controller.messages[index];
        final isMine = controller.isMine(message);
        final delay = math.min(index * 25, 300);

        return _AnimatedMessageItem(
          key: ValueKey(message.hashCode),
          delay: delay,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ChatMessageBubble(
              message: message,
              isMine: isMine,
            ),
          ),
        );
      },
    );
  }
}

class _AnimatedMessageItem extends StatefulWidget {
  const _AnimatedMessageItem({
    super.key,
    required this.delay,
    required this.child,
  });

  final int delay;
  final Widget child;

  @override
  State<_AnimatedMessageItem> createState() => _AnimatedMessageItemState();
}

class _AnimatedMessageItemState extends State<_AnimatedMessageItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );

    _opacity = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    _scale = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic),
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: ScaleTransition(
          scale: _scale,
          alignment: Alignment.bottomCenter,
          child: widget.child,
        ),
      ),
    );
  }
}

// ============================================================
// PREMIUM INPUT BAR — Floating Glassmorphism
// ============================================================

class _PremiumInputBar extends StatefulWidget {
  const _PremiumInputBar({
    required this.isSending,
    required this.onSend,
  });

  final bool isSending;
  final void Function(String) onSend;

  @override
  State<_PremiumInputBar> createState() => _PremiumInputBarState();
}

class _PremiumInputBarState extends State<_PremiumInputBar>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textCtrl = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool _hasText = false;
  late final AnimationController _sendBtnCtrl;
  late final Animation<double> _sendBtnAnim;

  @override
  void initState() {
    super.initState();
    _sendBtnCtrl = AnimationController(
      vsync: this,
      duration: AppAnimations.durationShort,
    );
    _sendBtnAnim = CurvedAnimation(
      parent: _sendBtnCtrl,
      curve: Curves.elasticOut,
    );
    _textCtrl.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    _focusNode.dispose();
    _sendBtnCtrl.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _textCtrl.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
      if (hasText) {
        _sendBtnCtrl.forward();
      } else {
        _sendBtnCtrl.reverse();
      }
    }
  }

  void _send() {
    final text = _textCtrl.text.trim();
    if (text.isEmpty) return;
    HapticFeedback.lightImpact();
    widget.onSend(text);
    _textCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: EdgeInsets.only(
            left: 12,
            right: 12,
            top: 10,
            bottom: bottom + 10,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.82),
            border: Border(
              top: BorderSide(
                color: AppColors.border.withOpacity(0.5),
                width: 0.5,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.06),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Text input
              Expanded(
                child: AnimatedContainer(
                  duration: AppAnimations.durationShort,
                  curve: Curves.easeOutCubic,
                  decoration: BoxDecoration(
                    color: _hasText
                        ? AppColors.primary.withOpacity(0.04)
                        : AppColors.background,
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    border: Border.all(
                      color: _hasText
                          ? AppColors.primary.withOpacity(0.25)
                          : AppColors.border,
                      width: _hasText ? 1.2 : 0.8,
                    ),
                  ),
                  child: TextField(
                    controller: _textCtrl,
                    focusNode: _focusNode,
                    maxLines: 5,
                    minLines: 1,
                    textCapitalization: TextCapitalization.sentences,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                      height: 1.45,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Nhắn tin...',
                      hintStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textMuted.withOpacity(0.7),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 11,
                      ),
                    ),
                    onSubmitted: (_) => _send(),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Send button
              ScaleTransition(
                scale: _sendBtnAnim,
                child: _SendButton(
                  isSending: widget.isSending,
                  hasText: _hasText,
                  onTap: _send,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SendButton extends StatefulWidget {
  const _SendButton({
    required this.isSending,
    required this.hasText,
    required this.onTap,
  });

  final bool isSending;
  final bool hasText;
  final VoidCallback onTap;

  @override
  State<_SendButton> createState() => _SendButtonState();
}

class _SendButtonState extends State<_SendButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.hasText && !widget.isSending ? widget.onTap : null,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.88 : 1.0,
        duration: AppAnimations.durationExtraShort,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: widget.hasText
                ? const LinearGradient(
                    colors: [AppColors.primaryLight, AppColors.primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : LinearGradient(
                    colors: [
                      AppColors.border,
                      AppColors.border.withOpacity(0.8),
                    ],
                  ),
            shape: BoxShape.circle,
            boxShadow: widget.hasText
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: widget.isSending
              ? const Padding(
                  padding: EdgeInsets.all(12),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                )
              : const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 20,
                ),
        ),
      ),
    );
  }
}

// ============================================================
// SCROLL TO BOTTOM FAB
// ============================================================

class _ScrollToBottomFab extends StatelessWidget {
  const _ScrollToBottomFab({
    required this.visible,
    required this.onTap,
  });

  final bool visible;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;

    return Positioned(
      right: 16,
      bottom: bottom + 78,
      child: AnimatedScale(
        scale: visible ? 1.0 : 0.0,
        duration: AppAnimations.durationShort,
        curve: Curves.elasticOut,
        child: AnimatedOpacity(
          opacity: visible ? 1.0 : 0.0,
          duration: AppAnimations.durationShort,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.20),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: AppColors.border,
                  width: 0.8,
                ),
              ),
              child: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.primary,
                size: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// EMPTY STATE
// ============================================================

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              gradient: AppGradients.heroGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chat_bubble_outline_rounded,
              color: Colors.white,
              size: 36,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Chưa có tin nhắn',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Hãy bắt đầu cuộc trò chuyện ngay bây giờ.',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ============================================================
// LOADING SHIMMER
// ============================================================

class _LoadingShimmer extends StatefulWidget {
  const _LoadingShimmer();

  @override
  State<_LoadingShimmer> createState() => _LoadingShimmerState();
}

class _LoadingShimmerState extends State<_LoadingShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) {
        final opacity = 0.04 + (_anim.value * 0.06);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            children: [
              _ShimmerBubble(
                isMine: false,
                width: 200,
                opacity: opacity,
              ),
              const SizedBox(height: 10),
              _ShimmerBubble(
                isMine: true,
                width: 160,
                opacity: opacity,
              ),
              const SizedBox(height: 10),
              _ShimmerBubble(
                isMine: false,
                width: 240,
                opacity: opacity,
              ),
              const SizedBox(height: 10),
              _ShimmerBubble(
                isMine: true,
                width: 180,
                opacity: opacity,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ShimmerBubble extends StatelessWidget {
  const _ShimmerBubble({
    required this.isMine,
    required this.width,
    required this.opacity,
  });

  final bool isMine;
  final double width;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: width,
        height: 44,
        decoration: BoxDecoration(
          color: isMine
              ? AppColors.primary.withOpacity(opacity * 1.5)
              : Colors.black.withOpacity(opacity),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(AppRadius.lg),
            topRight: const Radius.circular(AppRadius.lg),
            bottomLeft: Radius.circular(isMine ? AppRadius.lg : 4),
            bottomRight: Radius.circular(isMine ? 4 : AppRadius.lg),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// ERROR BANNER
// ============================================================

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.errorLight,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: AppColors.error.withOpacity(0.3),
            width: 0.8,
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.error,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.error,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}