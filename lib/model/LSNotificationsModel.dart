import 'package:firebase_messaging/firebase_messaging.dart';


class LSNotificationsModel {
  late RemoteMessage message;
  late bool isRead;
  static List<LSNotificationsModel> notifications = [];
  static int unreadCount = 0;

  LSNotificationsModel({required this.message, required this.isRead});

  void setIsRead() {
    isRead = true;
    unreadCount--;
  }

  static void addNotification(RemoteMessage notification) {
    notifications.insert(0,LSNotificationsModel(message: notification, isRead: false));
    unreadCount++;
  }

 }