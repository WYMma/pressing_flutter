import 'package:flutter/material.dart';
import 'package:laundry/main.dart';
import 'package:nb_utils/nb_utils.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
            ),
            30.height,
            AppButton(
              onTap: () {
                if (_newPasswordController.text.isEmpty || _newPasswordController.text.isEmpty || _currentPasswordController.text.isEmpty) {
                  showToast('Veuillez remplir tous les champs', Colors.red);
                } else if (_newPasswordController.text != _newPasswordController.text) {
                  showToast('Les mots de passe ne correspondent pas', Colors.red);
                } else if (!isPasswordValid(_newPasswordController.text)) {
                  showToast('Le mot de passe doit contenir au moins 8 caractères, une majuscule, une minuscule et un chiffre.', Colors.red);
                } else {
                  showToast('Mot de passe réinitialisé avec succès', Colors.green);
                  finish(context);}
                },
              text: 'Changer Mot de Passe',
              textColor: white,
              color: LSColorPrimary,
            ),
          ],
        ),
      ),
    );
  }
}

