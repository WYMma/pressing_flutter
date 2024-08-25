import 'package:flutter/material.dart';
import 'package:laundry/services/LSAuthService.dart';
import 'package:laundry/services/LSLocalAuthService.dart';
import 'package:laundry/utils/LSColors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:u_credit_card/u_credit_card.dart';
import '../api/LSCreditCardAPI.dart';
import '../screens/Profile/Paiement/LSEditPaymentMethod.dart';

class LSCreditCardWidget extends StatefulWidget {
  @override
  _LSCreditCardWidgetState createState() => _LSCreditCardWidgetState();

  static List<Map<String, String>> savedPaymentMethods = [];

  static void deletePaymentMethod(String cardNumber) {
    savedPaymentMethods.removeWhere((element) => element['number'] == cardNumber);
  }

  static void editPaymentMethod(String oldCardNumber, String newCardNumber, String cardHolder, String expiryDate, String cvv) {
    for (var card in savedPaymentMethods) {
      if (card['number'] == oldCardNumber) {
        card['number'] = newCardNumber;
        card['holder'] = cardHolder;
        card['expiry'] = expiryDate;
        card['cvv'] = cvv;
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
        String cardID = LSCreditCardWidget.savedPaymentMethods[index]['cardID']!;
        String cardNumber = LSCreditCardWidget.savedPaymentMethods[index]['number']!;
        String cardHolder = LSCreditCardWidget.savedPaymentMethods[index]['holder']!;
        String expiryDate = LSCreditCardWidget.savedPaymentMethods[index]['expiry']!;
        String cvv = LSCreditCardWidget.savedPaymentMethods[index]['cvv']!;
        return GestureDetector(
          onLongPress: () {
            setState(() {
              selectedPaymentMethod = cardID;
            });
            _showOptionsOverlay(context, cardID);
          },
          onTap: () {
            setState(() {
              selectedPaymentMethod = cardID;
            });
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: CreditCardUi(
              cardHolderFullName: cardHolder,
              cardNumber: cardNumber,
              validThru: expiryDate,
              topLeftColor: selectedPaymentMethod == cardID ? Colors.blue : Colors.black,
              bottomRightColor: selectedPaymentMethod == cardID ? Colors.black : Colors.grey.shade300,
              doesSupportNfc: true,
              showValidFrom: false,
              cvvNumber: cvv,
              cardType: CardType.credit,
            ),
          ),
        );
      },
    ).paddingTop(16);
  }

  void _showOptionsOverlay(BuildContext context, String cardID) {
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
                  onTap: () async {
                    bool isAuthenticated = await LSLocalAuthService.authenticate();
                    if (isAuthenticated) {
                      Navigator.pop(context);
                      _navigateToEditPaymentMethod(context, cardID);
                    } else {
                      toast('Authentification échouée');
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text(
                    'Supprimer',
                    style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
                  ),
                  onTap: () async {
                    bool isAuthenticated = await LSLocalAuthService.authenticate();
                    if (isAuthenticated) {
                      var authservice = Provider.of<LSAuthService>(context, listen: false);
                      String clientID = authservice.client!.clientID;
                      await Provider.of<LSCreditCardAPI>(context, listen: false).deleteCreditCard(cardID: cardID, clientID: clientID);
                      Navigator.pop(context);
                      setState(() {
                      });
                    } else {
                      toast('Authentification échouée');
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToEditPaymentMethod(BuildContext context, String cardID) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LSEditPaymentMethod(cardID: cardID),
      ),
    ).then((_) {
      setState(() {});
    });
  }
}
