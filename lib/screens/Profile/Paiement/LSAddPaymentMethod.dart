import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:laundry/main.dart';
import 'package:laundry/utils/LSColors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:u_credit_card/u_credit_card.dart';
import '../../../model/LSCreditCardWidget.dart';

class LSAddPaymentMethod extends StatefulWidget {
  static String tag = '/LSAddPaymentMethod';

  @override
  _LSAddPaymentMethodState createState() => _LSAddPaymentMethodState();
}

class _LSAddPaymentMethodState extends State<LSAddPaymentMethod> {
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController cardHolderController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('Ajouter', center: true, color: context.cardColor),
      backgroundColor: appStore.isDarkModeOn ? context.scaffoldBackgroundColor : LSColorSecondary,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CreditCardUi(
                cardHolderFullName: cardHolderController.text,
                cardNumber: cardNumberController.text,
                validThru: expiryDateController.text,
                topLeftColor: Colors.blue,
                bottomRightColor: Colors.black,
                doesSupportNfc: true,
                showValidFrom: false,
                cardType: CardType.credit,
              ).center(),
              SizedBox(height: 50),
              TextFormField(
                controller: cardNumberController,
                decoration: InputDecoration(
                  labelText: 'Numéro de carte',
                  labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color), // Adjusted for dark mode
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue), // Border color when focused
                  ),
                  hintText: 'Entrez le numéro de votre carte',
                  prefixIcon: Icon(Icons.credit_card, color: Theme.of(context).iconTheme.color), // Adjusted for dark mode
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onChanged: (value) => setState(() {}),
              ),
              SizedBox(height: 16),
              TextField(
                controller: cardHolderController,
                decoration: InputDecoration(
                  labelText: 'Titulaire de la carte',
                  labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color), // Adjusted for dark mode
                  hintText: 'Entrez le nom du titulaire de la carte',
                  prefixIcon: Icon(Icons.person, color: Theme.of(context).iconTheme.color), // Adjusted for dark mode
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue), // Border color when focused
                  ),
                ),
                onChanged: (value) => setState(() {}),
              ),
              SizedBox(height: 16),
              TextField(
                controller: expiryDateController,
                decoration: InputDecoration(
                  labelText: 'Date d\'expiration (MM/YY)',
                  labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color), // Adjusted for dark mode
                  hintText: 'Entrez la date d\'expiration',
                  prefixIcon: Icon(Icons.date_range, color: Theme.of(context).iconTheme.color), // Adjusted for dark mode
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue), // Border color when focused
                  ),
                ),
                onChanged: (value) => setState(() {}),
              ),
              SizedBox(height: 24),
            ],
          ).paddingTop(16),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: boxDecorationWithShadow(backgroundColor: context.cardColor),
        padding: EdgeInsets.all(8),
        child: AppButton(
          text: 'Enregistrer'.toUpperCase(),
          textColor: white,
          color: Colors.blue,
          onTap: () {
            savePaymentMethod();
          },
        ),
      ),
    );
  }

  void showToast(String message, Color backgroundColor) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void savePaymentMethod() {
    String cardNumber = cardNumberController.text.trim();
    String cardHolder = cardHolderController.text.trim();
    String expiryDate = expiryDateController.text.trim();

    if (cardNumber.isNotEmpty && cardHolder.isNotEmpty && expiryDate.isNotEmpty) {
      // Add the new payment method to the list in LSCreditCardWidget
      LSCreditCardWidget.addPaymentMethod(cardNumber, cardHolder, expiryDate);
      showToast('Méthode de Paiement ajoutée avec succès.', Colors.green);

      // Navigate back to previous screen
      Navigator.pop(context);
    } else {
      // Show error or validation message if fields are empty
      showToast('Veuillez remplir tous les champs.', Colors.red);
    }
  }
}
