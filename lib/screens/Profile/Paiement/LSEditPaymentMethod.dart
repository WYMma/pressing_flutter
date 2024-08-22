import 'package:flutter/material.dart';
import 'package:laundry/main.dart';
import 'package:laundry/model/LSCreditCardWidget.dart';
import 'package:laundry/utils/LSColors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:u_credit_card/u_credit_card.dart';

class LSEditPaymentMethod extends StatefulWidget {
  static String tag = '/LSEditPaymentMethod';
  final String cardNumber;

  LSEditPaymentMethod({required this.cardNumber});

  @override
  _LSEditPaymentMethodState createState() => _LSEditPaymentMethodState();
}

class _LSEditPaymentMethodState extends State<LSEditPaymentMethod> {
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController cardHolderController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final cardDetails = LSCreditCardWidget.savedPaymentMethods.firstWhere(
          (card) => card['number'] == widget.cardNumber,
      orElse: () => {},
    );

    cardNumberController.text = cardDetails['number'] ?? '';
    cardHolderController.text = cardDetails['holder'] ?? '';
    expiryDateController.text = cardDetails['expiry'] ?? '';
    cvvController.text = cardDetails['cvv'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier'),
        centerTitle: true,
        backgroundColor: context.cardColor,
      ),
      backgroundColor: appStore.isDarkModeOn ? context.scaffoldBackgroundColor : LSColorSecondary,
      body: SingleChildScrollView(
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
                labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                hintText: 'Entrez le numéro de votre carte',
                prefixIcon: Icon(Icons.credit_card, color: Theme.of(context).iconTheme.color),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onChanged: (value) => setState(() {}),
            ),
            SizedBox(height: 16),
            TextField(
              controller: cardHolderController,
              decoration: InputDecoration(
                labelText: 'Titulaire de la carte',
                labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
                hintText: 'Entrez le nom du titulaire de la carte',
                prefixIcon: Icon(Icons.person, color: Theme.of(context).iconTheme.color),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              onChanged: (value) => setState(() {}),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: expiryDateController,
                    decoration: InputDecoration(
                      labelText: 'EXP (MM/YY)',
                      labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
                      hintText: 'Entrez la date d\'expiration',
                      prefixIcon: Icon(Icons.date_range, color: Theme.of(context).iconTheme.color),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    onChanged: (value) => setState(() {}),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: cvvController,
                    decoration: InputDecoration(
                      labelText: 'CVV',
                      labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
                      hintText: 'Entrez le CVV',
                      prefixIcon: Icon(Icons.security, color: Theme.of(context).iconTheme.color),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    onChanged: (value) => setState(() {}),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: boxDecorationWithShadow(backgroundColor: context.cardColor),
        padding: EdgeInsets.all(8),
        child: AppButton(
          text: 'Enregistrer les modifications'.toUpperCase(),
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
    String cvv = cvvController.text.trim();

    if (cardNumber.isNotEmpty && cardHolder.isNotEmpty && expiryDate.isNotEmpty) {
      // Find the card and update the details
      for (var card in LSCreditCardWidget.savedPaymentMethods) {
        if (card['number'] == widget.cardNumber) {
          card['number'] = cardNumber;
          card['holder'] = cardHolder;
          card['expiry'] = expiryDate;
          card['cvv'] = cvv;
          break;
        }
      }
      showToast('Méthode de Paiement modifiée avec succès.', Colors.green);

      // Navigate back to previous screen
      Navigator.pop(context);
    } else {
      // Show error or validation message if fields are empty
      showToast('Veuillez remplir tous les champs.', Colors.red);
    }
  }
}
