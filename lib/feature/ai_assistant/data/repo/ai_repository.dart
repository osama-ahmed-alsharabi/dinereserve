import 'dart:convert';
import 'package:dinereserve/feature/ai_assistant/data/model/chat_message_model.dart';
import 'package:http/http.dart' as http;

class AiRepository {
  final String _apiKey = "";
  final String _baseUrl = 'https://api.openai.com/v1/chat/completions';

  Future<String> sendMessage({
    required List<ChatMessageModel> history,
    required String systemPrompt,
  }) async {
    try {
      final messages = [
        {'role': 'system', 'content': systemPrompt},
        ...history.map(
          (msg) => {
            'role': msg.isUser ? 'user' : 'assistant',
            'content': msg.message,
          },
        ),
      ];

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo', // Or gpt-4 if available and needed
          'messages': messages,
          'temperature': 0.7,
          'max_tokens': 500,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['choices'][0]['message']['content'];
      } else {
        throw Exception(
          'Failed to get response from OpenAI: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error communicating with AI: $e');
    }
  }
}
