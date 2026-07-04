import 'package:aqedu/features/class_session/domain/entities/class_session_note.dart';
import 'package:aqedu/features/class_session/domain/usecases/manage_class_session_notes.dart';

class ClassSessionNoteController {
  ClassSessionNoteController({
    required ManageClassSessionNotes manageClassSessionNotes,
  }) : _manageClassSessionNotes = manageClassSessionNotes;

  final ManageClassSessionNotes _manageClassSessionNotes;

  Future<String> resolveOwnerHash() {
    return _manageClassSessionNotes.resolveOwnerHash();
  }

  Future<List<ClassSessionNote>> loadNotes({
    required String sessionKey,
    required String ownerHash,
  }) {
    return _manageClassSessionNotes.loadNotes(
      sessionKey: sessionKey,
      ownerHash: ownerHash,
    );
  }

  Future<ClassSessionNote> createNote({
    required String sessionKey,
    required String ownerHash,
    required String content,
  }) {
    return _manageClassSessionNotes.createNote(
      sessionKey: sessionKey,
      ownerHash: ownerHash,
      content: content,
    );
  }

  Future<void> deleteNote(String id) {
    return _manageClassSessionNotes.deleteNote(id);
  }
}
