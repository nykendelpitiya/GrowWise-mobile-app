// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

Future<void> showWebForegroundNotification({
  required String title,
  required String body,
}) async {
  if (html.Notification.permission == 'granted') {
    html.Notification(title, body: body);
  } else if (html.Notification.permission != 'denied') {
    final permission = await html.Notification.requestPermission();
    if (permission == 'granted') {
      html.Notification(title, body: body);
    }
  }
}