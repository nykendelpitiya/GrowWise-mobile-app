import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://127.0.0.1:8000";

  static Future<Map<String, dynamic>> predictCropRecommendation({
    required String crop,
    required String district,
  }) async {
    final url = Uri.parse("$baseUrl/predict");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "crop": crop,
        "district": district,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to get prediction: ${response.body}");
    }
  }

  static Future<Map<String, dynamic>> predictCareRecommendation({
    required String userId,
    required String crop,
    required String district,
    required String plantingDate,
    required int quantity,
    String? scheduleId,
  }) async {
    final url = Uri.parse("$baseUrl/predict-care");

    final generatedScheduleId =
        scheduleId != null && scheduleId.trim().isNotEmpty
            ? scheduleId.trim()
            : "${userId}_${crop.toLowerCase().replaceAll(' ', '_')}_${district.toLowerCase().replaceAll(' ', '_')}_$plantingDate";

    final body = {
      "user_id": userId,
      "crop": crop,
      "district": district,
      "planting_date": plantingDate,
      "quantity": quantity,
      "schedule_id": generatedScheduleId,
    };

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      decoded["schedule_id"] = generatedScheduleId;

      return decoded;
    } else {
      throw Exception(
        "Failed to get care recommendation: ${response.body}",
      );
    }
  }

  static Future<Map<String, dynamic>> getTodayTip({
    required String city,
    required String userId,
  }) async {
    final url = Uri.parse("$baseUrl/today-tip/$city?user_id=$userId");

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to get today tip: ${response.body}");
    }
  }
}