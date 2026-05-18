import 'dart:async';

import 'package:aqedu/features/chat/models/chat_thread.dart';
import 'package:aqedu/features/chat/models/chat_user.dart';
import 'package:aqedu/features/chat/repository/chat_repository.dart';
import 'package:flutter/foundation.dart';

class ChatListController extends ChangeNotifier {
  ChatListController({
    ChatRepository? chatRepository,
  }) : _chatRepository = chatRepository ?? ChatRepository();

  final ChatRepository _chatRepository;

  ChatUser? currentUser;
  List<ChatThread> threads = const [];
  List<ChatUser> searchResults = const [];
  bool isLoading = false;
  bool isSearching = false;
  String? errorMessage;

  StreamSubscription<List<ChatThread>>? _threadsSubscription;
  Timer? _searchDebounce;
  int _searchVersion = 0;

  Future<void> init() async {
    if (isLoading || currentUser != null) return;

    _setLoading(true);
    try {
      currentUser = await _chatRepository.syncCurrentSessionUser();
      _subscribeThreads();
      errorMessage = null;
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> searchUsers(String keyword) async {
    final query = keyword.trim();
    final version = ++_searchVersion;
    _searchDebounce?.cancel();

    if (query.isEmpty) {
      searchResults = const [];
      isSearching = false;
      notifyListeners();
      return;
    }

    isSearching = true;
    notifyListeners();

    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      unawaited(_runSearch(query: query, version: version));
    });
  }

  Future<void> _runSearch({required String query, required int version}) async {
    final activeUser = currentUser;
    if (activeUser == null) return;

    try {
      final results = await _chatRepository.searchUsers(
        keyword: query,
        excludeStudentId: activeUser.studentId,
      );
      if (version != _searchVersion) return;

      searchResults = results;
      errorMessage = null;
    } catch (error) {
      if (version != _searchVersion) return;
      errorMessage = error.toString();
    } finally {
      if (version == _searchVersion) {
        isSearching = false;
        notifyListeners();
      }
    }
  }

  void clearSearch() {
    _searchVersion++;
    searchResults = const [];
    isSearching = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    _subscribeThreads();
  }

  void _subscribeThreads() {
    final activeUser = currentUser;
    if (activeUser == null) return;

    _threadsSubscription?.cancel();
    _threadsSubscription = _chatRepository
        .streamChatThreads(currentStudentId: activeUser.studentId)
        .listen(
          (items) {
            threads = items;
            errorMessage = null;
            notifyListeners();
          },
          onError: (Object error) {
            errorMessage = error.toString();
            notifyListeners();
          },
        );
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _threadsSubscription?.cancel();
    super.dispose();
  }
}
