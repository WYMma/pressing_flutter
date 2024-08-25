import 'package:flutter/material.dart';
import 'package:laundry/main.dart';
import 'package:laundry/services/LSAuthService.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../utils/LSColors.dart';

class LSChangePasswordPage extends StatefulWidget {
  const LSChangePasswordPage({Key? key}) : super(key: key);

  @override
  _LSChangePasswordPage createState() => _LSChangePasswordPage();
}

class _LSChangePasswordPage extends State<LSChangePasswordPage> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  bool isPasswordValid(String password) {
    // Password should contain at least one digit, one uppercase letter, one lowercase letter, and be at least 8 characters long
    if (password.length < 8) {
      return false;
    }
    if (!password.contains(RegExp(r'\d'))) {
      return false; // Contains no digits
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return false; // Contains no uppercase letters
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      return false; // Contains no lowercase letters
    }
    return true;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('Changer Mot de Passe', center: true, color: context.cardColor),
      backgroundColor: appStore.isDarkModeOn ? context.scaffoldBackgroundColor : LSColorSecondary,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              25.height,
              AppTextField(
                controller: _currentPasswordController,
                textFieldType: TextFieldType.PASSWORD,
                decoration: InputDecoration(
                  labelText: 'Mot de Passe Actuel',
                  labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color), // Adjusted for dark mode
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  prefixIcon: Icon(Icons.verified_user),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer votre mot de passe actuel';
                  }
                  return null;
                },
              ),
              16.height,
              AppTextField(
                controller: _newPasswordController,
                textFieldType: TextFieldType.PASSWORD,
                decoration: InputDecoration(
                  labelText: 'Nouveau Mot de Passe',
                  labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color), // Adjusted for dark mode
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  prefixIcon: Icon(Icons.password_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer un nouveau mot de passe';
                  }
                  if (!isPasswordValid(value)) {
                    return 'Le mot de passe doit contenir au \nmoins 8 caractères avec au moins un chiffre, \nune lettre majuscule et une lettre minuscule';
                  }
                  return null;
                },
              ),
              16.height,
              AppTextField(
                controller: _confirmPasswordController,
                textFieldType: TextFieldType.PASSWORD,
                decoration: InputDecoration(
                  labelText: 'Confirmer Mot de Passe',
                  labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color), // Adjusted for dark mode
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  prefixIcon: Icon(Icons.password_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez confirmer votre mot de passe';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Les mots de passe ne correspondent pas';
                  }
                  return null;
                },
              ),
              30.height,
              AppButton(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    // Change password
                    setState(() {
                      isLoading = true;
                    });
                    try {
                      var status = await Provider.of<LSAuthService>(context, listen: false)
                          .changePassword(
                        _currentPasswordController.text,
                        _newPasswordController.text,
                      );
                      if (status == 200) {
                        Fluttertoast.showToast(
                          msg: 'Mot de Passe Modifiée avec Succès',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                        Navigator.pop(context);
                      } else if (status == 452) {
                        showToast('Mot de Passe Actuel Incorrect', Colors.red);
                      } else if (status == 453) {
                        showToast(
                            "Vous pouvez changer votre mot de passe q'une seule fois chaque 30 Jours",
                            Colors.red);
                      } else {
                        showToast('Une erreur s\'est produite. Veuillez réessayer.', Colors.red);
                      }
                    } catch (e) {
                      print('Error editing password: $e');
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
                text: isLoading? 'Chargement...':'Changer Mot de Passe',
                textColor: white,
                color: LSColorPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

