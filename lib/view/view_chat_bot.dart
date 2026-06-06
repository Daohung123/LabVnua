import 'package:lab_dart_basic/service/ai.dart';
import 'dart:io';

Future<void> view_chat_bot() async {
  final aiService = AiService();
  print("🤖 ChatBot: Chào bạn! Tôi có thể giúp gì cho bạn hôm nay?");
  bool continueChat = true;
  while (continueChat){
    String prompt = stdin.readLineSync() ?? '';
    if (prompt == 'exit') {
      continueChat = false;
      print("🤖 ChatBot: Tạm biệt! Hẹn gặp lại.");
      break;
    }
    final response = await aiService.analyze(prompt);
    print("🤖 ChatBot: $response");
  }
}