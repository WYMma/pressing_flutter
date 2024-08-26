import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:laundry/components/LSNavBarCourier.dart';
import 'package:nb_utils/nb_utils.dart';

import '../components/LSBookingComponents.dart';
import '../main.dart';
import '../utils/LSColors.dart';

class LSMissionFragment extends StatefulWidget {
  static String tag = '/LSBookingFragment';

  @override
  LSMissionFragmentState createState() => LSMissionFragmentState();
}

class LSMissionFragmentState extends State<LSMissionFragment> {
  int _selectedIndex = 2;
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
        bottomNavigationBar: LSNavBarCourier(selectedIndex: _selectedIndex),
      ),
    );
  }

}
