import 'package:flutter/material.dart';
import 'package:laundry/main.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:laundry/utils/LSColors.dart';
import 'package:laundry/model/LSCreditCardWidget.dart';
import 'package:laundry/screens/Profile/Paiement/LSAddPaymentMethod.dart';

class LSShowSavedPaymentMethodsComponent extends StatefulWidget {
  @override
  _LSShowSavedPaymentMethodsComponentState createState() => _LSShowSavedPaymentMethodsComponentState();
}

class _LSShowSavedPaymentMethodsComponentState extends State<LSShowSavedPaymentMethodsComponent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.isDarkModeOn ? context.scaffoldBackgroundColor : LSColorSecondary,
      body: LSCreditCardWidget(), // Display the saved payment methods using LSCreditCardWidget
      floatingActionButton: FloatingActionButton(
        backgroundColor: LSColorPrimary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LSAddPaymentMethod()),
          ).then((_) {
            setState(() {}); // Refresh list when coming back from add screen
          });
        },
        child: Icon(Icons.add, color: white),
      ),
    );
  }
}
