import 'package:aqedu/core/theme/app_theme.dart';
import 'package:aqedu/features/chat/controllers/chat_list_controller.dart';
import 'package:aqedu/features/chat/models/chat_user.dart';
import 'package:aqedu/features/chat/screens/chat_room_screen.dart';
import 'package:aqedu/features/chat/widgets/chat_empty_state.dart';
import 'package:aqedu/features/chat/widgets/chat_thread_tile.dart';
import 'package:flutter/material.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late final ChatListController _controller;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchingText = false;

  @override
  void initState() {
    super.initState();
    _controller = ChatListController()..init();
    _searchController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchTextChanged)
      ..dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onSearchTextChanged() {
    final isSearchingText = _searchController.text.trim().isNotEmpty;
    if (isSearchingText != _isSearchingText) {
      setState(() => _isSearchingText = isSearchingText);
    }
    _controller.searchUsers(_searchController.text);
  }

  void _openChat(ChatUser user) {
    FocusScope.of(context).unfocus();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatRoomScreen(receiverStudentId: user.studentId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Chat',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          if (_controller.isLoading && _controller.currentUser == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              _buildHeader(),
              if (_controller.errorMessage != null)
                _ErrorBanner(message: _controller.errorMessage!),
              Expanded(
                child: _isSearchingText
                    ? _buildSearchResults()
                    : _buildThreads(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _searchController,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Tim theo ma sinh vien',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _isSearchingText
                  ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                        _controller.clearSearch();
                      },
                      icon: const Icon(Icons.close_rounded),
                    )
                  : null,
              filled: true,
              fillColor: AppColors.background,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          if (_controller.currentUser != null) ...[
            const SizedBox(height: 10),
            Text(
              'Dang dang nhap: ${_controller.currentUser!.studentId}',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildThreads() {
    if (_controller.threads.isEmpty) {
      return const ChatEmptyState(
        icon: Icons.forum_outlined,
        title: 'Chua co cuoc tro chuyen',
        message: 'Tim ma sinh vien de bat dau chat 1-1.',
      );
    }

    return RefreshIndicator(
      onRefresh: _controller.refresh,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final thread = _controller.threads[index];
          return ChatThreadTile(
            thread: thread,
            onTap: () => _openChat(thread.peer),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemCount: _controller.threads.length,
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_controller.isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_controller.searchResults.isEmpty) {
      return const ChatEmptyState(
        icon: Icons.person_search_rounded,
        title: 'Khong tim thay sinh vien',
        message: 'Nhap dung ma sinh vien da tung dang nhap tren he thong.',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final user = _controller.searchResults[index];
        return Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: ListTile(
            onTap: () => _openChat(user),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: const Icon(Icons.person_outline, color: AppColors.primary),
            ),
            title: Text(
              user.studentId,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: const Text('Bat dau chat 1-1'),
            trailing: const Icon(Icons.chevron_right_rounded),
          ),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemCount: _controller.searchResults.length,
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
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
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
