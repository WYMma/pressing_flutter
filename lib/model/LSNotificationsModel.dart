import 'package:firebase_messaging/firebase_messaging.dart';


class LSNotificationsModel {
  late RemoteMessage message;
  late bool isRead;

  LSNotificationsModel({required this.message, required this.isRead});

  void setIsRead() {
    this.isRead = true;
  }

  static List<LSNotificationsModel> notifications = [];


 }