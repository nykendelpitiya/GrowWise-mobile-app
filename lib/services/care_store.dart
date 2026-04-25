import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CareStore {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // ✅ PRODUCTION MODE
  // false = real schedule times
  static const bool testMode = false;

  static String get _uid {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }
    return user.uid;
  }

  static CollectionReference<Map<String, dynamic>> get _scheduleCollection {
    return _firestore
        .collection('users')
        .doc(_uid)
        .collection('care_schedules');
  }

  static CollectionReference<Map<String, dynamic>> get _notificationCollection {
    return _firestore.collection('notifications');
  }

  static Future<void> saveSchedule({
    required String title,
    required Map<String, dynamic> result,
  }) async {
    final scheduleDoc = await _scheduleCollection.add({
      'title': title,
      'crop': result['crop'],
      'district': result['district'],
      'planting_date': result['planting_date'],
      'quantity': result['quantity'],
      'result': result,
      'created_at': FieldValue.serverTimestamp(),
    });

    await _createScheduleNotifications(
      scheduleId: scheduleDoc.id,
      title: title,
      result: result,
    );
  }

  static Future<void> _createScheduleNotifications({
    required String scheduleId,
    required String title,
    required Map<String, dynamic> result,
  }) async {
    final crop = result['crop']?.toString() ?? 'Plant';
    final district = result['district']?.toString() ?? '';
    final plantingDateStr = result['planting_date']?.toString() ?? '';
    final quantity = result['quantity']?.toString() ?? '';
    final waterTotal = result['water_total_per_day']?.toString() ?? '0';

    final schedule = Map<String, dynamic>.from(result['schedule'] ?? {});
    final splitApplications = schedule['splits_per_year']?.toString() ?? '6';

    final now = DateTime.now();
    final batch = _firestore.batch();

    // 💧 WATER reminders - next 3 days at 8:00 AM
    for (int i = 0; i < 3; i++) {
      final waterTime = DateTime(now.year, now.month, now.day + i, 8, 0);

      final doc = _notificationCollection.doc();

      batch.set(doc, {
        'userId': _uid,
        'scheduleId': scheduleId,
        'type': 'water_reminder',
        'title': 'Water Reminder',
        'message':
            '$crop schedule: Give about $waterTotal L of water for $quantity plants.',
        'crop': crop,
        'district': district,
        'planting_date': plantingDateStr,
        'scheduledAt': Timestamp.fromDate(waterTime),
        'sent': false,
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    // 🌿 FERTILIZER reminder - after 7 days at 8:00 AM
    final fertilizerTime = DateTime(now.year, now.month, now.day + 7, 8, 0);

    final fertilizerDoc = _notificationCollection.doc();

    batch.set(fertilizerDoc, {
      'userId': _uid,
      'scheduleId': scheduleId,
      'type': 'fertilizer_reminder',
      'title': 'Fertilizer Reminder',
      'message':
          '$crop schedule: Apply fertilizer ($splitApplications splits/year).',
      'crop': crop,
      'district': district,
      'planting_date': plantingDateStr,
      'scheduledAt': Timestamp.fromDate(fertilizerTime),
      'sent': false,
      'isRead': false,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // 🌤 WEATHER reminders - next 3 days at 7:30 AM
    for (int i = 0; i < 3; i++) {
      final weatherTime = DateTime(now.year, now.month, now.day + i, 7, 30);

      final doc = _notificationCollection.doc();

      batch.set(doc, {
        'userId': _uid,
        'scheduleId': scheduleId,
        'type': 'weather_alert',
        'title': 'Weather Alert',
        'message':
            '$crop in $district: Check weather before watering/fertilizing.',
        'crop': crop,
        'district': district,
        'planting_date': plantingDateStr,
        'scheduledAt': Timestamp.fromDate(weatherTime),
        'sent': false,
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
  }

  static Future<List<Map<String, dynamic>>> getSchedules() async {
    final snapshot =
        await _scheduleCollection.orderBy('created_at', descending: true).get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['doc_id'] = doc.id;
      return data;
    }).toList();
  }

  static Future<void> deleteSchedule(String docId) async {
    await _scheduleCollection.doc(docId).delete();

    final notifications = await _notificationCollection
        .where('userId', isEqualTo: _uid)
        .where('scheduleId', isEqualTo: docId)
        .get();

    final batch = _firestore.batch();

    for (final doc in notifications.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }
}