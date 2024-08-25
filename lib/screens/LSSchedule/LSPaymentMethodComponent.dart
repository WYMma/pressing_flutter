import 'package:flutter/material.dart';
import 'package:laundry/components/LSCreditCardComponent.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../../model/LSOrder.dart';
import '../../utils/LSColors.dart';

class LSPaymentMethodComponent extends StatefulWidget {
  static String tag = '/LSPaymentMethodComponent';

  @override
  LSPaymentMethodComponentState createState() => LSPaymentMethodComponentState();
}

class LSPaymentMethodComponentState extends State<LSPaymentMethodComponent> with AutomaticKeepAliveClientMixin {
  List<Map<String, dynamic>> paymentMethods = [
    {'label': 'Paiement à la livraison', 'icon': Icons.attach_money},
    {'label': 'Carte bancaire', 'icon': Icons.credit_card},
  ];
  String? selectedPaymentMethod = 'Paiement à la livraison';
  bool showSavedPaymentMethods = false; // Flag to control the component rendering
  TextEditingController couponController = TextEditingController(); // Controller for the coupon input

  @override
  void initState() {
    super.initState();
    init();
    if (LSOrder.exists()) {
      LSOrder order = LSOrder();
      order.setPaymentMethod('Paiement à la livraison');
    }
  }

  init() async {
    // Any necessary initializations
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void handlePaymentMethodSelection(String? value) {
    setState(() {
      selectedPaymentMethod = value;
      if (value == 'Carte bancaire') {
        showSavedPaymentMethods = true;
        if (LSOrder.exists()) {
          LSOrder order = LSOrder();
          order.setPaymentMethod('Carte bancaire');
        }
      } else {
        showSavedPaymentMethods = false;
      }
      print('showSavedPaymentMethods: $showSavedPaymentMethods'); // Add this line for debugging
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Container(
        color: appStore.isDarkModeOn ? context.scaffoldBackgroundColor : LSColorSecondary.withOpacity(0.55),
        padding: EdgeInsets.all(8),
        child: showSavedPaymentMethods
            ? LSCreditCardComponent() // Show the saved payment methods component
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.height,
            Text('Code de réduction', style: boldTextStyle()),
            8.height,
            Container(
              child: TextField(
                controller: couponController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Entrez votre code de réduction',
                  prefixIcon: Icon(Icons.card_giftcard, color: context.iconColor),
                ),
                keyboardType: TextInputType.text,
              ).paddingAll(8),
            ),
            16.height,
            Text('Sélectionnez le mode de paiement', style: boldTextStyle()),
            16.height,
            Container(
              width: context.width(),
              child: Column(
                children: [
                  16.height,
                  ListView.builder(
                    itemCount: paymentMethods.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      String method = paymentMethods[index]['label'];
                      IconData icon = paymentMethods[index]['icon'];
                      return RadioListTile<String?>(
                        value: method,
                        activeColor: LSColorPrimary,
                        groupValue: selectedPaymentMethod,
                        title: Row(
                          children: [
                            Icon(icon, color: context.iconColor),
                            8.width,
                            Text(method, style: primaryTextStyle()),
                          ],
                        ),
                        onChanged: handlePaymentMethodSelection,
                      ).paddingOnly(left: 16, right: 16);
                    },
                  ),
                  16.height,
                ],
              ),
            ),
          ],
        ).paddingAll(8),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

