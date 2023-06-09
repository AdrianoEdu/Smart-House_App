import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  ///Initialize notification component
  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    print("Initializing FlutterLocalNotificationsPlugin");
    var androidInitialize =
        const AndroidInitializationSettings('mipmap/ic_launcher');
    var iOSInitialize = const DarwinInitializationSettings();
    var initiationSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    await flutterLocalNotificationsPlugin.initialize(initiationSettings);
  }

  ///Show Notification
  static Future showBigTextNotification(
      {var id = 0,
      required String title,
      required String body,
      var payload,
      required FlutterLocalNotificationsPlugin fln}) async {
    print("Show big text notification $title $body");
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails('channel_id 6', 'channelName',
            playSound: true,
            importance: Importance.max,
            priority: Priority.high);

    var notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: const DarwinNotificationDetails());

    await fln.show(0, title, body, notificationDetails);
  }
}
