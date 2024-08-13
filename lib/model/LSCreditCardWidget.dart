import 'package:flutter/material.dart';
import 'package:laundry/utils/LSColors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:u_credit_card/u_credit_card.dart';
import '../screens/Profile/Paiement/LSEditPaymentMethod.dart';

class LSCreditCardWidget extends StatefulWidget {
  @override
  _LSCreditCardWidgetState createState() => _LSCreditCardWidgetState();

  static List<Map<String, String>> savedPaymentMethods = [
    {'number': '1234567812345678', 'holder': 'John Doe', 'expiry': '12/24'},
    {'number': '8765432187654321', 'holder': 'Jane Smith', 'expiry': '01/25'},
  ];

  static void addPaymentMethod(String cardNumber, String cardHolder, String expiryDate) {
    savedPaymentMethods.add({
      'number': cardNumber,
      'holder': cardHolder,
      'expiry': expiryDate,
    });
  }

  static void deletePaymentMethod(String cardNumber) {
    savedPaymentMethods.removeWhere((element) => element['number'] == cardNumber);
  }

  static void editPaymentMethod(String oldCardNumber, String newCardNumber, String cardHolder, String expiryDate) {
    for (var card in savedPaymentMethods) {
      if (card['number'] == oldCardNumber) {
        card['number'] = newCardNumber;
        card['holder'] = cardHolder;
        card['expiry'] = expiryDate;
        break;
      }
    }
  }
}

class _LSCreditCardWidgetState extends State<LSCreditCardWidget> {
  String selectedPaymentMethod = ''; // Default selection

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: LSCreditCardWidget.savedPaymentMethods.length,
      itemBuilder: (context, index) {
        String cardNumber = LSCreditCardWidget.savedPaymentMethods[index]['number']!;
        String cardHolder = LSCreditCardWidget.savedPaymentMethods[index]['holder']!;
        String expiryDate = LSCreditCardWidget.savedPaymentMethods[index]['expiry']!;
        return GestureDetector(
          onLongPress: () {
            setState(() {
              selectedPaymentMethod = cardNumber;
            });
            _showOptionsOverlay(context, cardNumber);
          },
          onTap: () {
            setState(() {
              selectedPaymentMethod = cardNumber;
            });
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: CreditCardUi(
              cardHolderFullName: cardHolder,
              cardNumber: cardNumber,
              validThru: expiryDate,
              topLeftColor: selectedPaymentMethod == cardNumber ? Colors.blue : Colors.black,
              bottomRightColor: selectedPaymentMethod == cardNumber ? Colors.black : Colors.grey.shade300,
              doesSupportNfc: true,
              showValidFrom: false,
              cardType: CardType.credit,
            ),
          ),
        );
      },
    ).paddingTop(16);
  }

  void _showOptionsOverlay(BuildContext context, String cardNumber) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.edit, color: LSColorPrimary),
                  title: Text(
                    'Modifier',
                    style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _navigateToEditPaymentMethod(context, cardNumber);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text(
                    'Supprimer',
                    style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
                  ),
                  onTap: () {
                    setState(() {
                      LSCreditCardWidget.deletePaymentMethod(cardNumber);
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToEditPaymentMethod(BuildContext context, String cardNumber) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LSEditPaymentMethod(cardNumber: cardNumber),
      ),
    ).then((_) {
      setState(() {});
    });
  }
}
