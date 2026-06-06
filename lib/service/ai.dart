import 'dart:convert';
import 'package:http/http.dart' as http;

class AiService {
  Future<String> analyze(String prompt) async {
    final response = await http.post(
      Uri.parse('http://localhost:11434/api/generate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "model": "qwen3:1.7b",
        "prompt": prompt,
        "stream": false
      }),
    );

    final data = jsonDecode(response.body);
    return data['response'];
  }
}