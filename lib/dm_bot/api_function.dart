import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> sendDMtoAI(String message) async {
  const apiKey = "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";  // 여기만 네 KEY

  final url = Uri.parse("https://openrouter.ai/api/v1/chat/completions");

  try {
    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json",
        "HTTP-Referer": "https://github.com/maesiltea007", // 필수
        "X-Title": "FlutterDMApp", // 아무거나 가능
      },
      body: jsonEncode({
        "model": "google/gemma-3-4b-it:free",
        "messages": [
          {"role": "user", "content": message}
        ]
      }),
    );

    // 서버 오류 시
    if (response.statusCode != 200) {
      return "Error: ${response.statusCode}\n${response.body}";
    }

    final data = jsonDecode(response.body);

    // 모델이 답을 못 만든 경우
    if (data["choices"] == null) {
      return "No response from model.";
    }

    return data["choices"][0]["message"]["content"];
  } catch (e) {
    // 네트워크 오류
    return "Exception: $e";
  }
}