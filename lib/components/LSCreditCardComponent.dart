import 'package:flutter/material.dart';
import 'package:laundry/main.dart';
import 'package:laundry/services/LSAuthService.dart';
import 'package:laundry/services/LSLocalAuthService.dart';
import 'package:laundry/services/api/LSCreditCardAPI.dart';
import 'package:laundry/utils/LSColors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:u_credit_card/u_credit_card.dart';
import '../screens/Profile/Paiement/LSAddPaymentMethod.dart';
import '../screens/Profile/Paiement/LSEditPaymentMethod.dart';

class LSCreditCardComponent extends StatefulWidget {
  @override
  _LSCreditCardComponentState createState() => _LSCreditCardComponentState();

  static List<Map<String, String>> savedPaymentMethods = [];
}

class _LSCreditCardComponentState extends State<LSCreditCardComponent> {
  String selectedPaymentMethod = ''; // Default selection

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.isDarkModeOn ? context.scaffoldBackgroundColor : LSColorSecondary,
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: LSCreditCardComponent.savedPaymentMethods.length,
        itemBuilder: (context, index) {
          String cardID = LSCreditCardComponent.savedPaymentMethods[index]['cardID']!;
          String cardNumber = LSCreditCardComponent.savedPaymentMethods[index]['number']!;
          String cardHolder = LSCreditCardComponent.savedPaymentMethods[index]['holder']!;
          String expiryDate = LSCreditCardComponent.savedPaymentMethods[index]['expiry']!;
          String cvv = LSCreditCardComponent.savedPaymentMethods[index]['cvv']!;
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
      ).paddingTop(16),
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
    );
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
