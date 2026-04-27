import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'notification_helper.dart';

class FCMService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static bool _isInitialized = false;

  static Future<void> init() async {
    try {
      await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      final token = await _messaging.getToken();
      debugPrint("🔥 FCM TOKEN: $token");

      if (token != null) {
        await saveCurrentToken();
      }

      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
        debugPrint("🔄 NEW FCM TOKEN: $newToken");
        await _saveTokenToFirestore(newToken);
      });

      if (!kIsWeb) {
        await _setupLocalNotifications();
      }

      if (!_isInitialized) {
        _listenForegroundMessages();
        _listenNotificationClick();
        _isInitialized = true;
      }
    } catch (e) {
      debugPrint("❌ FCM init error: $e");
    }
  }

  
  static Future<void> saveCurrentToken() async {
    try {
      final token = await _messaging.getToken();
      debugPrint("🔥 CURRENT FCM TOKEN: $token");

      if (token != null) {
        await _saveTokenToFirestore(token);
      }
    } catch (e) {
      debugPrint("❌ Failed to get/save current FCM token: $e");
    }
  }

  static Future<void> _saveTokenToFirestore(String token) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        debugPrint("⚠️ User not logged in. FCM token not saved.");
        return;
      }

      await FirebaseFirestore.instance.collection("users").doc(user.uid).set(
        {
          "fcmToken": token,
          "fcmTokenUpdatedAt": FieldValue.serverTimestamp(),
          "platform": kIsWeb ? "web" : "mobile",
        },
        SetOptions(merge: true),
      );

      debugPrint("✅ FCM token saved to Firestore");
    } catch (e) {
      debugPrint("❌ Failed to save FCM token: $e");
    }
  }

  static Future<void> _saveNotificationToFirestore({
    required String title,
    required String body,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        debugPrint("⚠️ User not logged in. Notification not saved.");
        return;
      }

      await FirebaseFirestore.instance.collection("notifications").add({
        "userId": user.uid,
        "title": title,
        "body": body,
        "isRead": false,
        "type": "fcm",
        "createdAt": FieldValue.serverTimestamp(),
      });

      debugPrint("✅ Notification saved to Firestore");
    } catch (e) {
      debugPrint("❌ Failed to save notification: $e");
    }
  }

  static Future<void> _setupLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(settings);

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'GrowWise important alerts and reminders',
      importance: Importance.max,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static void _listenForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final title = message.notification?.title ?? "GrowWise Alert";
      final body = message.notification?.body ?? "";

      debugPrint("📩 FOREGROUND MESSAGE: $title");

      await _saveNotificationToFirestore(
        title: title,
        body: body,
      );

      if (kIsWeb) {
        showWebForegroundNotification(
          title: title,
          body: body,
        );
      } else {
        _showLocalNotification(
          title: title,
          body: body,
        );
      }
    });
  }

  static void _listenNotificationClick() {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint("👉 Notification clicked");
    });
  }

  static Future<void> _showLocalNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'GrowWise important alerts and reminders',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
    );
  }
}