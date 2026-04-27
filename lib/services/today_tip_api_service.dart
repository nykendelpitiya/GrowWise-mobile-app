import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class TodayTipApiService {
  static const String baseUrl = "http://127.0.0.1:8000";

  static Future<Map<String, dynamic>?> getTodayTip(String city) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        return null;
      }

      final url = Uri.parse(
        "$baseUrl/today-tip/$city?user_id=${user.uid}",
      );

      final res = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

       
        return data;
      } else {
        throw Exception("Failed to load tip: ${res.body}");
      }
    } catch (e) {
      print("❌ TodayTip error: $e");
      return null;
    }
  }
}