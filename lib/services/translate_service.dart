import 'dart:convert';

import 'package:http/http.dart' as http;

class TranslateService {
  static const String baseUrl = 'http://127.0.0.1:8000';

  static Future<String> translateText({
    required String text,
    required String lang,
  }) async {
    try {
      if (lang == "en") {
        return text;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/translate'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "text": text,
          "lang": lang,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          data["success"] == true) {
        return data["translated"] ?? text;
      }

      return text;
    } catch (e) {
      return text;
    }
  }
}