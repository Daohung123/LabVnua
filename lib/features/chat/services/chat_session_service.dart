import 'package:aqedu/core/services_root/sqlite/sessions/core_service_session.dart';

class ChatSessionService {
  ChatSessionService({SqliteServices? sqliteServices})
    : _sqliteServices = sqliteServices ?? SqliteServices();

  final SqliteServices _sqliteServices;

  Future<String> getCurrentStudentId() async {
    final session = await _sqliteServices.getSession();
    final studentId = session?.user.trim();

    if (studentId == null || studentId.isEmpty) {
      throw StateError('No active student session found');
    }

    return studentId;
  }
}
