import 'package:aqedu/features/ai_assistant/data/datasources/ai_context_local_data_source.dart';
import 'package:aqedu/features/ai_assistant/data/datasources/gemini_ai_data_source.dart';
import 'package:aqedu/features/ai_assistant/domain/repositories/ai_assistant_repository.dart';

class GeminiAiAssistantRepository implements AiAssistantRepository {
  GeminiAiAssistantRepository({
    required GeminiAiDataSource geminiDataSource,
    AiContextLocalDataSource? contextDataSource,
  }) : _geminiDataSource = geminiDataSource,
       _contextDataSource = contextDataSource ?? AiContextLocalDataSource();

  final GeminiAiDataSource _geminiDataSource;
  final AiContextLocalDataSource _contextDataSource;

  @override
  Future<String> ask(String prompt) async {
    if (!_geminiDataSource.isConfigured) {
      return 'AI assistant is not configured. Start the app with --dart-define=GEMINI_API_KEY=...';
    }

    try {
      final localContext = await _contextDataSource.buildContextForPrompt(
        prompt,
      );
      final finalPrompt =
          '''
Bạn là trợ lý ảo của ứng dụng EduAI.
Trả lời người dùng bằng tiếng Việt, ngắn gọn, rõ ràng và đúng trọng tâm.
Ưu tiên dữ liệu SQLite cục bộ khi dữ liệu đó liên quan trực tiếp đến câu hỏi.
Nếu không tìm thấy dữ liệu phù hợp trong hệ thống, hãy nói rõ là chưa thấy dữ liệu trong hệ thống.
Không bịa đặt dữ liệu, không tự tạo thông tin không có căn cứ.
Không yêu cầu hoặc tiết lộ token, mật khẩu, cookie hay khóa API.

DỮ LIỆU SQLITE:
$localContext

CÂU HỎI NGƯỜI DÙNG:
$prompt

Hãy trả lời ngay theo đúng quy tắc trên.
''';

      final text = await _geminiDataSource.generateText(finalPrompt);
      if (text == null || text.isEmpty) {
        return 'AI chưa trả về nội dung.';
      }
      return text;
    } catch (_) {
      return 'AI assistant is temporarily unavailable. Please try again later.';
    }
  }
}
