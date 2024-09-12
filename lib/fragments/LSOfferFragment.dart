import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:laundry/components/LSNavBar.dart';
import 'package:laundry/fragments/LSCartFragment.dart';
import 'package:laundry/main.dart';
import 'package:laundry/model/LSNotificationsModel.dart';
import 'package:laundry/model/LSSalesModel.dart';
import 'package:laundry/model/LSServicesModel.dart';
import 'package:laundry/screens/LSNotificationsScreen.dart';
import 'package:laundry/screens/LSProductListScreen.dart';
import 'package:laundry/services/api/LSSalesAPI.dart';
import 'package:laundry/services/localDB/LSCartProvider.dart';
import 'package:laundry/utils/LSConstants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../utils/LSColors.dart';
import '../utils/LSWidgets.dart';

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
    await 2.microseconds.delay;
    setStatusBarColor(context.cardColor);
    try {
      await Provider.of<LSSalesAPI>(context, listen: false).getAllSales();
    } catch (e) {
      print('Error fetching sales: $e');
    }
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
    final sales = LSSalesModel.sales;

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
        itemCount: sales.length,
        shrinkWrap: true,
        padding: EdgeInsets.all(8),
        itemBuilder: (_, i) {
          final sale = sales[i];
          bool expired = sale.isOfferExpired();

          return Container(
            margin: EdgeInsets.only(top: 16, left: 16, right: 16),
            padding: EdgeInsets.only(top: 24, bottom: 24, left: 12, right: 12),
            decoration: boxDecorationRoundedWithShadow(8, backgroundColor: context.cardColor),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                commonCacheImageWidget(host+sale.image, 80, fit: BoxFit.cover).center(),
                16.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(sale.name.validate(), style: primaryTextStyle()),
                    Text('Obtenez ${(sale.discount * 100).floor()}% de réduction', style: primaryTextStyle(color: LSColorPrimary, size: 16)),
                    AppButton(
                      padding: EdgeInsets.only(top: 8, bottom: 8, right: 24, left: 24),
                      textColor: white,
                      text: expired ? "Expiré" : "Voir l'offre",
                      onTap: () {
                        if (!expired) {
                          LSProductListScreen(LSServicesModel.services.firstWhere((element) => element.serviceID == sale.serviceID)).launch(context);
                        }
                      },
                      color: expired ? Colors.grey : LSColorPrimary,
                    ).paddingOnly(top: 8),
                  ],
                ).expand(),
              ],
            ),
          ).onTap(() {
            // Handle tap if needed
          });
        },
      ),
      bottomNavigationBar: LSNavBar(selectedIndex: _selectedIndex),
    );
  }
}
