import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationRepository {
  static final NotificationRepository _instance =
      NotificationRepository._internal();
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  factory NotificationRepository() {
    return _instance;
  }

  NotificationRepository._internal();

  Future<void> setupForegroundMessage() async {
    if (_messaging.isAutoInitEnabled) {
      final token = await _messaging.getToken();
      print(token);
    }
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        _showNotificationInUI(
          title: message.notification!.title ?? '',
          body: message.notification!.body ?? '',
        );
      }
    });
  }

  Future<void> setupBackgroundMessage() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
    if (message.notification != null) {
      _showNotificationInUI(
        title: message.notification!.title ?? '',
        body: message.notification!.body ?? '',
      );
    }
  }

  Future<void> handleNotificationPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  Future<void> _showNotificationInUI(
      {required String title, required String body}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your_channel_id', 'your_channel_name',
            icon: '@mipmap/ic_launcher',
            importance: Importance.max,
            priority: Priority.high);

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  static Future showTextNotification({
    int id = 0,
    required String title,
    required String body,
    bool playSound = true,
    bool enableVibration = true,
    var payload,
  }) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      "default_value",
      "channel_id_5",
      playSound: true,
      importance: Importance.max,
      priority: Priority.max,
      showWhen: true,
      showProgress: true,
      enableVibration: true,
    );

    var not = NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(id, title, body, not);
  }
}
