import 'package:aqedu/core/constants/api/api_daotao.dart';
import 'package:aqedu/features/ai_assistant/services/ai_context_service.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AiController {
  static GenerativeModel? _model;
  static final AiContextService _contextService = AiContextService();

  static GenerativeModel get _configuredModel {
    return _model ??= GenerativeModel(
      model: 'gemini-3-flash-preview',
      apiKey: geminiApiKey,
    );
  }

  static Future<String> askGemini(String prompt) async {
    if (geminiApiKey.isEmpty) {
      return 'AI assistant is not configured. Start the app with --dart-define=GEMINI_API_KEY=...';
    }

    try {
      final localContext = await _contextService.buildContextForPrompt(prompt);
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

      final response = await _configuredModel.generateContent([
        Content.text(finalPrompt),
      ]);

      final text = response.text?.trim();
      if (text == null || text.isEmpty) {
        return 'AI chưa trả về nội dung.';
      }
      return text;
    } catch (_) {
      return 'AI assistant is temporarily unavailable. Please try again later.';
    }
  }
}
