import 'package:flutter/material.dart';
import 'package:laundry/services/api/LSCreditCardAPI.dart';
import 'package:laundry/main.dart';
import 'package:laundry/services/LSAuthService.dart';
import 'package:laundry/utils/LSColors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:u_credit_card/u_credit_card.dart';

class LSAddPaymentMethod extends StatefulWidget {
  static String tag = '/LSAddPaymentMethod';

  @override
  _LSAddPaymentMethodState createState() => _LSAddPaymentMethodState();
}

class _LSAddPaymentMethodState extends State<LSAddPaymentMethod> {
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController cardHolderController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        'Ajouter',
        center: true,
        color: context.cardColor,
      ),
      backgroundColor: appStore.isDarkModeOn
          ? context.scaffoldBackgroundColor
          : LSColorSecondary,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
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
                  labelStyle: TextStyle(color: Theme
                      .of(context)
                      .textTheme
                      .bodyLarge!
                      .color),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  hintText: 'Entrez le numéro de votre carte',
                  prefixIcon: Icon(Icons.credit_card, color: Theme
                      .of(context)
                      .iconTheme
                      .color),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) {
                  if (!isValidCreditCardNumber(value!)) {
                    return 'Veuillez entrer un numéro de carte valide';
                  };
                  if (value.isEmpty) {
                    return 'Veuillez entrer le numéro de votre carte';
                  }
                  return null;
                },
                onChanged: (value) => setState(() {}),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: cardHolderController,
                decoration: InputDecoration(
                  labelText: 'Titulaire de la carte',
                  labelStyle: TextStyle(color: Theme
                      .of(context)
                      .textTheme
                      .bodyLarge!
                      .color),
                  hintText: 'Entrez le nom du titulaire de la carte',
                  prefixIcon: Icon(Icons.person, color: Theme
                      .of(context)
                      .iconTheme
                      .color),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer le nom du titulaire de la carte';
                  }
                  return null;
                },
                onChanged: (value) => setState(() {}),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: expiryDateController,
                      readOnly: true,
                      // Champ en lecture seule pour déclencher le sélecteur de date
                      decoration: InputDecoration(
                        labelText: 'EXP (MM/AA)',
                        labelStyle: TextStyle(color: Theme
                            .of(context)
                            .textTheme
                            .bodyLarge!
                            .color),
                        hintText: 'EXP (MM/AA)',
                        prefixIcon: Icon(Icons.date_range, color: Theme
                            .of(context)
                            .iconTheme
                            .color),
                        border: OutlineInputBorder(borderRadius: BorderRadius
                            .circular(8)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Veuillez entrer la date d\'expiration';
                        }
                        return null;
                      },
                      onTap: () async {
                        DateTime maintenant = DateTime.now();

                        // Afficher la boîte de dialogue personnalisée pour sélectionner Mois/Année
                        DateTime? dateChoisie = await showMonthYearPicker(
                          context: context,
                          initialDate: maintenant,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              data: appStore.isDarkModeOn
                                  ? ThemeData.dark()
                                  : ThemeData.light(),
                              child: child!,
                            );
                          },
                        );

                        if (dateChoisie != null) {
                          String dateFormatee = '${dateChoisie.month.toString()
                              .padLeft(2, '0')}/${dateChoisie.year.toString()
                              .substring(2)}';
                          expiryDateController.text = dateFormatee;
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: cvvController,
                      decoration: InputDecoration(
                        labelText: 'CVV',
                        labelStyle: TextStyle(color: Theme
                            .of(context)
                            .textTheme
                            .bodyLarge!
                            .color),
                        hintText: 'Entrez le CVV',
                        prefixIcon: Icon(Icons.security, color: Theme
                            .of(context)
                            .iconTheme
                            .color),
                        border: OutlineInputBorder(borderRadius: BorderRadius
                            .circular(8)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Veuillez entrer le CVV';
                        }
                        return null;
                      },
                      onChanged: (value) => setState(() {}),
                    ),
                  ),
                ],
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
          text: isLoading ? 'Chargement...' : 'Ajouter',
          textColor: Colors.white,
          color: Colors.blue,
          onTap: () async {
            if (_formKey.currentState!.validate()) {
              setState(() {
                isLoading = true;
              });

              try {
                var authService = Provider.of<LSAuthService>(context, listen: false);
                Map<String, dynamic> creditcard = {
                  'number': cardNumberController.text.trim(),
                  'holder': cardHolderController.text.trim(),
                  'expiry': expiryDateController.text.trim(),
                  'cvv': cvvController.text.trim(),
                  'clientID': authService.client!.clientID,
                };

                print('Credit card data: $creditcard');

                // Call the API to add the credit card
                await Provider.of<LSCreditCardAPI>(context, listen: false).addCreditCard(creditCard: creditcard);

                Fluttertoast.showToast(
                  msg: 'Méthode de Paiement ajoutée avec succès.',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
                Navigator.pop(context);
              } catch (e) {
                // Print the error and show a toast
                print('Error adding credit card: $e');
                Fluttertoast.showToast(
                  msg: 'Une erreur s\'est produite. Veuillez réessayer.',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              } finally {
                setState(() {
                  isLoading = false;
                });
              }
            }
          },
        ),
      ),
    );
  }
}

  // Custom Month/Year Picker Function
  Future<DateTime?> showMonthYearPicker({
    required BuildContext context,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    required TransitionBuilder builder,
  }) async {
    DateTime? dateSelectionnee;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        int anneeSelectionnee = initialDate.year;
        int moisSelectionne = initialDate.month;

        return AlertDialog(
          title: Text("Sélectionnez la date d'expiration"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Sélecteur de mois
                  Expanded(
                    child: DropdownButton<int>(
                      value: moisSelectionne,
                      onChanged: (int? nouvelleValeur) {
                        moisSelectionne = nouvelleValeur!;
                      },
                      items: List.generate(
                        12,
                            (index) => DropdownMenuItem(
                          value: index + 1,
                          child: Text(
                            DateTime(0, index + 1).toString().split(' ')[0].split('-')[1],
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  // Sélecteur d'année
                  Expanded(
                    child: DropdownButton<int>(
                      value: anneeSelectionnee,
                      onChanged: (int? nouvelleValeur) {
                        anneeSelectionnee = nouvelleValeur!;
                      },
                      items: List.generate(
                        lastDate.year - firstDate.year + 1,
                            (index) => DropdownMenuItem(
                          value: firstDate.year + index,
                          child: Text(
                            (firstDate.year + index).toString(),
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Annuler',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK',style: TextStyle(color: LSColorPrimary,fontWeight: FontWeight.bold),),
              onPressed: () {
                dateSelectionnee = DateTime(anneeSelectionnee, moisSelectionne);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    return dateSelectionnee;
  }

bool isValidCreditCardNumber(String cardNumber) {
  // Remove any non-digit characters (e.g., spaces, dashes)
  String sanitizedNumber = cardNumber.replaceAll(RegExp(r'\D'), '');

  // Check if the sanitized number is empty or too short
  if (sanitizedNumber.length < 13 || sanitizedNumber.length > 19) {
    return false;
  }

  int sum = 0;
  bool isSecond = false;

  // Traverse the card number from right to left
  for (int i = sanitizedNumber.length - 1; i >= 0; i--) {
    int digit = int.parse(sanitizedNumber[i]);

    if (isSecond) {
      digit *= 2;
      if (digit > 9) {
        digit -= 9;
      }
    }

    sum += digit;
    isSecond = !isSecond;
  }

  // Valid if the sum is a multiple of 10
  return (sum % 10 == 0);
}
