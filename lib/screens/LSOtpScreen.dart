import 'package:flutter/material.dart';
import 'package:laundry/main.dart';
import 'package:laundry/utils/LSColors.dart';
import 'package:laundry/utils/LSImages.dart';
import 'package:laundry/utils/LSWidgets.dart';
import 'package:nb_utils/nb_utils.dart';

import 'LSResetPasswordScreen.dart';

class LSOtpScreen extends StatefulWidget {
  static String tag = '/LSOtpScreen';

  @override
  LSOtpScreenState createState() => LSOtpScreenState();
}

class LSOtpScreenState extends State<LSOtpScreen> {
  TextEditingController firstDigitCont = TextEditingController();
  TextEditingController secondDigitCont = TextEditingController();
  TextEditingController thirdDigitCont = TextEditingController();
  TextEditingController fourthDigitCont = TextEditingController();

  FocusNode firstDigit = FocusNode();
  FocusNode secondDigit = FocusNode();
  FocusNode thirdDigit = FocusNode();
  FocusNode fourthDigit = FocusNode();

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
      appBar: appBarWidget('Code de Vérification', center: true, color: context.cardColor),
      backgroundColor: appStore.isDarkModeOn ? context.scaffoldBackgroundColor : LSColorSecondary,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            24.height,
            commonCacheImageWidget(LSVerify, 220, fit: BoxFit.cover).center(),
            Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              decoration: boxDecorationRoundedWithShadow(8, backgroundColor: context.cardColor),
              width: context.width(),
              child: Column(
                children: [
                  24.height,
                  Text(
                    'Un OTP a été envoyé à votre adresse e-mail enregistrée. Veuillez vérifier.',
                    style: boldTextStyle(),
                    textAlign: TextAlign.center,
                  ),
                  24.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      16.width,
                      AppTextField(
                        controller: firstDigitCont,
                        textFieldType: TextFieldType.PHONE,
                        textAlign: TextAlign.center,
                        focus: firstDigit,
                        onChanged: (String newVal) {
                          if (newVal.length == 1) {
                            firstDigit.unfocus();
                            FocusScope.of(context).requestFocus(secondDigit);
                          }
                        },
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: LSColorPrimary)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: LSColorPrimary)),
                        ),
                      ).expand(),
                      16.width,
                      AppTextField(
                        controller: secondDigitCont,
                        textFieldType: TextFieldType.PHONE,
                        textAlign: TextAlign.center,
                        focus: secondDigit,
                        onChanged: (String newVal) {
                          if (newVal.length == 1) {
                            secondDigit.unfocus();
                            FocusScope.of(context).requestFocus(thirdDigit);
                          }
                        },
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: LSColorPrimary)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: LSColorPrimary)),
                        ),
                      ).expand(),
                      16.width,
                      AppTextField(
                        controller: thirdDigitCont,
                        textFieldType: TextFieldType.PHONE,
                        textAlign: TextAlign.center,
                        focus: thirdDigit,
                        onChanged: (String newVal) {
                          if (newVal.length == 1) {
                            thirdDigit.unfocus();
                            FocusScope.of(context).requestFocus(fourthDigit);
                          }
                        },
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: LSColorPrimary)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: LSColorPrimary)),
                        ),
                      ).expand(),
                      16.width,
                      AppTextField(
                        controller: fourthDigitCont,
                        textFieldType: TextFieldType.PHONE,
                        textAlign: TextAlign.center,
                        focus: fourthDigit,
                        onChanged: (String newVal) {
                          if (newVal.length == 1) {
                            fourthDigit.unfocus();
                          }
                        },
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: LSColorPrimary)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: LSColorPrimary)),
                        ),
                      ).expand(),
                      16.width,
                    ],
                  ),
                  24.height,
                ],
              ),
            ),
            24.height,
            AppButton(
              text: 'VÉRIFIER',
              color: LSColorPrimary,
              textColor: white,
              width: context.width(),
              onTap: () {
                if (firstDigitCont.text.isEmpty ||
                    secondDigitCont.text.isEmpty ||
                    thirdDigitCont.text.isEmpty ||
                    fourthDigitCont.text.isEmpty) {
                  Fluttertoast.showToast(msg:'Veuillez remplir tous les champs', backgroundColor: Colors.red);
                } else {
                  LSResetPasswordScreen().launch(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
