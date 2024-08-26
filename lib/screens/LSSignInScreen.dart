import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:laundry/fragments/LSHomeFragment.dart';
import 'package:laundry/fragmentsCourier/LSCourierHomeFragment.dart';
import 'package:laundry/screens/resetPassword/LSForgotPasswordScreen.dart';
import 'package:laundry/services/LSAuthService.dart';
import 'package:laundry/utils/LSColors.dart';
import 'package:laundry/utils/LSCommon.dart';
import 'package:laundry/utils/LSImages.dart';
import 'package:laundry/utils/LSWidgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class LSSignInScreen extends StatefulWidget {
  static String tag = '/LSSignInScreen';

  @override
  LSSignInScreenState createState() => LSSignInScreenState();
}

class LSSignInScreenState extends State<LSSignInScreen> {
  bool isSignUp = false;
  bool isLoading = false;
  final int maxRetries = 3;  // Maximum number of retries
  final Duration retryDelay = Duration(seconds: 2);  // Delay between retries

  // Controllers
  TextEditingController phoneCont = TextEditingController();
  TextEditingController passCont = TextEditingController();
  TextEditingController cPassCont = TextEditingController();
  TextEditingController firstNameCont = TextEditingController();
  TextEditingController lastNameCont = TextEditingController();
  TextEditingController cinCont = TextEditingController();

  DateTime? lastPressed;

  // Form Key
  final _formKey = GlobalKey<FormState>();

  //Device Info
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String? deviceName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: context.width(),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  8.height,
                  commonCacheImageWidget(LSLogo, 120, fit: BoxFit.cover).center(),
                  Text('Pressing Neffati', style: boldTextStyle(size: 28, color: LSColorPrimary)),
                  16.height,
                  Container(
                    decoration: boxDecorationRoundedWithShadow(8, backgroundColor: context.cardColor),
                    width: context.width(),
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        16.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              color: isSignUp ? LSColorSecondary : LSColorPrimary,
                              padding: EdgeInsets.only(left: 20, right: 16, top: 8, bottom: 8),
                              child: Text('Se connecter', style: boldTextStyle(color: !isSignUp ? white : black)),
                            ).cornerRadiusWithClipRRectOnly(topLeft: 30, bottomLeft: 30).onTap(() {
                              setState(() {
                                isSignUp = false;
                                _formKey.currentState?.reset();
                              });
                            }),
                            Container(
                              alignment: Alignment.center,
                              color: isSignUp ? LSColorPrimary : LSColorSecondary,
                              padding: EdgeInsets.only(left: 16, right: 20, top: 8, bottom: 8),
                              child: Text("S'inscrire", style: boldTextStyle(color: isSignUp ? white : black)),
                            ).cornerRadiusWithClipRRectOnly(topRight: 30, bottomRight: 30).onTap(() {
                              setState(() {
                                isSignUp = true;
                                _formKey.currentState?.reset();
                              });
                            }),
                          ],
                        ),
                        16.height,
                        Text(isSignUp ? "S'il vous plaît entrer vos informations ci-dessous." : "Veuillez vous connecter à votre compte", style: boldTextStyle()),
                        16.height,
                        if (isSignUp)
                          ...[
                            AppTextField(
                              controller: firstNameCont,
                              textFieldType: TextFieldType.NAME,
                              decoration: InputDecoration(hintText: 'Prénom'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Le prénom est requis';
                                }
                                return null;
                              },
                            ),
                            16.height,
                            AppTextField(
                              controller: lastNameCont,
                              textFieldType: TextFieldType.NAME,
                              decoration: InputDecoration(hintText: 'Nom'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Le nom est requis';
                                }
                                return null;
                              },
                            ),
                            16.height,
                            AppTextField(
                              controller: cinCont,
                              textFieldType: TextFieldType.NUMBER,
                              decoration: InputDecoration(hintText: 'CIN'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Le CIN est requis';
                                }
                                if (value.length != 8 || int.tryParse(value) == null) {
                                  return 'Le CIN doit contenir exactement 8 chiffres';
                                }
                                return null;
                              },
                            ),
                            16.height,
                          ],
                        AppTextField(
                          controller: phoneCont,
                          textFieldType: TextFieldType.PHONE,
                          decoration: InputDecoration(hintText: 'Numéro de téléphone'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Le numéro de téléphone est requis';
                            }
                            if (value.length != 8 || int.tryParse(value) == null) {
                              return 'Numéro de téléphone invalide';
                            }
                            return null;
                          },
                        ),
                        16.height,
                        AppTextField(
                          controller: passCont,
                          textFieldType: TextFieldType.PASSWORD,
                          decoration: InputDecoration(hintText: 'Mot de Passe'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Le mot de passe est requis';
                            }
                            if (value.length < 8 || !value.contains(RegExp(r'\d')) || !value.contains(RegExp(r'[A-Z]')) || !value.contains(RegExp(r'[a-z]'))) {
                              return 'Le mot de passe doit contenir au \nmoins 8 caractères avec au moins un chiffre, \nune lettre majuscule et une lettre minuscule';
                            }
                            return null;
                          },
                        ),
                        16.height,
                        if (isSignUp)
                          AppTextField(
                            controller: cPassCont,
                            textFieldType: TextFieldType.PASSWORD,
                            decoration: InputDecoration(hintText: 'Confirmer mot de Passe'),
                            validator: (value) {
                              if (value != passCont.text) {
                                return 'Les mots de passe ne correspondent pas';
                              }
                              return null;
                            },
                          ),
                        16.height,
                        Align(
                          alignment: Alignment.topRight,
                          child: Text('Mot de Passe Oublié?', style: primaryTextStyle(color: LSColorPrimary)),
                        ).onTap(() {
                          LSForgotPasswordScreen().launch(context);
                        }).visible(!isSignUp),
                        16.height,
                      ],
                    ),
                  ),
                  16.height,
                  Container(
                    height: 50,
                    width: isLoading ? 50 : 130,
                    decoration: boxDecorationWithRoundedCorners(
                        backgroundColor: LSColorPrimary, borderRadius: BorderRadius.circular(50)),
                    child: isLoading
                        ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(white),
                    ).paddingSymmetric(horizontal: 8, vertical: 8)
                        : Icon(Icons.arrow_right_alt, color: white, size: 40),
                  ).onTap(() async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });

                      try {
                        if (isSignUp) {
                          try {
                            Map credsSignup = {
                              'phone': phoneCont.text.trim(),
                              'password': passCont.text.trim(),
                              'first_name': firstNameCont.text.trim(),
                              'last_name': lastNameCont.text.trim(),
                              'cin': cinCont.text.trim(),
                              'device_name': deviceName ?? 'unknown',
                              'tokenFCM' : await  FirebaseMessaging.instance.getToken()
                            };
                            var authService = Provider.of<LSAuthService>(context, listen: false);
                            await authService.register(creds: credsSignup);
                            LSHomeFragment().launch(context);
                            showToast(context, 'Inscription réussie');
                          } catch (e) {
                            showToast(context, 'Erreur lors de l\'inscription', isError: true);
                          }
                        } else {
                          try {
                            Map credsSignin = {
                              'phone': phoneCont.text.trim(),
                              'password': passCont.text.trim(),
                              'device_name': deviceName ?? 'unknown',
                              'tokenFCM' : await  FirebaseMessaging.instance.getToken()
                            };
                            var authService = Provider.of<LSAuthService>(context, listen: false);
                            await authService.login(creds: credsSignin);
                            if (authService.user!.role == 'Client') {
                              LSHomeFragment().launch(context);
                              showToast(context, 'Connexion réussie');
                            } else if (authService.user!.role == 'Transporteur') {
                              LSCourierHomeFragment().launch(context);
                              showToast(context, 'Connexion réussie');
                            }else {
                              showToast(context, 'Veuillez vérifier vos données', isError: true);
                            }
                          } catch (e) {
                            showToast(context, 'Veuillez vérifier vos données', isError: true);
                          }
                        }
                      } catch (e) {
                        showToast(context, e.toString(), isError: true);
                      } finally {
                        setState(() {
                          isLoading = false;
                        });
                      }
                    }
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
