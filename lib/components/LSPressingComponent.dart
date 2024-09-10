import 'package:flutter/material.dart';
import 'package:laundry/model/LSPressingModel.dart';
import 'package:laundry/utils/LSConstants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../screens/LSServiceDetailScreen.dart';
import '../utils/LSWidgets.dart';

class LSPressingComponent extends StatefulWidget {
  static String tag = '/LSServiceNearByComponent';

  @override
  LSPressingComponentState createState() => LSPressingComponentState();
}

class LSPressingComponentState extends State<LSPressingComponent> {
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
    return HorizontalList(
      itemCount: LSPressingModel.pressings.length,
      itemBuilder: (BuildContext context, int index) {
        LSPressingModel data = LSPressingModel.pressings[index];

        return Container(
          width: context.width() * 0.62,
          margin: EdgeInsets.all(8),
          decoration: boxDecorationRoundedWithShadow(8, backgroundColor: context.cardColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              commonCacheImageWidget(host+data.image, 120, width: context.width(), fit: BoxFit.cover).center().cornerRadiusWithClipRRectOnly(topLeft: 8, topRight: 8),
              8.height,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(data.name, style: primaryTextStyle()).expand(),
                    ],
                  ),
                ],
              ).paddingOnly(left: 8, right: 8),
              4.height,
              Text(data.writtenAddress, style: secondaryTextStyle()).paddingOnly(left: 8, right: 8),
              8.height,
            ],
          ),
        ).onTap(() {
          LSServiceDetailScreen(data).launch(context);
        });
      },
    );
  }
}
