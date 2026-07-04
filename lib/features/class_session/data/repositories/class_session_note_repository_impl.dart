import 'package:aqedu/features/class_session/data/datasources/class_session_note_local_data_source.dart';
import 'package:aqedu/features/class_session/domain/entities/class_session_note.dart';
import 'package:aqedu/features/class_session/domain/repositories/class_session_note_repository.dart';

class ClassSessionNoteRepositoryImpl implements ClassSessionNoteRepository {
  ClassSessionNoteRepositoryImpl({
    ClassSessionNoteLocalDataSource? localDataSource,
  }) : _localDataSource = localDataSource ?? ClassSessionNoteLocalDataSource();

  final ClassSessionNoteLocalDataSource _localDataSource;

  @override
  Future<void> deleteNote(String id) => _localDataSource.deleteNote(id);

  @override
  Future<List<ClassSessionNote>> loadNotes({
    required String sessionKey,
    required String ownerHash,
  }) {
    return _localDataSource.loadNotes(
      sessionKey: sessionKey,
      ownerHash: ownerHash,
    );
  }

  @override
  Future<String> resolveOwnerHash() => _localDataSource.resolveOwnerHash();

  @override
  Future<void> saveNote(ClassSessionNote note) {
    return _localDataSource.saveNote(note);
  }
}
