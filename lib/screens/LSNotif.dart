import 'package:laundry/services/LSNotificationService.dart';
import 'package:laundry/components/LSNotificationButton.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class LSNotif extends StatelessWidget {
  const LSNotif({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Colors.grey[200]!,
              ],
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            LSNotificationButton(
              text: "Normal Notification",
              onPressed: () async {
                await LSNotificationService.showNotification(
                  title: "Title of the notification",
                  body: "Body of the notification",
                );
              },
            ),
            LSNotificationButton(
              text: "Notification With Summary",
              onPressed: () async {
                await LSNotificationService.showNotification(
                  title: "Title of the notification",
                  body: "Body of the notification",
                  summary: "Small Summary",
                  notificationLayout: NotificationLayout.Inbox,
                );
              },
            ),
            LSNotificationButton(
              text: "Progress Bar Notification",
              onPressed: () async {
                await LSNotificationService.showNotification(
                  title: "Title of the notification",
                  body: "Body of the notification",
                  summary: "Small Summary",
                  notificationLayout: NotificationLayout.ProgressBar,
                );
              },
            ),
            LSNotificationButton(
              text: "Message Notification",
              onPressed: () async {
                await LSNotificationService.showNotification(
                  title: "Title of the notification",
                  body: "Body of the notification",
                  summary: "Small Summary",
                  notificationLayout: NotificationLayout.Messaging,
                );
              },
            ),
            LSNotificationButton(
              text: "Big Image Notification",
              onPressed: () async {
                await LSNotificationService.showNotification(
                  title: "Title of the notification",
                  body: "Body of the notification",
                  summary: "Small Summary",
                  notificationLayout: NotificationLayout.BigPicture,
                  bigPicture:
                  "https://files.tecnoblog.net/wp-content/uploads/2019/09/emoji.jpg",
                );
              },
            ),
            LSNotificationButton(
              text: "Action Buttons Notification",
              onPressed: () async {
                await LSNotificationService.showNotification(
                    title: "Title of the notification",
                    body: "Body of the notification",
                    payload: {
                      "navigate": "true",
                    },
                    actionButtons: [
                      NotificationActionButton(
                        key: 'check',
                        label: 'Check it out',
                        actionType: ActionType.SilentAction,
                        color: Colors.green,
                      )
                    ]);
              },
            ),
            LSNotificationButton(
              text: "Scheduled Notification",
              onPressed: () async {
                await LSNotificationService.showNotification(
                  title: "Scheduled Notification",
                  body: "Notification was fired after 5 seconds",
                  scheduled: true,
                  interval: 5,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}