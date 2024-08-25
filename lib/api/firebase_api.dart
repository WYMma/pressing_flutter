import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:laundry/model/LSNotificationsModel.dart';
import 'package:nb_utils/nb_utils.dart';

class FirebaseAPI {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
    'your_channel_id',  // Match the channel ID used in LocalNotifications
    'Your Channel Name',
    description: 'Your channel description',
    importance: Importance.max,  // Match importance
    // No need to specify priority here as it's managed in the NotificationDetails
  );

  final _localNotifications = FlutterLocalNotificationsPlugin();

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    navigatorKey.currentState!.pushNamed('/LSNotificationScreen');
  }

  Future<void> initPushNotifications() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;
      LSNotificationsModel.addNotification(message);
      // Match the NotificationDetails settings to LocalNotifications
      const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
        'your_channel_id',  // Use the same channel ID as in LocalNotifications
        'Your Channel Name',
        channelDescription: 'Your channel description',
        importance: Importance.max,
        priority: Priority.high,  // Set priority to high
        ticker: 'ticker',
        icon: '@mipmap/ic_launcher', // Match the icon used in LocalNotifications
      );

      const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);

      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        notificationDetails,
        payload: jsonEncode(message.toMap()),
      );
    });
  }

  Future<void> initLocalNotifications() async {
    const iOS = DarwinInitializationSettings();
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android, iOS: iOS);
    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (payload) {
        final message = RemoteMessage.fromMap(jsonDecode(payload as String));
        handleMessage(message);
      },
    );

    final platform = _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future<void> initNotifications() async {
    await messaging.requestPermission();
    final FCMToken = await messaging.getToken();
    print('token: $FCMToken');
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    initPushNotifications();
    initLocalNotifications();
  }
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
  LSNotificationsModel.notifications.add(LSNotificationsModel(message: message, isRead: false));
}
