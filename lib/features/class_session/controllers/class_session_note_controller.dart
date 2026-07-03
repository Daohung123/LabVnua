import 'package:aqedu/features/class_session/models/class_session_note.dart';
import 'package:aqedu/features/class_session/services/class_session_note_service.dart';

abstract class ClassSessionNoteRepository {
  Future<String> resolveOwnerHash();

  Future<List<ClassSessionNote>> loadNotes({
    required String sessionKey,
    required String ownerHash,
  });

  Future<void> saveNote(ClassSessionNote note);

  Future<void> deleteNote(String id);
}

class ClassSessionNoteServiceRepository implements ClassSessionNoteRepository {
  ClassSessionNoteServiceRepository({ClassSessionNoteService? service})
    : _service = service ?? ClassSessionNoteService();

  final ClassSessionNoteService _service;

  @override
  Future<String> resolveOwnerHash() => _service.resolveOwnerHash();

  @override
  Future<List<ClassSessionNote>> loadNotes({
    required String sessionKey,
    required String ownerHash,
  }) {
    return _service.loadNotes(sessionKey: sessionKey, ownerHash: ownerHash);
  }

  @override
  Future<void> saveNote(ClassSessionNote note) => _service.saveNote(note);

  @override
  Future<void> deleteNote(String id) => _service.deleteNote(id);
}

class ClassSessionNoteController {
  ClassSessionNoteController({ClassSessionNoteRepository? repository})
    : _repository = repository ?? ClassSessionNoteServiceRepository();

  final ClassSessionNoteRepository _repository;

  Future<String> resolveOwnerHash() => _repository.resolveOwnerHash();

  Future<List<ClassSessionNote>> loadNotes({
    required String sessionKey,
    required String ownerHash,
  }) {
    return _repository.loadNotes(sessionKey: sessionKey, ownerHash: ownerHash);
  }

  Future<ClassSessionNote> createNote({
    required String sessionKey,
    required String ownerHash,
    required String content,
  }) async {
    final normalized = content.trim();
    if (normalized.isEmpty) {
      throw ArgumentError('Note content is required');
    }
    final now = DateTime.now();
    final note = ClassSessionNote(
      id: 'note_${now.microsecondsSinceEpoch}',
      sessionKey: sessionKey,
      ownerHash: ownerHash,
      content: normalized,
      createdAt: now,
      updatedAt: now,
    );
    await _repository.saveNote(note);
    return note;
  }

  Future<void> deleteNote(String id) => _repository.deleteNote(id);
}
