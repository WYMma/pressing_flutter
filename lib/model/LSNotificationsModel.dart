import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LSNotificationsModel {
  late RemoteMessage message;
  late bool isRead;
  static List<LSNotificationsModel> notifications = [];
  static int unreadCount = 0;

  LSNotificationsModel({required this.message, required this.isRead});

  // Convert LSNotificationsModel to a map that can be stored as JSON
  Map<String, dynamic> toMap() {
    return {
      'message': {
        'title': message.notification?.title,
        'body': message.notification?.body,
        'data': message.data,
        'sentTime': message.sentTime?.toIso8601String(), // Use sentTime directly from RemoteMessage
      },
      'isRead': isRead,
    };
  }

  // Create an LSNotificationsModel from a map
  factory LSNotificationsModel.fromMap(Map<String, dynamic> map) {
    RemoteMessage message = RemoteMessage(
      notification: RemoteNotification(
        title: map['message']['title'],
        body: map['message']['body'],
      ),
      data: Map<String, dynamic>.from(map['message']['data']),
      sentTime: map['message']['sentTime'] != null
          ? DateTime.parse(map['message']['sentTime'])
          : null,
    );
    return LSNotificationsModel(
      message: message,
      isRead: map['isRead'],
    );
  }

  void setIsRead() {
    isRead = true;
    unreadCount--;
    saveNotifications(); // Save state after marking as read
  }

  // Add notification to list and save it to persistent storage
  static void addNotification(RemoteMessage notification) {
    notifications.insert(
      0,
      LSNotificationsModel(
        message: notification,
        isRead: false,
      ),
    );
    unreadCount++;
    saveNotifications(); // Save the updated notifications list
  }

  // Save notifications to SharedPreferences
  static Future<void> saveNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> notificationJsons = notifications.map((notification) {
      return jsonEncode(notification.toMap());
    }).toList();
    prefs.setStringList('notifications', notificationJsons);
    prefs.setInt('unreadCount', unreadCount);
  }

  // Load notifications from SharedPreferences
  static Future<void> loadNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? notificationJsons = prefs.getStringList('notifications');
    unreadCount = prefs.getInt('unreadCount') ?? 0;

    if (notificationJsons != null) {
      notifications = notificationJsons.map((jsonString) {
        return LSNotificationsModel.fromMap(jsonDecode(jsonString));
      }).toList();
    }
  }
}
