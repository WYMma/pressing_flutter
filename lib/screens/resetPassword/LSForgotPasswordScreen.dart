import 'package:flutter/material.dart';
import 'package:laundry/screens/resetPassword/LSOtpScreen.dart';
import 'package:laundry/utils/LSColors.dart';
import 'package:laundry/utils/LSImages.dart';
import 'package:laundry/utils/LSWidgets.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:laundry/main.dart';

class LSForgotPasswordScreen extends StatefulWidget {
  static String tag = '/LSForgotPasswordScreen';

  @override
  LSForgotPasswordScreenState createState() => LSForgotPasswordScreenState();
}

class LSForgotPasswordScreenState extends State<LSForgotPasswordScreen> {
  TextEditingController emailCont = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('Mot de Passe Oublié?', center: true, color: context.cardColor),
      backgroundColor: appStore.isDarkModeOn ? context.scaffoldBackgroundColor : LSColorSecondary,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            24.height,
            commonCacheImageWidget(LSForgot, 220, fit: BoxFit.cover).center(),
            Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              decoration: boxDecorationRoundedWithShadow(8, backgroundColor: context.cardColor),
              width: context.width(),
              child: Column(
                children: [
                  24.height,
                  Text("Saisissez l'adresse e-mail \n associée à votre compte", style: boldTextStyle(), textAlign: TextAlign.center),
                  24.height,
                  Text("Nous vous enverrons par e-mail un OTP pour réinitialiser votre mot de passe", style: secondaryTextStyle(), textAlign: TextAlign.center),
                  24.height,
                  AppTextField(
                    controller: emailCont,
                    textFieldType: TextFieldType.PASSWORD,
                    decoration: InputDecoration(hintText: 'E-mail'),
                  ),
                  24.height,
                ],
              ),
            ),
            24.height,
            AppButton(
              text: 'ENVOYER',
              color: LSColorPrimary,
              textColor: white,
              width: context.width(),
              onTap: () {
                LSOtpScreen().launch(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
