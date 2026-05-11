import 'package:aqedu/core/constants/api/api_daotao.dart';
import 'package:aqedu/core/services_root/sqlite/notification/notification_sqlite.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AiController {
  static final GenerativeModel _model = GenerativeModel(
    model: 'gemini-3-flash-preview',
    apiKey: AI_KEY,
  );

  static final ServiceSqlNotification _notificationSql =
      ServiceSqlNotification();

  /// Các từ khóa để nhận diện câu hỏi liên quan đến thông báo
  static final List<String> _notificationKeywords = [
    'thông báo',
    'tin nhắn',
    'nội dung thông báo',
    'notice',
    'notification',
    'công văn',
    'thông tin mới',
    'học vụ',
    'lịch nghỉ',
    'lịch học',
    'lịch thi',
    'kế hoạch',
    'điểm danh',
  ];

  static bool _isNotificationRelated(String text) {
    final lowerText = text.toLowerCase();
    return _notificationKeywords.any((keyword) => lowerText.contains(keyword));
  }

  static Future<String> askGemini(String prompt) async {
    try {
      final isNotificationQuery = _isNotificationRelated(prompt);

      // Chỉ lấy dữ liệu notifications khi câu hỏi thực sự liên quan
      String notifications = '';
      if (isNotificationQuery) {
        notifications = await _notificationSql.exportAllNotificationsToString();
      }

      final finalPrompt = '''
Bạn là trợ lý ảo của ứng dụng EduAI.
Được phát triển bởi nhóm sinh viên Học Viện Nông Nghiệp Việt Nam, bạn có nhiệm vụ hỗ trợ sinh viên trong việc tra cứu thông tin liên quan đến học tập, thời khóa biểu, điểm số, thông báo và các thông tin khác liên quan đến cuộc sống sinh viên tại trường.

Nhiệm vụ:
- Trả lời người dùng bằng tiếng Việt.
- Trả lời ngắn gọn, rõ ràng, đúng trọng tâm.
- Ưu tiên tra cứu và sử dụng dữ liệu trong SQLite trước.
- Chỉ dùng thông tin trong cơ sở dữ liệu khi câu hỏi liên quan đến dữ liệu đã có.
- Nếu không tìm thấy thông tin phù hợp trong SQLite, hãy trả lời theo kiến thức chung một cách hợp lý, nhưng phải nói rõ là không thấy dữ liệu trong hệ thống.
- Nếu người dùng hỏi một cách không văn minh lịch sự thì hãy đáp lại: "Bạn tự xử lý đi 😡".

Quy tắc xử lý:
1. Phân tích câu hỏi của người dùng.
2. Tìm thông tin liên quan trong dữ liệu SQLite.
3. Nếu có dữ liệu phù hợp, trả lời dựa trên dữ liệu đó.
4. Nếu không có dữ liệu phù hợp, trả lời ngắn gọn theo suy luận hợp lý.
5. Không bịa đặt dữ liệu, không tự tạo thông tin không có căn cứ.
6. Nếu dữ liệu không đủ rõ, hãy nói rằng chưa đủ thông tin để kết luận.

${isNotificationQuery && notifications.isNotEmpty
          ? '''
DỮ LIỆU SQLITE:
Bảng Notifications (Thông báo):
$notifications
'''
          : '''
DỮ LIỆU SQLITE:
Không cần đọc bảng thông báo cho câu hỏi này.
'''}

CÂU HỎI NGƯỜI DÙNG:
$prompt

Hãy trả lời ngay theo đúng quy tắc trên.
''';

      final response = await _model.generateContent([
        Content.text(finalPrompt),
      ]);

      final text = response.text?.trim();
      if (text == null || text.isEmpty) {
        return 'AI chưa trả về nội dung.';
      }

      return text;
    } catch (e) {
      return 'Lỗi rồi: $e';
    }
  }
}