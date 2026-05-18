import 'dart:math';

import 'package:aqedu/core/theme/app_theme.dart';
import 'package:aqedu/features/chat/models/chat_thread.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatThreadTile extends StatelessWidget {
  const ChatThreadTile({super.key, required this.thread, required this.onTap});

  final ChatThread thread;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Text(
                  _avatarText(thread.peer.fullName),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            thread.peer.fullName.isNotEmpty
                                ? thread.peer.fullName
                                : thread.peer.studentId,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatTime(thread.updatedAt),
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      thread.lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      thread.peer.className.isNotEmpty
                          ? thread.peer.className
                          : thread.peer.faculty.isNotEmpty
                              ? thread.peer.faculty
                              : 'Sinh viên',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _avatarText(String fullName) {
    final trimmed = fullName.trim();
    if (trimmed.isEmpty) return '?';

    final parts = trimmed.split(RegExp(r'\\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first.substring(0, min(2, parts.first.length)).toUpperCase();
    }

    final first = parts.first[0];
    final last = parts.last[0];
    return '$first$last'.toUpperCase();
  }

  String _formatTime(DateTime value) {
    final local = value.toLocal();
    final now = DateTime.now();
    final isToday =
        local.year == now.year &&
        local.month == now.month &&
        local.day == now.day;

    return isToday
        ? DateFormat('HH:mm').format(local)
        : DateFormat('dd/MM').format(local);
  }
}
