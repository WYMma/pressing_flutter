import 'package:flutter/material.dart';
import 'package:laundry/model/LSSalesModel.dart';
import 'package:laundry/model/LSServicesModel.dart';
import 'package:laundry/screens/LSProductListScreen.dart';
import 'package:laundry/utils/LSConstants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../services/api/LSSalesAPI.dart';
import '../utils/LSColors.dart';
import '../utils/LSWidgets.dart';

class LSSOfferPackageComponent extends StatefulWidget {
  static String tag = '/LSOfferPackageComponent';

  @override
  LSSOfferPackageComponentState createState() => LSSOfferPackageComponentState();
}

class LSSOfferPackageComponentState extends State<LSSOfferPackageComponent> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    try {
      await Provider.of<LSSalesAPI>(context, listen: false).getAllSales();
    } catch (e) {
      print('Error fetching sales: $e');
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {

    return HorizontalList(
      itemCount: LSSalesModel.sales.take(4).length,
      itemBuilder: (BuildContext context, int index) {
        final sale = LSSalesModel.sales[index];
        bool expired = sale.isOfferExpired();

        return Container(
          width: 280,
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.only(top: 24, bottom: 24, left: 8, right: 8),
          decoration: boxDecorationRoundedWithShadow(8, backgroundColor: context.cardColor),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              commonCacheImageWidget(host + sale.image, 80, fit: BoxFit.cover).center(),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(sale.name.validate(), style: primaryTextStyle()),
                  Text('Promotion: ${(sale.discount * 100).floor()}%', style: primaryTextStyle(color: LSColorPrimary, size: 18)),
                  8.height,
                  AppButton(
                    padding: EdgeInsets.only(top: 8, bottom: 8, right: 16, left: 16),
                    textColor: white,
                    text: expired ? "Expiré" : "Voir l'offre",
                    onTap: () {
                      if (!expired) {
                        LSProductListScreen(LSServicesModel.services.firstWhere((element) => element.serviceID == sale.serviceID)).launch(context);
                      }
                    },
                    color: expired ? Colors.grey : LSColorPrimary,
                  )
                ],
              ).expand(),
            ],
          ),
        ).onTap(() {
          // Handle tap if needed
        });
      },
    );
  }
}
