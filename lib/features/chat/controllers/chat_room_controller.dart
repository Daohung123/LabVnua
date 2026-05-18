import 'dart:async';

import 'package:aqedu/features/chat/models/chat_message.dart';
import 'package:aqedu/features/chat/models/chat_user.dart';
import 'package:aqedu/features/chat/services/chat_service.dart';
import 'package:aqedu/features/chat/services/chat_user_sync_service.dart';
import 'package:flutter/foundation.dart';

class ChatRoomController extends ChangeNotifier {
  ChatRoomController({
    required this.receiverStudentId,
    ChatService? chatService,
    ChatUserSyncService? userSyncService,
  }) : _chatService = chatService ?? ChatService(),
       _userSyncService = userSyncService ?? ChatUserSyncService();

  final String receiverStudentId;
  final ChatService _chatService;
  final ChatUserSyncService _userSyncService;

  ChatUser? currentUser;
  ChatUser? receiverUser;
  List<ChatMessage> messages = const [];
  bool isLoading = false;
  bool isSending = false;
  String? errorMessage;

  StreamSubscription<List<ChatMessage>>? _messagesSubscription;

  Future<void> init() async {
    if (isLoading || currentUser != null) return;

    _setLoading(true);
    try {
      currentUser = await _userSyncService.syncCurrentSessionUser();
      receiverUser = await _chatService.getUserByStudentId(receiverStudentId);

      if (receiverUser == null) {
        throw StateError('Student $receiverStudentId is not available on chat');
      }

      _subscribeMessages();
      errorMessage = null;
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> sendMessage(String text) async {
    final message = text.trim();
    final activeUser = currentUser;
    final activeReceiver = receiverUser;

    if (message.isEmpty || activeUser == null || activeReceiver == null) {
      return;
    }

    isSending = true;
    notifyListeners();

    try {
      final sentMessage = await _chatService.sendMessage(
        senderId: activeUser.id,
        receiverId: activeReceiver.id,
        message: message,
      );
      _upsertLocalMessage(sentMessage);
      errorMessage = null;
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      isSending = false;
      notifyListeners();
    }
  }

  bool isMine(ChatMessage message) {
    final activeUser = currentUser;
    if (activeUser == null) return false;
    return message.isSentBy(activeUser.id);
  }

  void _subscribeMessages() {
    final activeUser = currentUser;
    final activeReceiver = receiverUser;
    if (activeUser == null || activeReceiver == null) return;

    _messagesSubscription?.cancel();
    _messagesSubscription = _chatService
        .streamConversation(
          currentUserId: activeUser.id,
          otherUserId: activeReceiver.id,
        )
        .listen(
          (items) {
            messages = items;
            errorMessage = null;
            notifyListeners();
          },
          onError: (Object error) {
            errorMessage = error.toString();
            notifyListeners();
          },
        );
  }

  void _upsertLocalMessage(ChatMessage message) {
    final updatedMessages = [...messages];
    final index = updatedMessages.indexWhere(
      (item) => item.id.toString() == message.id.toString(),
    );

    if (index == -1) {
      updatedMessages.add(message);
    } else {
      updatedMessages[index] = message;
    }

    updatedMessages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    messages = List<ChatMessage>.unmodifiable(updatedMessages);
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _messagesSubscription?.cancel();
    super.dispose();
  }
}
