import 'package:flutter/material.dart';
import 'package:laundry/components/LSNavBar.dart';
import 'package:laundry/db/LSCartProvider.dart';
import 'package:laundry/fragments/LSCartFragment.dart';
import 'package:laundry/main.dart';
import 'package:laundry/utils/LSColors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class LSNotificationsScreen extends StatefulWidget {
  const LSNotificationsScreen({Key? key}) : super(key: key);
  static String tag = '/LSNotificationScreen';

  @override
  _LSNotificationsScreenState createState() => _LSNotificationsScreenState();
}

class _LSNotificationsScreenState extends State<LSNotificationsScreen> {
  List<bool> isReadList = List.generate(15, (index) => false);
  // Track read/unread status

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        'Notifications',
        center: true,
        color: context.cardColor,
        actions: [
            IconButton(
              icon: Icon(Icons.notifications_none),
              color: context.iconColor,
              onPressed: () {
                LSNotificationsScreen().launch(context);
              },
            ),
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
      backgroundColor: appStore.isDarkModeOn ? context.scaffoldBackgroundColor : LSColorSecondary,
      body: listView(),
      floatingActionButton: FloatingActionButton(
        onPressed: markAllAsRead,
        tooltip: 'Mark All as Read',
        child: Icon(Icons.check),
        backgroundColor: Colors.green,
      ),
      bottomNavigationBar: LSNavBar(selectedIndex: -1,),
    );
  }

  void markAllAsRead() {
    setState(() {
      isReadList = List.generate(15, (index) => true); // Mark all as read
    });
  }

  Widget listView() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => markAsRead(index),
          child: Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: listViewItem(index),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: 8);
      },
      itemCount: 15,
    );
  }

  void markAsRead(int index) {
    setState(() {
      isReadList[index] = true; // Mark the notification as read
    });
  }

  Widget listViewItem(int index) {
    bool isRead = isReadList[index];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        prefixIcon(isRead),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              message(index),
              SizedBox(height: 8),
              timeAndDate(index),
            ],
          ),
        ),
      ],
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
      child: Icon(Icons.notifications, color: isRead ? Colors.grey.shade700 : Colors.white, size: 25),
    );
  }

  Widget message(int index) {
    return Text(
      'Notification Description $index',
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget timeAndDate(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '03-07-2024',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        Text(
          '07:30 AM',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}
