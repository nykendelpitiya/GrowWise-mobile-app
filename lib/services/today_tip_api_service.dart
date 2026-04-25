import 'dart:convert';
import 'package:http/http.dart' as http;

class TodayTipApiService {
  static Future<Map<String, dynamic>?> getTodayTip(String city) async {
    try {
      final res = await http.get(
        Uri.parse("http://127.0.0.1:8000/today-tip/$city"),
      );

      final data = jsonDecode(res.body);

      // 🔥 ADD ALERT TYPE
      if (data["condition"].toString().toLowerCase().contains("rain")) {
        data["alert"] = "rain";
      } else {
        data["alert"] = "normal";
      }

      return data;
    } catch (e) {
      return null;
    }
  }
}