import 'package:aqedu/features/chat/models/chat_user.dart';
import 'package:aqedu/features/chat/services/chat_service.dart';
import 'package:aqedu/features/chat/services/chat_session_service.dart';
import 'package:aqedu/features/chat/services/chat_student_info_service.dart';
import 'package:aqedu/features/infor/models/models_inforStudent.dart';

class ChatUserSyncService {
  ChatUserSyncService({
    ChatService? chatService,
    ChatSessionService? sessionService,
    ChatStudentInfoService? studentInfoService,
  })  : _chatService = chatService ?? ChatService(),
        _sessionService = sessionService ?? ChatSessionService(),
        _studentInfoService = studentInfoService ?? ChatStudentInfoService();

  final ChatService _chatService;
  final ChatSessionService _sessionService;
  final ChatStudentInfoService _studentInfoService;

  Future<ChatUser> syncCurrentSessionUser() async {
    final studentId = await _sessionService.getCurrentStudentId();
    final studentInfo = await _studentInfoService.getCurrentStudentData();
    if (studentInfo != null && studentInfo.maSv.trim().isNotEmpty) {
      return syncStudentIdWithStudentData(studentInfo);
    }
    return syncStudentId(studentId);
  }

  Future<ChatUser> syncStudentId(String studentId) {
    return _chatService.ensureUserByStudentId(studentId);
  }

  Future<ChatUser> syncStudentIdWithStudentData(StudentData studentData) async {
    final user = ChatUser(
      id: studentData.maSv,
      studentId: studentData.maSv,
      fullName: studentData.tenDayDu.trim().isEmpty
          ? studentData.maSv
          : studentData.tenDayDu.trim(),
      avatarUrl: '',
      faculty: studentData.khoa.trim(),
      className: studentData.lop.trim(),
      lastOnline: null,
      createdAt: null,
      updatedAt: null,
    );
    return _chatService.upsertUserProfile(user);
  }

  static Future<void> syncUser(String studentId) async {
    await ChatUserSyncService().syncStudentId(studentId);
  }
}
