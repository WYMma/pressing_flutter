import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:laundry/components/LSNavBar.dart';
import 'package:laundry/services/localDB/LSCartProvider.dart';
import 'package:laundry/fragments/LSCartFragment.dart';
import 'package:laundry/main.dart';
import 'package:laundry/model/LSNotificationsModel.dart';
import 'package:laundry/utils/LSColors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class LSNotificationsScreen extends StatefulWidget {
  const LSNotificationsScreen({Key? key}) : super(key: key);
  static String tag = '/LSNotificationScreen';

  @override
  _LSNotificationsScreenState createState() => _LSNotificationsScreenState();
}

class _LSNotificationsScreenState extends State<LSNotificationsScreen> {

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        'Notifications',
        center: true,
        color: context.cardColor,
        actions: [
          InkWell(
            onTap: () {},
            child: Center(
              child: Badge(
                label: Text(LSNotificationsModel.unreadCount.toString(), style: TextStyle(color: Colors.white)),
                child: Icon(LSNotificationsModel.unreadCount == 0 ? Icons.notifications_none : Icons.notifications, color: context.iconColor),
              ),
            ),
          ),
          SizedBox(width: 10.0),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LSCartFragment()),
              );
            },
            child: Center(
              child: Badge(
                label: Consumer<LSCartProvider>(
                  builder: (context, value, child) {
                    return Text(
                      value.getCounter().toString(),
                      style: TextStyle(color: Colors.white),
                    );
                  },
                ),
                child: Icon(Icons.shopping_cart, color: context.iconColor),
              ),
            ),
          ),
          SizedBox(width: 20.0),
        ],
      ),
      backgroundColor: appStore.isDarkModeOn
          ? context.scaffoldBackgroundColor
          : LSColorSecondary,
      body: LSNotificationsModel.notifications.isEmpty
          ? Center(child: Text('Aucune notifications'))
          : ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 8),
        itemBuilder: (context, index) {
          RemoteMessage message = LSNotificationsModel.notifications[index].message;
          bool isRead = LSNotificationsModel.notifications[index].isRead;

          return GestureDetector(
            onTap: () => {
              if (!LSNotificationsModel.notifications[index].isRead) {
              LSNotificationsModel.notifications[index].setIsRead(),
              setState(() {})}
            },
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    prefixIcon(isRead),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.notification?.title ?? 'N/D',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isRead
                                  ? Colors.grey.shade700
                                  : Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            message.notification?.body ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              color: isRead
                                  ? Colors.grey.shade600
                                  : Colors.white70,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            formatTimestamp(message.sentTime),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(height: 8);
        },
        itemCount: LSNotificationsModel.notifications.length,
      ),
      bottomNavigationBar: LSNavBar(selectedIndex: 0),
    );
  }

  Widget prefixIcon(bool isRead) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: isRead ? Colors.transparent : Colors.blue, // Blue pin for unread
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.notifications,
        color: isRead ? Colors.grey.shade700 : Colors.white,
        size: 25,
      ),
    );
  }

  String formatTimestamp(DateTime? timestamp) {
    if (timestamp == null) return 'Unknown time';

    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      if (difference.inHours > 0) {
        return '${difference.inHours} hour(s) ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minute(s) ago';
      } else {
        return 'Just now';
      }
    } else if (difference.inDays == 1) {
      return 'Yesterday at ${DateFormat('HH:mm').format(timestamp)}';
    } else if (difference.inDays < 7) {
      return '${DateFormat('EEEE').format(timestamp)} at ${DateFormat('HH:mm').format(timestamp)}';
    } else {
      return '${DateFormat('dd-MM-yyyy').format(timestamp)} at ${DateFormat('HH:mm').format(timestamp)}';
    }
  }
}
