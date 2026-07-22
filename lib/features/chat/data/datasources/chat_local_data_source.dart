import 'dart:convert';

import 'package:aqedu/core/database/app_database.dart';
import 'package:aqedu/features/chat/models/chat_message.dart';
import 'package:aqedu/features/chat/models/chat_thread.dart';
import 'package:aqedu/features/chat/models/chat_user.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

abstract class ChatLocalDataSource {
  Future<void> saveUser(ChatUser user);
  Future<ChatUser?> readUser(String studentId);
  Future<List<ChatUser>> searchUsers(String keyword, {int limit = 20});
  Future<void> replaceThreads(List<ChatThread> threads);
  Future<List<ChatThread>> readThreads({int limit = 200});
  Future<String?> findConversationId(String peerStudentId);
  Future<void> replaceMessages(
    String conversationId,
    List<ChatMessage> messages,
  );
  Future<void> upsertMessage(ChatMessage message);
  Future<List<ChatMessage>> readMessages(
    String conversationId, {
    int limit = 80,
  });
}

class SqliteChatLocalDataSource implements ChatLocalDataSource {
  SqliteChatLocalDataSource({AppDatabase? database})
    : _database = database ?? AppDatabase();

  final AppDatabase _database;

  @override
  Future<void> saveUser(ChatUser user) async {
    final db = await _database.instance;
    final ownerHash = await _database.ownerHash;
    await db.insert('chat_users_cache', {
      'owner_hash': ownerHash,
      'student_id': user.studentId,
      'payload_json': jsonEncode(_userToJson(user)),
      'updated_at': (user.updatedAt ?? DateTime.now().toUtc())
          .toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<ChatUser?> readUser(String studentId) async {
    final db = await _database.instance;
    final ownerHash = await _database.ownerHash;
    final rows = await db.query(
      'chat_users_cache',
      where: 'owner_hash = ? AND student_id = ?',
      whereArgs: [ownerHash, studentId.trim()],
      limit: 1,
    );
    return rows.isEmpty ? null : _userFromPayload(rows.first['payload_json']);
  }

  @override
  Future<List<ChatUser>> searchUsers(String keyword, {int limit = 20}) async {
    final db = await _database.instance;
    final ownerHash = await _database.ownerHash;
    final normalized = keyword.trim().toLowerCase();
    if (normalized.isEmpty) return const [];
    final rows = await db.query(
      'chat_users_cache',
      where: 'owner_hash = ?',
      whereArgs: [ownerHash],
      orderBy: 'updated_at DESC',
    );
    return rows
        .map((row) => _userFromPayload(row['payload_json']))
        .whereType<ChatUser>()
        .where(
          (user) =>
              user.studentId.toLowerCase().contains(normalized) ||
              user.fullName.toLowerCase().contains(normalized),
        )
        .take(limit)
        .toList(growable: false);
  }

  @override
  Future<void> replaceThreads(List<ChatThread> threads) async {
    final db = await _database.instance;
    final ownerHash = await _database.ownerHash;
    await db.transaction((txn) async {
      await txn.delete(
        'chat_conversations_cache',
        where: 'owner_hash = ?',
        whereArgs: [ownerHash],
      );
      for (final thread in threads) {
        await txn.insert('chat_conversations_cache', {
          'owner_hash': ownerHash,
          'conversation_id': thread.conversationId,
          'payload_json': jsonEncode(_threadToJson(thread)),
          'updated_at': thread.updatedAt.toUtc().toIso8601String(),
        });
        await txn.insert('chat_users_cache', {
          'owner_hash': ownerHash,
          'student_id': thread.peer.studentId,
          'payload_json': jsonEncode(_userToJson(thread.peer)),
          'updated_at': (thread.peer.updatedAt ?? thread.updatedAt)
              .toUtc()
              .toIso8601String(),
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
    });
  }

  @override
  Future<List<ChatThread>> readThreads({int limit = 200}) async {
    final db = await _database.instance;
    final ownerHash = await _database.ownerHash;
    final rows = await db.query(
      'chat_conversations_cache',
      where: 'owner_hash = ?',
      whereArgs: [ownerHash],
      orderBy: 'updated_at DESC',
      limit: limit,
    );
    return rows
        .map((row) => _threadFromPayload(row['payload_json']))
        .whereType<ChatThread>()
        .toList(growable: false);
  }

  @override
  Future<String?> findConversationId(String peerStudentId) async {
    final threads = await readThreads();
    for (final thread in threads) {
      if (thread.peer.studentId == peerStudentId.trim()) {
        return thread.conversationId;
      }
    }
    return null;
  }

  @override
  Future<void> replaceMessages(
    String conversationId,
    List<ChatMessage> messages,
  ) async {
    final db = await _database.instance;
    final ownerHash = await _database.ownerHash;
    await db.transaction((txn) async {
      await txn.delete(
        'chat_messages_cache',
        where: 'owner_hash = ? AND conversation_id = ?',
        whereArgs: [ownerHash, conversationId],
      );
      for (final message in messages) {
        await _insertMessage(txn, ownerHash, message);
      }
    });
  }

  @override
  Future<void> upsertMessage(ChatMessage message) async {
    final db = await _database.instance;
    final ownerHash = await _database.ownerHash;
    await _insertMessage(db, ownerHash, message);
  }

  @override
  Future<List<ChatMessage>> readMessages(
    String conversationId, {
    int limit = 80,
  }) async {
    final db = await _database.instance;
    final ownerHash = await _database.ownerHash;
    final rows = await db.query(
      'chat_messages_cache',
      where: 'owner_hash = ? AND conversation_id = ?',
      whereArgs: [ownerHash, conversationId],
      orderBy: 'created_at ASC',
      limit: limit,
    );
    return rows
        .map((row) => _messageFromPayload(row['payload_json']))
        .whereType<ChatMessage>()
        .toList(growable: false);
  }

  Future<void> _insertMessage(
    DatabaseExecutor db,
    String ownerHash,
    ChatMessage message,
  ) {
    return db.insert('chat_messages_cache', {
      'owner_hash': ownerHash,
      'message_id': message.id.toString(),
      'conversation_id': message.conversationId,
      'payload_json': jsonEncode(_messageToJson(message)),
      'created_at': message.createdAt.toUtc().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  ChatUser? _userFromPayload(Object? value) =>
      _decode(value, ChatUser.fromJson);
  ChatThread? _threadFromPayload(Object? value) =>
      _decode(value, _threadFromJson);
  ChatMessage? _messageFromPayload(Object? value) =>
      _decode(value, ChatMessage.fromJson);

  T? _decode<T>(Object? value, T Function(Map<String, dynamic>) parse) {
    try {
      return parse(
        Map<String, dynamic>.from(jsonDecode(value! as String) as Map),
      );
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic> _userToJson(ChatUser user) => {
    'id': user.id,
    'student_id': user.studentId,
    'full_name': user.fullName,
    'avatar_url': user.avatarUrl,
    'faculty': user.faculty,
    'class_name': user.className,
    'last_online': user.lastOnline?.toIso8601String(),
    'created_at': user.createdAt?.toIso8601String(),
    'updated_at': user.updatedAt?.toIso8601String(),
  };

  Map<String, dynamic> _threadToJson(ChatThread thread) => {
    'conversation_id': thread.conversationId,
    'peer': _userToJson(thread.peer),
    'last_message': thread.lastMessage,
    'last_sender_student_id': thread.lastSenderStudentId,
    'updated_at': thread.updatedAt.toIso8601String(),
  };

  ChatThread _threadFromJson(Map<String, dynamic> json) => ChatThread(
    conversationId: json['conversation_id'].toString(),
    peer: ChatUser.fromJson(Map<String, dynamic>.from(json['peer'] as Map)),
    lastMessage: json['last_message']?.toString() ?? '',
    lastSenderStudentId: json['last_sender_student_id']?.toString() ?? '',
    updatedAt:
        DateTime.tryParse(json['updated_at']?.toString() ?? '') ??
        DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
  );

  Map<String, dynamic> _messageToJson(ChatMessage message) => {
    'id': message.id,
    'conversation_id': message.conversationId,
    'sender_student_id': message.senderStudentId,
    'receiver_student_id': message.receiverStudentId,
    'message': message.message,
    'message_type': message.messageType,
    'is_seen': message.isSeen,
    'created_at': message.createdAt.toIso8601String(),
  };
}
