import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_text_styles.dart';

/// ========================================
/// AI CHAT DIALOG - AI Assistant Chat Interface
/// ========================================
///
/// A simple chat dialog for user interactions with AI assistant.
/// Features:
/// - Message input field
/// - Message history display
/// - AI response suggestions (placeholder)
/// - Beautiful Material Design dialog
///
/// Usage:
/// ```
/// showDialog(
///   context: context,
///   builder: (context) => const AIChatDialog(),
/// )
/// ```

class AIChatDialog extends StatefulWidget {
  /// Title of the dialog
  final String title;

  /// Initial message to display
  final String? initialMessage;

  /// Callback when a message is sent
  final Function(String)? onMessageSent;

  const AIChatDialog({
    super.key,
    this.title = 'AI Assistant',
    this.initialMessage,
    this.onMessageSent,
  });

  @override
  State<AIChatDialog> createState() => _AIChatDialogState();
}

class _AIChatDialogState extends State<AIChatDialog> {
  /// Controller for message input field
  final _messageController = TextEditingController();

  /// List of chat messages
  final List<ChatMessage> _messages = [];

  /// Whether AI is currently responding
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Add initial welcome message
    _messages.add(
      ChatMessage(
        text:
            widget.initialMessage ??
            'Xin chào! 👋 Tôi là AI Assistant của bạn. Có gì tôi có thể giúp bạn?\n\n💡 Bạn có thể hỏi về:\n• Lịch học\n• Điểm số\n• Học phí\n• Thông tin khóa học',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  /// Send message to AI
  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    // Add user message
    setState(() {
      _messages.add(
        ChatMessage(text: text, isUser: true, timestamp: DateTime.now()),
      );
      _messageController.clear();
      _isLoading = true;
    });

    // Call callback if provided
    widget.onMessageSent?.call(text);

    // Simulate AI response
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _messages.add(
            ChatMessage(
              text: _generateAIResponse(text),
              isUser: false,
              timestamp: DateTime.now(),
            ),
          );
          _isLoading = false;
        });
      }
    });
  }

  /// Generate a simple AI response (placeholder)
  String _generateAIResponse(String userMessage) {
    final lower = userMessage.toLowerCase();

    if (lower.contains('lịch') || lower.contains('tkb')) {
      return '📅 Lịch học của bạn hôm nay:\n• 7:30 - 9:00: Toán\n• 9:15 - 10:45: Tiếng Anh\n• 13:00 - 14:30: Tin học\n\nBạn có muốn xem chi tiết?';
    } else if (lower.contains('điểm')) {
      return '📊 Điểm số gần đây:\n• Toán: 8.5/10\n• Tiếng Anh: 7.8/10\n• Tin học: 9.0/10\n\nĐiểm trung bình: 8.43';
    } else if (lower.contains('học phí')) {
      return '💳 Thông tin học phí:\n• Tổng học phí: 15,000,000 VNĐ\n• Đã thanh toán: 10,000,000 VNĐ\n• Còn lại: 5,000,000 VNĐ\n• Hạn thanh toán: 31/12/2026';
    } else if (lower.contains('thank') || lower.contains('cảm ơn')) {
      return 'Vui lòng giúp đỡ bạn! 😊 Có gì khác không?';
    } else {
      return 'Đó là một câu hỏi tuyệt vời! 🤔\n\nTôi vẫn đang học hỏi, nhưng bạn có thể:\n• Xem lịch học\n• Kiểm tra điểm\n• Tra cứu học phí\n\nBạn cần gì?';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // Shape with rounded corners
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      // Prevent dialog from being dismissible by tapping outside
      insetAnimationDuration: const Duration(milliseconds: 200),
      child: Container(
        // Set height and width constraints
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            // Divider
            Divider(height: 1, color: AppColors.border),
            // Messages list
            Expanded(child: _buildMessagesList()),
            // Divider
            Divider(height: 1, color: AppColors.border),
            // Input area
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  /// Build header section
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Title with icon
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title, style: AppTextStyles.sectionTitle),
                  Text(
                    'Online · Ready to help',
                    style: AppTextStyles.labelTiny,
                  ),
                ],
              ),
            ],
          ),
          // Close button
          IconButton(
            icon: const Icon(Icons.close),
            color: AppColors.textSecondary,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  /// Build messages list
  Widget _buildMessagesList() {
    return ListView.builder(
      padding: EdgeInsets.all(AppSpacing.lg),
      itemCount: _messages.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _messages.length) {
          // Loading indicator
          return Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.lg),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary.withOpacity(0.6),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'AI is thinking...',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        final message = _messages[index];
        return _buildMessageBubble(message);
      },
    );
  }

  /// Build individual message bubble
  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: AppSpacing.md),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.65,
        ),
        child: Text(
          message.text,
          style: AppTextStyles.bodySmall.copyWith(
            color: isUser ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  /// Build input area
  Widget _buildInputArea() {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          // Text input field
          Expanded(
            child: TextField(
              controller: _messageController,
              enabled: !_isLoading,
              decoration: InputDecoration(
                hintText: 'Ask me anything...',
                hintStyle: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textMuted,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                filled: true,
                fillColor: AppColors.background,
              ),
              onSubmitted: (_) => _sendMessage(),
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 8),
          // Send button
          Container(
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _isLoading ? null : _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}

/// ========================================
/// CHAT MESSAGE MODEL
/// ========================================

class ChatMessage {
  /// Message text
  final String text;

  /// Whether message is from user (true) or AI (false)
  final bool isUser;

  /// Timestamp of message
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
