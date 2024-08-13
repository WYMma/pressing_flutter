import 'package:flutter/material.dart';
import 'package:laundry/components/LSNavBar.dart';
import 'package:laundry/db/LSCartProvider.dart';
import 'package:laundry/fragments/LSCartFragment.dart';
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

class LSBookingFragmentState extends State<LSBookingFragment> with AutomaticKeepAliveClientMixin {
  int _selectedIndex = 3;
  @override
  void initState() {
    super.initState();
    init();
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
            IconButton(
              icon: Icon(Icons.notifications),
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

  @override
  bool get wantKeepAlive => true;
}
