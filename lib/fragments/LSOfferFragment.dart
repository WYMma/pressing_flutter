import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:laundry/components/LSNavBar.dart';
import 'package:laundry/services/localDB/LSCartProvider.dart';
import 'package:laundry/fragments/LSCartFragment.dart';
import 'package:laundry/main.dart';
import 'package:laundry/model/LSNotificationsModel.dart';
import 'package:laundry/model/LSServiceModel.dart';
import 'package:laundry/screens/LSCoupon.dart';
import 'package:laundry/utils/LSColors.dart';
import 'package:laundry/utils/LSWidgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import '../screens/LSNotificationsScreen.dart';

class LSOfferFragment extends StatefulWidget {
  static String tag = '/LSOfferFragment';

  @override
  LLSOfferFragmentState createState() => LLSOfferFragmentState();
}

class LLSOfferFragmentState extends State<LSOfferFragment> {

  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    init();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {});
    });
  }

  init() async {
    setStatusBarColor(appStore.isDarkModeOn ? context.cardColor : Colors.white);
  }

  @override
  void dispose() {
    setStatusBarColor(appStore.isDarkModeOn ? context.cardColor : LSColorPrimary);
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        'Nos offres',
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
      ),
      backgroundColor: appStore.isDarkModeOn ? context.scaffoldBackgroundColor : LSColorSecondary,
      body: ListView.builder(
          itemCount: getOfferList().length,
          shrinkWrap: true,
          padding: EdgeInsets.all(8),
          itemBuilder: (_, i) {
            LSServiceModel data = getOfferList()[i];
            return Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.only(top: 24, bottom: 24, left: 8, right: 8),
              decoration: boxDecorationRoundedWithShadow(8, backgroundColor: context.cardColor),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  commonCacheImageWidget(data.img.validate(), 80, fit: BoxFit.cover).center(),
                  16.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(data.title.validate(), style: primaryTextStyle()),
                      Text(data.subTitle.validate(), style: primaryTextStyle(color: LSColorPrimary, size: 18)),
                      8.height,
                    ],
                  ).expand(),
                  8.width,
                  AppButton(
                    padding: EdgeInsets.only(top: 8, bottom: 8, right: 16, left: 16),
                    onTap: () {
                      LSCoupon().launch(context);
                    },
                    text: 'View Offer',
                    textColor: white,
                    color: LSColorPrimary,
                  )
                ],
              ),
            ).onTap(() {
            });
          }),
      bottomNavigationBar: LSNavBar(selectedIndex: _selectedIndex),
    );
  }

}
