import 'package:aqedu/core/theme/app_theme.dart';
import 'package:aqedu/features/chat/controllers/chat_list_controller.dart';
import 'package:aqedu/features/chat/models/chat_thread.dart';
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

class _ChatListScreenState extends State<ChatListScreen>
    with SingleTickerProviderStateMixin {
  late final ChatListController _controller;
  late final TextEditingController _searchController;
  late final FocusNode _searchFocusNode;
  late final AnimationController _introController;
  bool _isSearchingText = false;
  bool _isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = ChatListController()..init();
    _searchController = TextEditingController()..addListener(_onSearchTextChanged);
    _searchFocusNode = FocusNode()..addListener(_onSearchFocusChanged);
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    )..forward();
  }

  @override
  void dispose() {
    _introController.dispose();
    _searchFocusNode
      ..removeListener(_onSearchFocusChanged)
      ..dispose();
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

  void _onSearchFocusChanged() {
    if (_isSearchFocused != _searchFocusNode.hasFocus) {
      setState(() => _isSearchFocused = _searchFocusNode.hasFocus);
    }
  }

  void _openChat(ChatUser user) {
    FocusScope.of(context).unfocus();
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => FadeTransition(
          opacity: animation,
          child: ChatRoomScreen(receiverStudentId: user.studentId),
        ),
        transitionDuration: const Duration(milliseconds: 260),
        reverseTransitionDuration: const Duration(milliseconds: 220),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final introAnimation = CurvedAnimation(
      parent: _introController,
      curve: Curves.easeOutCubic,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Chat',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.04),
          end: Offset.zero,
        ).animate(introAnimation),
        child: FadeTransition(
          opacity: introAnimation,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              if (_controller.isLoading && _controller.currentUser == null) {
                return const _ChatListLoading();
              }

              return Column(
                children: [
                  _buildHeader(context),
                  _buildBody(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xffFCFEFF),
            Color(0xffEDF7FF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.lightShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tin nhắn của bạn',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'Tìm bạn bè hoặc tiếp tục cuộc trò chuyện hiện tại với trải nghiệm mượt mà hơn.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13.5,
              height: 1.55,
            ),
          ),
          const Text(
            'Nếu không tìm thấy bạn bè, hãy chắc chắn họ đã đăng nhập ít nhất một lần để hiển thị trong danh sách.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13.5,
              height: 1.55,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AnimatedContainer(
            duration: const Duration(milliseconds: 240),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(
                color: _isSearchFocused
                    ? AppColors.primary.withOpacity(0.32)
                    : AppColors.border,
                width: 1.0,
              ),
              boxShadow: _isSearchFocused ? AppShadows.lightShadow : null,
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Tìm theo tên hoặc mã sinh viên',
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
                suffixIcon: _isSearchingText
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          _controller.clearSearch();
                        },
                        icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                      )
                    : null,
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.lg,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          if (_controller.currentUser != null) ...[
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.verified_user,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Flexible(
                    child: Text(
                      'Bạn đang dùng: ${_controller.currentUser!.fullName}',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Expanded(
      child: Column(
        children: [
          if (_controller.errorMessage != null)
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: _ErrorBanner(message: _controller.errorMessage!),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: child,
              ),
            ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 260),
              child: _isSearchingText ? _buildSearchResults() : _buildThreads(),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThreads() {
    if (_controller.threads.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: ChatEmptyState(
          icon: Icons.forum_outlined,
          title: 'Chưa có cuộc trò chuyện',
          message: 'Tìm sinh viên để bắt đầu chat 1-1.',
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: AppColors.surface,
      onRefresh: _controller.refresh,
      child: ListView.separated(
        key: const PageStorageKey('chat-thread-list'),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.xxl,
        ),
        itemBuilder: (context, index) {
          final thread = _controller.threads[index];
          return _StaggeredListItem(
            index: index,
            child: ChatThreadTile(
              thread: thread,
              onTap: () => _openChat(thread.peer),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
        itemCount: _controller.threads.length,
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_controller.isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_controller.searchResults.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: ChatEmptyState(
          icon: Icons.person_search_rounded,
          title: 'Không tìm thấy sinh viên',
          message: 'Nhập tên hoặc mã sinh viên đã từng đăng nhập.',
        ),
      );
    }

    return ListView.separated(
      key: const PageStorageKey('chat-search-results'),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.xxl,
      ),
      itemBuilder: (context, index) {
        final user = _controller.searchResults[index];
        return _StaggeredListItem(
          index: index,
          child: Material(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: InkWell(
              onTap: () => _openChat(user),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              splashColor: AppColors.primary.withOpacity(0.12),
              highlightColor: AppColors.primary.withOpacity(0.08),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.primary.withOpacity(0.12),
                      child: const Icon(Icons.person_outline, color: AppColors.primary),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.fullName.isNotEmpty ? user.fullName : user.studentId,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            user.className.isNotEmpty
                                ? user.className
                                : user.faculty.isNotEmpty
                                    ? user.faculty
                                    : 'Sinh viên',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemCount: _controller.searchResults.length,
    );
  }
}

class _StaggeredListItem extends StatefulWidget {
  const _StaggeredListItem({
    required this.index,
    required this.child,
    super.key,
  });

  final int index;
  final Widget child;

  @override
  State<_StaggeredListItem> createState() => _StaggeredListItemState();
}

class _StaggeredListItemState extends State<_StaggeredListItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _opacity = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(_opacity);

    Future.delayed(
      Duration(milliseconds: 70 * (widget.index > 6 ? 6 : widget.index)),
      () {
        if (mounted) {
          _animationController.forward();
        }
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: widget.child,
      ),
    );
  }
}

class _ChatListLoading extends StatelessWidget {
  const _ChatListLoading();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.xxl,
      ),
      itemBuilder: (context, index) => Container(
        height: 96,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: AppShadows.lightShadow,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 16,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Container(
                      height: 12,
                      width: MediaQuery.of(context).size.width * 0.5,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Container(
                      height: 12,
                      width: MediaQuery.of(context).size.width * 0.35,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemCount: 4,
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
      margin: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.errorLight,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.error.withOpacity(0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 20),
          const SizedBox(width: AppSpacing.sm),
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
