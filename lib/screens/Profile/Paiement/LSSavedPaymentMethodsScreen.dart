import 'package:flutter/material.dart';
import 'package:laundry/components/LSNavBar.dart';
import 'package:laundry/main.dart';
import 'package:laundry/services/LSLocalAuthService.dart';
import 'package:laundry/utils/LSColors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:laundry/model/LSCreditCardWidget.dart';
import 'package:laundry/screens/Profile/Paiement/LSAddPaymentMethod.dart'; // Import the screen to add a new payment method

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
      body: LSCreditCardWidget(), // Display the saved payment methods using LSCreditCardWidget
      floatingActionButton: FloatingActionButton(
        backgroundColor: LSColorPrimary,
        onPressed: () async {
          bool isAuthenticated = await LSLocalAuthService.authenticate();
          if (isAuthenticated) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LSAddPaymentMethod()),
            ).then((_) {
              setState(() {}); // Refresh list when coming back from add screen
            });
          } else {
            toast('Authentification échouée');
          }
        },
        child: Icon(Icons.add, color: white),
      ),
      bottomNavigationBar: LSNavBar(selectedIndex: _selectedIndex),
    );
  }
}