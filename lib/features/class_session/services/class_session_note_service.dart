import 'dart:convert';

import 'package:aqedu/config/config_DB.dart';
import 'package:aqedu/core/services_root/sqlite/sessions/core_service_session.dart';
import 'package:aqedu/features/class_session/models/class_session_note.dart';
import 'package:crypto/crypto.dart';
import 'package:sqflite/sqflite.dart';

class ClassSessionNoteService {
  ClassSessionNoteService({
    DataBaseConfig? dbConfig,
    SqliteServices? sessionService,
  }) : _dbConfig = dbConfig ?? DataBaseConfig(),
       _sessionService = sessionService ?? SqliteServices();

  final DataBaseConfig _dbConfig;
  final SqliteServices _sessionService;

  Future<String> resolveOwnerHash() async {
    final session = await _sessionService.getSession();
    final source = session?.user ?? 'anonymous';
    return sha256.convert(utf8.encode(source)).toString();
  }

  Future<List<ClassSessionNote>> loadNotes({
    required String sessionKey,
    required String ownerHash,
  }) async {
    final db = await _dbConfig.database;
    final rows = await db.query(
      'class_session_notes',
      where: 'session_key = ? AND owner_hash = ?',
      whereArgs: [sessionKey, ownerHash],
      orderBy: 'updated_at DESC',
    );
    return rows.map(ClassSessionNote.fromMap).toList();
  }

  Future<void> saveNote(ClassSessionNote note) async {
    final db = await _dbConfig.database;
    await db.insert(
      'class_session_notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteNote(String id) async {
    final db = await _dbConfig.database;
    await db.delete('class_session_notes', where: 'id = ?', whereArgs: [id]);
  }
}
