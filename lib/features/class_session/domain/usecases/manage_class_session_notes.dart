import 'package:aqedu/features/class_session/domain/entities/class_session_note.dart';
import 'package:aqedu/features/class_session/domain/repositories/class_session_note_repository.dart';

class ManageClassSessionNotes {
  ManageClassSessionNotes(this._repository);

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
