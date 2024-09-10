import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:laundry/components/LSNavBarCourier.dart';
import 'package:laundry/fragmentsCourier/LSMissionFragment.dart';
import 'package:laundry/main.dart';
import 'package:laundry/model/LSMissionModel.dart';
import 'package:laundry/services/LSAuthService.dart';
import 'package:laundry/services/api/LSCommandeAPI.dart';
import 'package:laundry/services/api/LSMissionAPI.dart';
import 'package:laundry/utils/LSColors.dart';
import 'package:laundry/utils/LSImages.dart';
import 'package:laundry/utils/LSWidgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LSMissionStatusScreen extends StatefulWidget {
  static String tag = '/LSOrderStatusScreen';
  final LSMissionModel? data;

  LSMissionStatusScreen(this.data);

  final storage = FlutterSecureStorage();

  @override
  LSMissionStatusScreenState createState() => LSMissionStatusScreenState();
}

class LSMissionStatusScreenState extends State<LSMissionStatusScreen> {


  int selectedIndex = 3;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
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
              onPressed: () async {
                await Provider.of<LSCommandeAPI>(context, listen: false).deleteCommande(widget.data!.commandeID);
                await Provider.of<LSMissionAPI>(context, listen: false).updateMission(widget.data!.missionID, context);
                Navigator.of(context).pop(); // Close the dialog
                LSMissionFragment().launch(context); // Go back to the previous screen
                toast('Commande annulée avec succès');
              },
            ),
          ],
        );
      },
    );
  }
  void _markPickedUp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Êtes-vous sûr de vouloir marquer la commande comme ramassée?'),
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
              onPressed: () async {
                await Provider.of<LSCommandeAPI>(context, listen: false).pickup(widget.data!.commandeID);
                Navigator.of(context).pop();
                LSMissionFragment().launch(context);
                toast('Commande marquée comme ramassée');
              },
            ),
          ],
        );
      },
    );
  }
  void _markDelivered() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Êtes-vous sûr de vouloir marquer la commande comme livrée?'),
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
              onPressed: () async {
                await Provider.of<LSCommandeAPI>(context, listen: false).deliver(widget.data!.commandeID);
                Navigator.of(context).pop();
                LSMissionFragment().launch(context);
                toast('Commande marquée comme livrée');
              },
            ),
          ],
        );
      },
    );
  }

  bool _canCancelOrder() {
    bool isNotPickedUp = !widget.data!.order!.isPickedUp;
    bool isWithin12Hours = DateTime.now().difference(widget.data!.order!.confirmationTimestamp).inHours < 12;

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
    final dateFormat = DateFormat('d MMMM' " à " 'kk:mm', 'fr_FR');

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
                      Text('${widget.data!.order!.totalPrice.toString()} DT', style: boldTextStyle()),
                    ],
                  ),
                  4.height,
                  Text(widget.data!.order!.id.toString(), style: secondaryTextStyle(),),
                  Divider(),
                  Text('Statut de la commande', style: boldTextStyle()),
                  Divider(),
                  if (widget.data!.order!.isConfirmed) ...[
                    statusView('Confirmé', 'La commande a été confirmée le \n${dateFormat.format(widget.data!.order!.confirmationTimestamp)}', LSConfirm),
                    Container(
                      height: 30,
                      width: 2,
                      color: greenColor,
                      margin: EdgeInsets.only(left: 10),
                    ),
                  ],
                  if (widget.data!.order!.isPickedUp) ...[
                    statusView('Ramassé', 'La commande a été ramassée le \n${dateFormat.format(widget.data!.order!.pickUpDate)}', LSPickup),
                    Container(
                      height: 30,
                      width: 2,
                      color: greenColor,
                      margin: EdgeInsets.only(left: 10),
                    ),
                  ],
                  if (widget.data!.order!.isInProgress) ...[
                    statusView('En cours', widget.data!.order!.isShipped? 'La commande à été traité':'La commande est en cours de traitement', LSInProgress),
                    Container(
                      height: 30,
                      width: 2,
                      color: greenColor,
                      margin: EdgeInsets.only(left: 10),
                    ),
                  ],
                  if (widget.data!.order!.isShipped) ...[
                    statusView('Expédié', widget.data!.order!.isDelivered? 'La commande à été expédié':'La commande est en cours de livraison', LSShipping),
                    Container(
                      height: 30,
                      width: 2,
                      color: grey.withOpacity(0.5),
                      margin: EdgeInsets.only(left: 10),
                    ),
                  ],
                  if (widget.data!.order!.isDelivered) ...[
                    Stack(
                      children: [
                        statusView('Livrée', 'La commande a été livrée le ${dateFormat.format(widget.data!.order!.deliveryDate)}', LSWalk3),
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
                    16.height,
                  ],
                  if (Provider.of<LSAuthService>(context, listen: false).user?.role != 'Client' && !widget.data!.order!.isPickedUp) ...[
                    Center( // This centers the button horizontally
                      child: AppButton(
                        text: 'Marquer comme ramassé',
                        color: Colors.greenAccent,
                        textStyle: boldTextStyle(color: Colors.white),
                        onTap: _markPickedUp,
                      ),
                    ),
                  ],
                  if (Provider.of<LSAuthService>(context, listen: false).user?.role != 'Client' && widget.data!.order!.isPickedUp && !widget.data!.order!.isDelivered) ...[
                    Center( // This centers the button horizontally
                      child: AppButton(
                        text: 'Marquer comme livré',
                        color: Colors.greenAccent,
                        textStyle: boldTextStyle(color: Colors.white),
                        onTap: _markDelivered,
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
                      Text(widget.data!.order!.address.toString(), style: secondaryTextStyle()),
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
      bottomNavigationBar: LSNavBarCourier(selectedIndex: 3),
    );
  }
}
