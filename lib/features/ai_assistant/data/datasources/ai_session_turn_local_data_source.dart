import 'dart:convert';

import 'package:aqedu/core/database/app_database.dart';
import 'package:aqedu/features/ai_assistant/domain/entities/ai_turn.dart';
import 'package:crypto/crypto.dart';

class AiSessionTurnLocalDataSource {
  AiSessionTurnLocalDataSource({AppDatabase? database})
    : _database = database ?? AppDatabase();

  final AppDatabase _database;

  Future<void> save({
    required String sessionId,
    required String userText,
    required AiTurnResult turn,
  }) async {
    final db = await _database.instance;
    final now = DateTime.now().toIso8601String();
    final ownerHash = await _database.ownerHash;
    final id = sha256
        .convert(utf8.encode('$ownerHash|$sessionId|$now|$userText'))
        .toString();
    await db.insert('ai_session_turns', {
      'id': id,
      'owner_hash': ownerHash,
      'session_id': sessionId,
      'task_kind': turn.intent.taskKind.name,
      'user_text': userText,
      'answer_text': turn.answerText,
      'spoken_text': turn.spokenText,
      'action_target': turn.action?.target.name,
      'created_at': now,
    });
  }

  Future<void> clearSession(String sessionId) async {
    final db = await _database.instance;
    await db.delete(
      'ai_session_turns',
      where: 'session_id = ?',
      whereArgs: [sessionId],
    );
  }
}
