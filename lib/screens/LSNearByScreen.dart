import 'package:flutter/material.dart';
import 'package:laundry/main.dart';
import 'package:laundry/model/LSServiceModel.dart';
import 'package:laundry/utils/LSColors.dart';
import 'package:laundry/utils/LSWidgets.dart';
import 'package:nb_utils/nb_utils.dart';

import 'ServiceDetail/LSServiceDetailScreen.dart';

class LSNearByScreen extends StatefulWidget {
  static String tag = '/LSNearByScreen';

  @override
  LSNearByScreenState createState() => LSNearByScreenState();
}

class LSNearByScreenState extends State<LSNearByScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.isDarkModeOn ? context.scaffoldBackgroundColor : LSColorSecondary,
      appBar: appBarWidget('Popular Laundry NearBy', center: true, color: context.cardColor),
      body: ListView.builder(
          itemCount: getNearByServiceList().length,
          shrinkWrap: true,
          padding: EdgeInsets.all(8),
          itemBuilder: (_, i) {
            LSServiceModel data = getNearByServiceList()[i];
            return Container(
              margin: EdgeInsets.all(8),
              decoration: boxDecorationRoundedWithShadow(8, backgroundColor: context.cardColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  commonCacheImageWidget(data.img.validate(), 120, width: context.width(), fit: BoxFit.cover).center().cornerRadiusWithClipRRectOnly(topLeft: 8, topRight: 8),
                  8.height,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(data.title.validate(), style: primaryTextStyle()).expand(),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.yellowAccent),
                              Text(data.rating.validate(), style: secondaryTextStyle()),
                            ],
                          )
                        ],
                      ),
                    ],
                  ).paddingOnly(left: 8, right: 8),
                  4.height,
                  Text(data.location.validate(), style: secondaryTextStyle()).paddingOnly(left: 8, right: 8),
                  8.height,
                  Text('145 Valencia St, San Francisco', style: secondaryTextStyle()).paddingOnly(left: 8, right: 8),
                  4.height,
                  Text('0.2 Km Away', style: boldTextStyle(size: 14, color: LSColorPrimary)).paddingOnly(left: 8, right: 8),
                  8.height,
                ],
              ),
            ).onTap(() {
              LSServiceDetailScreen().launch(context);
            });
          }),
    );
  }
}
