import 'package:flutter/material.dart';
import 'package:laundry/fragments/LSHomeFragment.dart';
import 'package:laundry/main.dart';
import 'package:laundry/utils/LSColors.dart';
import 'package:laundry/utils/LSImages.dart';
import 'package:laundry/utils/LSWidgets.dart';
import 'package:nb_utils/nb_utils.dart';

class LSResetPasswordScreen extends StatefulWidget {
  static String tag = '/LSResetPasswordScreen';

  @override
  LSResetPasswordScreenState createState() => LSResetPasswordScreenState();
}

class LSResetPasswordScreenState extends State<LSResetPasswordScreen> {
  TextEditingController passCont = TextEditingController();
  TextEditingController cPassCont = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    afterBuildCreated(() {
      changeStatusColor(appStore.isDarkModeOn ? context.cardColor : white);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

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
      appBar: appBarWidget('Réinitialiser le mot de passe', center: true, color: context.cardColor),
      backgroundColor: appStore.isDarkModeOn ? context.scaffoldBackgroundColor : LSColorSecondary,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            24.height,
            commonCacheImageWidget(LSReset, 220, fit: BoxFit.cover).center(),
            Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              decoration: boxDecorationRoundedWithShadow(8, backgroundColor: context.cardColor),
              width: context.width(),
              child: Column(
                children: [
                  24.height,
                  Text('Réinitialiser votre mot de passe', style: boldTextStyle(), textAlign: TextAlign.center),
                  24.height,
                  AppTextField(
                    controller: passCont,
                    textFieldType: TextFieldType.PASSWORD,
                    decoration: InputDecoration(hintText: 'Mot de passe'),
                  ),
                  24.height,
                  AppTextField(
                    controller: cPassCont,
                    textFieldType: TextFieldType.PASSWORD,
                    decoration: InputDecoration(hintText: 'Confirmer le mot de passe'),
                  ),
                  24.height,
                ],
              ),
            ),
            24.height,
            AppButton(
              text: 'RÉINITIALISER LE MOT DE PASSE',
              color: LSColorPrimary,
              textColor: white,
              width: context.width(),
              onTap: () {
                if (passCont.text.isEmpty || cPassCont.text.isEmpty) {
                  showToast('Veuillez remplir tous les champs', Colors.red);
                } else if (passCont.text != cPassCont.text) {
                  showToast('Les mots de passe ne correspondent pas', Colors.red);
                } else if (!isPasswordValid(passCont.text)) {
                  showToast('Le mot de passe doit contenir au moins 8 caractères, une majuscule, une minuscule et un chiffre.', Colors.red);
                } else {
                  showToast('Mot de passe réinitialisé avec succès', Colors.green);
                  appStore.toggleSignInStatus(value: true);
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LSHomeFragment()),
                        (Route<dynamic> route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}