import 'package:flutter/material.dart';
import 'package:laundry/components/LSNavBar.dart';
import 'package:laundry/main.dart';
import 'package:laundry/model/LSOrder.dart';
import 'package:laundry/utils/LSColors.dart';
import 'package:laundry/utils/LSImages.dart';
import 'package:laundry/utils/LSWidgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart'; // Add this import for launching URLs

class LSOrderStatusScreen extends StatefulWidget {
  static String tag = '/LSOrderStatusScreen';
  final LSOrder? data;

  LSOrderStatusScreen(this.data);

  @override
  LSOrderStatusScreenState createState() => LSOrderStatusScreenState();
}

class LSOrderStatusScreenState extends State<LSOrderStatusScreen> {

  int _selectedIndex = 3;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  void _cancelOrder() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Êtes-vous sûr de vouloir annuler la commande ?'),
          actions: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.cancel, color: Colors.red), // Add your trailing icon
              label: Text('Non', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton.icon(
              icon: Icon(Icons.check_circle, color: LSColorPrimary), // Add your trailing icon
              label: Text('Oui', style: TextStyle(color: LSColorPrimary, fontWeight: FontWeight.bold)),
              onPressed: () {
                LSOrder.removeOrder(widget.data!);
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pop(context); // Close the order status screen
                Navigator.pop(context); // Go back to the previous screen
                toast('Commande annulée avec succès');
              },
            ),
          ],
        );
      },
    );
  }

  bool _canCancelOrder() {
    // Check if the order can be canceled
    bool isNotPickedUp = !widget.data!.isPickedUp;
    bool isWithin12Hours = DateTime.now().difference(widget.data!.confirmationTimestamp).inHours < 12;

    return isNotPickedUp && isWithin12Hours;
  }

  Widget statusView(String? title, String? subTitle, String? icon) {
    return Row(
      children: [
        commonCacheImageWidget(icon.validate(), 30, width: 30, fit: BoxFit.cover),
        8.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title.validate(value: ''), style: boldTextStyle()),
              ],
            ),
            Text(subTitle.validate(), style: secondaryTextStyle()),
          ],
        ).expand()
      ],
    );
  }

  void _callDeliveryAgent() async {
    const phoneNumber = 'tel:+21622869369';
    if (await canLaunchUrlString(phoneNumber)) {
      await launchUrlString(phoneNumber);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d MMMM' " à " 'kk:mm', 'fr_FR'); // French date format

    return Scaffold(
      backgroundColor: appStore.isDarkModeOn ? context.scaffoldBackgroundColor : LSColorSecondary,
      appBar: appBarWidget('Statut de la commande', center: true, color: context.cardColor),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Numéro de commande:', style: boldTextStyle()),
                      Text('${widget.data!.totalPrice.toString()} DT', style: boldTextStyle()),
                    ],
                  ),
                  4.height,
                  Text('${widget.data!.id.toString()}', style: secondaryTextStyle(),),
                  Divider(),
                  Text('Statut de la commande', style: boldTextStyle()),
                  Divider(),
                  if (widget.data!.isConfirmed) ...[
                    statusView('Confirmé', 'La commande a été confirmée le \n${dateFormat.format(widget.data!.confirmationTimestamp)}', LSConfirm),
                    Container(
                      height: 30,
                      width: 2,
                      color: greenColor,
                      margin: EdgeInsets.only(left: 10),
                    ),
                  ],
                  if (widget.data!.isPickedUp) ...[
                    statusView('Ramassé', 'La commande a été ramassée le \n${dateFormat.format(widget.data!.pickUpDate)}', LSPickup),
                    Container(
                      height: 30,
                      width: 2,
                      color: greenColor,
                      margin: EdgeInsets.only(left: 10),
                    ),
                  ],
                  if (widget.data!.isInProgress) ...[
                    statusView('En cours', 'La commande est en cours de traitement', LSInProgress),
                    Container(
                      height: 30,
                      width: 2,
                      color: greenColor,
                      margin: EdgeInsets.only(left: 10),
                    ),
                  ],
                  if (widget.data!.isShipped) ...[
                    statusView('Expédié', 'La commande est en cours de livraison', LSShipping),
                    Container(
                      height: 30,
                      width: 2,
                      color: grey.withOpacity(0.5),
                      margin: EdgeInsets.only(left: 10),
                    ),
                  ],
                  if (widget.data!.isDelivered) ...[
                    Stack(
                      children: [
                        statusView('Livré', 'La commande a été livrée le ${dateFormat.format(widget.data!.deliveryDate)}', LSWalk3),
                        Container(
                          height: 40,
                          width: context.width(),
                          color: appStore.isDarkModeOn ? Colors.transparent : white.withOpacity(0.6),
                        )
                      ],
                    ),
                  ],
                  16.height,
                  if (_canCancelOrder()) ...[
                    Center( // This centers the button horizontally
                      child: AppButton(
                        text: 'Annuler la commande',
                        color: Colors.red,
                        textStyle: boldTextStyle(color: Colors.white),
                        onTap: _cancelOrder,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              width: context.width(),
              margin: EdgeInsets.only(left: 16, right: 16),
              padding: EdgeInsets.all(16),
              decoration: boxDecorationWithRoundedCorners(backgroundColor: context.cardColor),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: boxDecorationWithRoundedCorners(borderRadius: BorderRadius.circular(40), backgroundColor: Colors.blue.shade50),
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.pin_drop, size: 30, color: Colors.red),
                  ),
                  16.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      4.height,
                      Text('Adresse Ramassage & Livraison', style: boldTextStyle()), // Translated title
                      4.height,
                      Text(widget.data!.address.toString(), style: secondaryTextStyle()),
                    ],
                  ).expand()
                ],
              ),
            ),
            Container(
              width: context.width(),
              margin: EdgeInsets.only(top: 16, left: 16, right: 16),
              padding: EdgeInsets.all(16),
              decoration: boxDecorationWithRoundedCorners(backgroundColor: context.cardColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  12.height,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: boxDecorationWithShadow(borderRadius: BorderRadius.circular(8)),
                        padding: EdgeInsets.all(16),
                        child: commonCacheImageWidget(LSLogoBig, 50, width: 50, fit: BoxFit.cover),
                      ),
                      16.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          4.height,
                          Text('Pressing Nefatti', style: boldTextStyle()),
                          4.height,
                          12.height,
                          Text('Av. de la République, Gabes, Tunisie', style: secondaryTextStyle()), // Translated address
                          8.height,
                        ],
                      ).expand(),
                      GestureDetector(
                        onTap: _callDeliveryAgent,
                        child: Container(
                          decoration: boxDecorationWithRoundedCorners(borderRadius: BorderRadius.circular(40), backgroundColor: Colors.blue.shade50),
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.call, size: 30, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            16.height,
          ],
        ),
      ),
      bottomNavigationBar: LSNavBar(selectedIndex: _selectedIndex),
    );
  }
}
