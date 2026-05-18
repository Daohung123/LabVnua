import 'dart:async';

import 'package:aqedu/features/chat/models/chat_message.dart';
import 'package:aqedu/features/chat/models/chat_user.dart';
import 'package:aqedu/features/chat/repository/chat_repository.dart';
import 'package:flutter/foundation.dart';

class ChatRoomController extends ChangeNotifier {
  ChatRoomController({
    required this.receiverStudentId,
    ChatRepository? chatRepository,
  }) : _chatRepository = chatRepository ?? ChatRepository();

  final String receiverStudentId;
  final ChatRepository _chatRepository;

  ChatUser? currentUser;
  ChatUser? receiverUser;
  String? conversationId;
  List<ChatMessage> messages = const [];
  bool isLoading = false;
  bool isSending = false;
  String? errorMessage;

  StreamSubscription<List<ChatMessage>>? _messagesSubscription;

  Future<void> init() async {
    if (isLoading || currentUser != null) return;

    _setLoading(true);
    try {
      currentUser ??= await _chatRepository.syncCurrentSessionUser();
      receiverUser = await _chatRepository.getUserByStudentId(receiverStudentId);
      receiverUser ??= await _chatRepository.ensureUserByStudentId(receiverStudentId);

      if (currentUser == null || receiverUser == null) {
        throw StateError('Chat user information is not available.');
      }

      conversationId = await _findConversationId();
      if (conversationId != null) {
        _subscribeMessages();
      }
      errorMessage = null;
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> sendMessage(String text) async {
    final trimmedText = text.trim();
    final activeUser = currentUser;
    final activeReceiver = receiverUser;

    if (trimmedText.isEmpty || activeUser == null || activeReceiver == null) {
      return;
    }

    isSending = true;
    notifyListeners();

    try {
      final conversationKey = conversationId ?? await _chatRepository.ensureConversationId(
        currentStudentId: activeUser.studentId,
        otherStudentId: activeReceiver.studentId,
        lastMessage: trimmedText,
        lastSenderId: activeUser.studentId,
      );
      conversationId = conversationKey;

      _messagesSubscription ??= _chatRepository
          .streamConversationMessages(conversationId: conversationKey)
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

      final sentMessage = await _chatRepository.sendMessage(
        conversationId: conversationKey,
        senderStudentId: activeUser.studentId,
        receiverStudentId: activeReceiver.studentId,
        message: trimmedText,
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
    return message.isSentBy(activeUser.studentId);
  }

  Future<void> _subscribeMessages() async {
    final activeUser = currentUser;
    final activeReceiver = receiverUser;
    final currentConversationId = conversationId;
    if (activeUser == null || activeReceiver == null || currentConversationId == null) return;

    _messagesSubscription?.cancel();
    _messagesSubscription = _chatRepository
        .streamConversationMessages(conversationId: currentConversationId)
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

  Future<String?> _findConversationId() async {
    final activeUser = currentUser;
    final activeReceiver = receiverUser;
    if (activeUser == null || activeReceiver == null) return null;

    return _chatRepository.getConversationId(
      currentStudentId: activeUser.studentId,
      otherStudentId: activeReceiver.studentId,
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
