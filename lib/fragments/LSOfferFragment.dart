import 'package:flutter/material.dart';
import 'package:laundry/components/LSNavBar.dart';
import 'package:laundry/db/LSCartProvider.dart';
import 'package:laundry/fragments/LSCartFragment.dart';
import 'package:laundry/main.dart';
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

class LLSOfferFragmentState extends State<LSOfferFragment> with AutomaticKeepAliveClientMixin {

  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    init();
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

  @override
  bool get wantKeepAlive => true;
}
