import 'package:flutter/material.dart';
import 'package:laundry/components/LSNavBar.dart';
import 'package:laundry/main.dart';
import 'package:laundry/model/LSOrder.dart';
import 'package:laundry/model/LSServicesModel.dart';
import 'package:laundry/screens/LSOrderStatusScreen.dart';
import 'package:laundry/services/api/LSItemAPI.dart';
import 'package:laundry/utils/LSColors.dart';
import 'package:laundry/utils/LSImages.dart';
import 'package:laundry/utils/LSWidgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:intl/intl.dart';

class LSOrderDetailScreen extends StatefulWidget {
  static String tag = '/LSOrderDetailScreen';
  final LSOrder? data;

  LSOrderDetailScreen(this.data);

  @override
  LSOrderDetailScreenState createState() => LSOrderDetailScreenState();
}

class LSOrderDetailScreenState extends State<LSOrderDetailScreen> {
  int _selectedIndex = 3;

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

  Widget statusImage(String status) {
    switch (status) {
      case 'Confirmée':
        return commonCacheImageWidget(LSConfirm, 40, width: 40, fit: BoxFit.cover);
      case 'Ramassée':
        return commonCacheImageWidget(LSPickup, 40, width: 40, fit: BoxFit.cover);
      case 'En cours':
        return commonCacheImageWidget(LSInProgress, 40, width: 40, fit: BoxFit.cover);
      case 'Expédiée':
        return commonCacheImageWidget(LSShipping, 40, width: 40, fit: BoxFit.cover);
      case 'Livrée':
        return commonCacheImageWidget(LSWalk3, 40, width: 40, fit: BoxFit.cover);
      default:
        return commonCacheImageWidget(LSConfirm, 40, width: 40, fit: BoxFit.cover);
    }
  }

  String statusText(String status) {
    switch (status) {
      case 'Confirmé':
        return 'Votre commande a été confirmée';
      case 'Ramassée':
        return 'Votre commande a été ramassée';
      case 'En cours':
        return 'Votre commande est en cours de traitement';
      case 'Expédiée':
        return 'Votre commande est en cours de livraison';
      case 'Livrée':
        return 'Votre commande a été livrée';
      default:
        return 'Statut inconnu';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.isDarkModeOn ? context.scaffoldBackgroundColor : LSColorSecondary,
      appBar: appBarWidget('Détail de la commande', center: true, color: context.cardColor),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: context.width(),
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(16),
              decoration: boxDecorationWithRoundedCorners(backgroundColor: context.cardColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Commande No - ${widget.data!.id.validate()}', style: boldTextStyle()),
                  4.height,
                  Text(
                    '${DateFormat('dd/MM/yyyy').format(widget.data!.confirmationTimestamp)} à ${DateFormat('kk:mm a').format(widget.data!.confirmationTimestamp)}',
                    style: secondaryTextStyle(),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Methode Paiement', style: boldTextStyle(size: 14)),
                      Text(widget.data!.paymentMethod.toString(), style: secondaryTextStyle())
                    ],
                  ),
                  Divider(),
                  Text('Articles', style: boldTextStyle(size: 18)),
                  Divider(),
                  Container(
                    height: 250,
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10), // Adjust padding if necessary
                      itemCount: widget.data!.cartItems.length,
                      itemBuilder: (context, index) {
                        final item = widget.data!.cartItems[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 5), // Adjust padding if necessary
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text('${item.quantity.value}x ', style: primaryTextStyle()),
                                      Text(item.productName, style: primaryTextStyle()),
                                      Text(' (${LSItemAPI.categories[int.parse(item.categorieID)]})', style: secondaryTextStyle()),
                                    ],
                                  ),
                                  Text('${item.productPrice * item.quantity.value} DT', style: primaryTextStyle()),
                                ],
                              ),
                              Text(' (${LSServicesModel.services.firstWhere((element) => element.serviceID == int.parse(item.serviceID)).name})', style: secondaryTextStyle()),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.data!.deliveryType, style: boldTextStyle()),
                      if (widget.data!.deliveryType == 'Livraison Express')
                        Text('5.0 DT', style: primaryTextStyle())
                      else
                        Text('0.0 DT', style: primaryTextStyle())
                      ,
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total', style: boldTextStyle()),
                      Text('${widget.data!.totalPrice} DT', style: boldTextStyle()),
                    ],
                  ),
                  8.height,
                ],
              ),
            ),
            Container(
              width: context.width(),
              margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              padding: EdgeInsets.all(16),
              decoration: boxDecorationWithRoundedCorners(backgroundColor: context.cardColor),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: boxDecorationWithRoundedCorners(
                        borderRadius: BorderRadius.circular(40),
                        backgroundColor: LSColorSecondary
                    ),
                    padding: EdgeInsets.all(12),
                    child: statusImage(widget.data?.status as String),
                  ),
                  16.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(statusText(widget.data?.status as String), style: boldTextStyle()),
                      4.height,
                      Text('Voir les détails', style: boldTextStyle(color: LSColorPrimary)).onTap(() {
                        LSOrderStatusScreen(widget.data).launch(context);
                      }),
                      4.height,
                    ],
                  ).expand()
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: LSNavBar(selectedIndex: _selectedIndex),
    );
  }
}
