import 'package:aqedu/core/theme/app_theme.dart';
import 'package:aqedu/features/chat/controllers/chat_room_controller.dart';
import 'package:aqedu/features/chat/widgets/chat_empty_state.dart';
import 'package:aqedu/features/chat/widgets/chat_message_bubble.dart';
import 'package:aqedu/features/chat/widgets/chat_message_input.dart';
import 'package:flutter/material.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key, required this.receiverStudentId});

  final String receiverStudentId;

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  late final ChatRoomController _controller;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = ChatRoomController(
      receiverStudentId: widget.receiverStudentId,
    )..init();
    _controller.addListener(_scheduleScrollToBottom);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_scheduleScrollToBottom)
      ..dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scheduleScrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final title =
                _controller.receiverUser?.studentId ?? widget.receiverStudentId;
            return Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w800),
            );
          },
        ),
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          if (_controller.isLoading && _controller.messages.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              if (_controller.errorMessage != null)
                _ErrorBanner(message: _controller.errorMessage!),
              Expanded(child: _buildMessageList()),
              if (_controller.receiverUser != null)
                ChatMessageInput(
                  isSending: _controller.isSending,
                  onSend: _controller.sendMessage,
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMessageList() {
    if (_controller.messages.isEmpty) {
      return const ChatEmptyState(
        icon: Icons.chat_bubble_outline_rounded,
        title: 'Chua co tin nhan',
        message: 'Gui tin nhan dau tien de bat dau cuoc tro chuyen.',
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 18),
      itemCount: _controller.messages.length,
      itemBuilder: (context, index) {
        final message = _controller.messages[index];
        return ChatMessageBubble(
          message: message,
          isMine: _controller.isMine(message),
        );
      },
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.errorLight,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12.5,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
