import 'package:aqedu/features/class_session/domain/entities/class_session_note.dart';

abstract class ClassSessionNoteRepository {
  Future<String> resolveOwnerHash();

  Future<List<ClassSessionNote>> loadNotes({
    required String sessionKey,
    required String ownerHash,
  });

  Future<void> saveNote(ClassSessionNote note);

  Future<void> deleteNote(String id);
}
