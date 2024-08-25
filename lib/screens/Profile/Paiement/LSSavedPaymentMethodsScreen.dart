import 'package:flutter/material.dart';
import 'package:laundry/components/LSNavBar.dart';
import 'package:laundry/main.dart';
import 'package:laundry/utils/LSColors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:laundry/components/LSCreditCardComponent.dart';

class LSSavedPaymentMethodsScreen extends StatefulWidget {
  static String tag = '/LSSavedPaymentMethodsScreen';

  @override
  LSSavedPaymentMethodsScreenState createState() => LSSavedPaymentMethodsScreenState();
}

class LSSavedPaymentMethodsScreenState extends State<LSSavedPaymentMethodsScreen> {
  int _selectedIndex = 4;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('Méthode de Paiement', center: true, color: context.cardColor),
      backgroundColor: appStore.isDarkModeOn ? context.scaffoldBackgroundColor : LSColorSecondary,
      body: LSCreditCardComponent(), // Display the saved payment methods using LSCreditCardWidget
      bottomNavigationBar: LSNavBar(selectedIndex: _selectedIndex),
    );
  }
}