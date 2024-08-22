import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:laundry/components/LSNavBar.dart';
import 'package:laundry/localDB/LSCartProvider.dart';
import 'package:laundry/fragments/LSCartFragment.dart';
import 'package:laundry/model/LSNotificationsModel.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../components/LSBookingComponents.dart';
import '../main.dart';
import '../screens/LSNotificationsScreen.dart';
import '../utils/LSColors.dart';

class LSBookingFragment extends StatefulWidget {
  static String tag = '/LSBookingFragment';

  @override
  LSBookingFragmentState createState() => LSBookingFragmentState();
}

class LSBookingFragmentState extends State<LSBookingFragment> {
  int _selectedIndex = 3;
  @override
  void initState() {
    super.initState();
    init();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {});
    });
  }

  init() async {
    await 2.microseconds.delay;
    setStatusBarColor(context.cardColor);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: appStore.isDarkModeOn ? context.scaffoldBackgroundColor : LSColorSecondary,
        appBar: appBarWidget(
          'Historique',
          center: true,
          showBack: false,
          color: context.cardColor,
          actions: [
            InkWell(
              onTap: () {
                LSNotificationsScreen().launch(context);
              },
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
          bottom: TabBar(
            labelStyle: boldTextStyle(color: black, size: 18),
            unselectedLabelStyle: secondaryTextStyle(size: 16),
            labelColor: LSColorPrimary,
            unselectedLabelColor: appStore.isDarkModeOn ? white : black,
            isScrollable: false,
            tabs: [
              Tab(
                child: Align(
                  alignment: Alignment.center,
                  child: Text('En cours'),
                ),
              ),
              Tab(
                child: Align(
                  alignment: Alignment.center,
                  child: Text('Terminé'),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            LSBookingComponents('En cours'),
            LSBookingComponents('Terminé'),
          ],
        ),
        bottomNavigationBar: LSNavBar(selectedIndex: _selectedIndex),
      ),
    );
  }

}
