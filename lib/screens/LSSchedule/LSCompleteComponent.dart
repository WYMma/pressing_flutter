import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:intl/intl.dart';

import '../../main.dart';
import '../../model/LSOrder.dart';
import '../../utils/LSColors.dart';
import '../../utils/LSImages.dart';
import '../../utils/LSWidgets.dart';

class LSCompleteComponent extends StatefulWidget {
  static String tag = '/LSCompleteComponent';
  final LSOrder? data;

  LSCompleteComponent(this.data);

  @override
  LSCompleteComponentState createState() => LSCompleteComponentState();
}

class LSCompleteComponentState extends State<LSCompleteComponent> {
  ValueNotifier<int> buttonClickedTimes = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void dispose() {
    buttonClickedTimes.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: appStore.isDarkModeOn ? context.scaffoldBackgroundColor : LSColorSecondary.withOpacity(0.55),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.height,
            commonCacheImageWidget(LSWalk2, 80, fit: BoxFit.cover).center(),
            16.height,
            Text('Merci de nous avoir choisis !', style: boldTextStyle(size: 24)).center(),
            8.height,
            Container(
              margin: EdgeInsets.all(16),
              decoration: boxDecorationWithRoundedCorners(backgroundColor: context.cardColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  4.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Nom du magasin', style: boldTextStyle()),
                      Text('Pressing Nefatti', style: primaryTextStyle()),
                    ],
                  ).paddingOnly(left: 16, right: 16, top: 8),
                  4.height,
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Montant final', style: boldTextStyle()),
                      Text(widget.data!.totalPrice.toString() + ' DT', style: primaryTextStyle()),
                    ],
                  ).paddingOnly(left: 16, right: 16, top: 8),
                  4.height,
                  Divider(),
                  Text('Date & Heure du ramassage', style: boldTextStyle()).paddingOnly(left: 16, right: 16, top: 8),
                  4.height,
                  Text(DateFormat('dd/MM/yyyy').format(widget.data!.pickUpDate) + ' à ' + DateFormat('kk:mm a').format(widget.data!.pickUpDate), style: secondaryTextStyle()).paddingOnly(left: 16, right: 16),
                  Divider(),
                  Text('Méthode de paiement', style: boldTextStyle()).paddingOnly(left: 16, right: 16, top: 8),
                  Text(widget.data!.paymentMethod.toString(), style: secondaryTextStyle()).paddingOnly(left: 16, right: 16),
                  4.height,
                  Divider(),
                  Text('Méthode de livraison', style: boldTextStyle()).paddingOnly(left: 16, right: 16, top: 8),
                  Text(widget.data!.deliveryType.toString(), style: secondaryTextStyle()).paddingOnly(left: 16, right: 16),
                  16.height,
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
