import 'package:flutter/material.dart';
import 'package:laundry/components/LSAddressListComponent.dart';
import 'package:laundry/db/LSCartProvider.dart';
import 'package:laundry/fragments/LSHomeFragment.dart';
import 'package:laundry/screens/LSSchedule/LSCompleteComponent.dart';
import 'package:laundry/screens/LSSchedule/LSDateTimeComponent.dart';
import 'package:laundry/screens/LSSchedule/LSPaymentMethodComponent.dart';
import 'package:laundry/services/LSLocalAuthService.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:laundry/db/LSDBHelper.dart';

import '../../main.dart';
import '../../model/LSOrder.dart';
import '../../utils/LSColors.dart';

class LSScheduleScreen extends StatefulWidget {
  static String tag = '/LSScheduleScreen';

  @override
  LSScheduleScreenState createState() => LSScheduleScreenState();
}

class LSScheduleScreenState extends State<LSScheduleScreen> {
  int currentPage = 0;
  String btnTitle = 'Sélectionner l\'adresse'.toUpperCase();
  LSOrder order = LSOrder();
  PageController _pageController = PageController();
  DateTime? lastPressed;

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
    _pageController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void refreshAddressList() {
    setState(() {});
  }

  void _clearCart() async {
    final cartProvider = Provider.of<LSCartProvider>(context, listen: false);
    final dbHelper = LSDBHelper();

    cartProvider.clearCart();
    await dbHelper.clearCart();
  }

  void updateButtonTitle() {
    switch (currentPage) {
      case 0:
        btnTitle = 'Sélectionner l\'adresse'.toUpperCase();
        break;
      case 1:
        btnTitle = 'Date du ramassage'.toUpperCase();
        break;
      case 2:
        btnTitle = 'Méthode de paiement'.toUpperCase();
        break;
      case 3:
        btnTitle = 'Confirmer la commande'.toUpperCase();
        break;
      default:
        btnTitle = 'Sélectionner l\'adresse'.toUpperCase();
    }
  }

  Future<bool> onWillPop() async {
    DateTime now = DateTime.now();
    if (lastPressed == null || now.difference(lastPressed!) > Duration(seconds: 2)) {
      lastPressed = now;
      toast('Appuyez à nouveau pour quitter');
      return Future.value(false);
    }
    LSOrder.reset();
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: appBarWidget(
          'Planifier le ramassage',
          center: true,
          showBack: false,
          color: context.cardColor,
          bottom: PreferredSize(
            child: Row(
              children: [
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 8),
                      padding: EdgeInsets.all(12),
                      decoration: boxDecorationWithRoundedCorners(
                        backgroundColor: currentPage == 0 ? LSColorPrimary : grey,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Icon(Icons.pin_drop, color: white),
                    ),
                    Text(
                      'Adresse',
                      style: primaryTextStyle(
                        color: currentPage == 0
                            ? LSColorPrimary
                            : appStore.isDarkModeOn ? white : black,
                      ),
                    ),
                  ],
                ),
                Container(height: 2, color: lightGrey).expand(),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 8),
                      padding: EdgeInsets.all(12),
                      decoration: boxDecorationWithRoundedCorners(
                        backgroundColor: currentPage == 1 ? LSColorPrimary : grey,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Icon(Icons.date_range, color: white),
                    ),
                    Text(
                      'Date',
                      style: primaryTextStyle(
                        color: currentPage == 1
                            ? LSColorPrimary
                            : appStore.isDarkModeOn ? white : black,
                      ),
                    ),
                  ],
                ),
                Container(height: 2, color: lightGrey).expand(),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 8),
                      padding: EdgeInsets.all(12),
                      decoration: boxDecorationWithRoundedCorners(
                        backgroundColor: currentPage == 2 ? LSColorPrimary : grey,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Icon(Icons.payment, color: white),
                    ),
                    Text(
                      'Paiement',
                      style: primaryTextStyle(
                        color: currentPage == 2
                            ? LSColorPrimary
                            : appStore.isDarkModeOn ? white : black,
                      ),
                    ),
                  ],
                ),
                Container(height: 2, color: lightGrey).expand(),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 8),
                      padding: EdgeInsets.all(12),
                      decoration: boxDecorationWithRoundedCorners(
                        backgroundColor: currentPage == 3 ? LSColorPrimary : grey,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Icon(Icons.check, color: white),
                    ),
                    Text(
                      'Terminé',
                      style: primaryTextStyle(
                        color: currentPage == 3
                            ? LSColorPrimary
                            : appStore.isDarkModeOn ? white : black,
                      ),
                    ),
                  ],
                ),
              ],
            ).paddingAll(16),
            preferredSize: Size(context.width(), 100),
          ),
        ),
        backgroundColor: appStore.isDarkModeOn ? context.scaffoldBackgroundColor : LSColorSecondary,
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              currentPage = index;
              updateButtonTitle();
            });
          },
          children: [
            LSAddressListComponent(refreshCallback: refreshAddressList),
            LSDateTimeComponent(),
            LSPaymentMethodComponent(),
            LSCompleteComponent(order),
          ],
        ),
        bottomNavigationBar: AppButton(
          width: context.width(),
          color: LSColorPrimary,
          textColor: white,
          text: btnTitle,
          onTap: () async {
            switch (currentPage) {
              case 0:
                if (order.address == null) {
                  toast('Veuillez sélectionner une adresse');
                  return;
                } else {
                  _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
                }
                break;

              case 1:
                if (order.pickUpDate.isBefore(DateTime.now())) {
                  toast('La date de ramassage doit être ultérieure à la date actuelle');
                  return;
                } else {
                  _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
                }
                break;

              case 2:
                _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
                break;

              case 3:
                if (order.pickUpDate.isBefore(DateTime.now())) {
                  toast('La date de ramassage doit être ultérieure à la date actuelle');
                  return;
                } else if (order.address == null) {
                  toast('Veuillez sélectionner une adresse');
                  return;
                } else {
                  bool isAuthenticated = await LSLocalAuthService.authenticate();
                  if (isAuthenticated) {
                    toast('Commande réussie');
                    order.confirmOrder();
                    order.status = 'Confirmé';
                    _clearCart();
                    LSOrder.OrderHistory.add(order);
                    LSOrder.reset();
                    finish(context);
                    LSHomeFragment().launch(context);
                  } else {
                    toast('Authentification échouée');
                    LSOrder.reset();
                    finish(context);
                    LSHomeFragment().launch(context);
                  }
                }
                break;

              default: break;
            }
          },
        ).paddingAll(16),
      ),
    );
  }
}
