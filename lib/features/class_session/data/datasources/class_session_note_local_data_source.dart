import 'dart:convert';

import 'package:aqedu/core/database/app_database.dart';
import 'package:aqedu/core/services_root/sqlite/sessions/core_service_session.dart';
import 'package:aqedu/features/class_session/data/models/class_session_note_model.dart';
import 'package:aqedu/features/class_session/domain/entities/class_session_note.dart';
import 'package:crypto/crypto.dart';
import 'package:sqflite/sqflite.dart';

class ClassSessionNoteLocalDataSource {
  ClassSessionNoteLocalDataSource({
    AppDatabase? database,
    SqliteServices? sessionService,
  }) : _database = database ?? AppDatabase(),
       _sessionService = sessionService ?? SqliteServices();

  final AppDatabase _database;
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
    final db = await _database.instance;
    final rows = await db.query(
      'class_session_notes',
      where: 'session_key = ? AND owner_hash = ?',
      whereArgs: [sessionKey, ownerHash],
      orderBy: 'updated_at DESC',
    );
    return rows.map(ClassSessionNoteModel.fromMap).toList();
  }

  Future<void> saveNote(ClassSessionNote note) async {
    final db = await _database.instance;
    await db.insert(
      'class_session_notes',
      ClassSessionNoteModel.toMap(note),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteNote(String id) async {
    final db = await _database.instance;
    await db.delete('class_session_notes', where: 'id = ?', whereArgs: [id]);
  }
}
