import 'package:flutter/material.dart';
import 'package:laundry/fragments/LSHomeFragment.dart';
import 'package:laundry/main.dart';
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

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    afterBuildCreated(() {
      changeStatusColor(appStore.isDarkModeOn ? context.scaffoldBackgroundColor : LSColorSecondary);
    });
  }

  @override
  void dispose() {
    super.dispose();
    afterBuildCreated(() {
      changeStatusColor(Colors.transparent);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<bool> onWillPop() async {
    DateTime now = DateTime.now();
    if (lastPressed == null || now.difference(lastPressed!) > Duration(seconds: 2)) {
      lastPressed = now;
      toast('Appuyez à nouveau pour quitter');
      return Future.value(false);
    }
    return Future.value(true);
  }

  bool isCINValid(String cin) {
    return cin.length == 8 && int.tryParse(cin) != null;
  }

  bool isPhoneValid(String phone) {
    return phone.length == 8 && int.tryParse(phone) != null;
  }

  bool isPasswordValid(String password) {
    if (password.length < 8) return false;
    if (!password.contains(RegExp(r'\d'))) return false;
    if (!password.contains(RegExp(r'[A-Z]'))) return false;
    if (!password.contains(RegExp(r'[a-z]'))) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: Center(
          child: Container(
            width: context.width(), // Adjust the width as needed
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
                                isSignUp = false;
                                setState(() {
                                  _formKey.currentState?.reset();
                                });
                              }),
                              Container(
                                alignment: Alignment.center,
                                color: isSignUp ? LSColorPrimary : LSColorSecondary,
                                padding: EdgeInsets.only(left: 16, right: 20, top: 8, bottom: 8),
                                child: Text("S'inscrire", style: boldTextStyle(color: isSignUp ? white : black)),
                              ).cornerRadiusWithClipRRectOnly(topRight: 30, bottomRight: 30).onTap(() {
                                isSignUp = true;
                                setState(() {
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
                                  if (!isCINValid(value!)) {
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
                              if (!isPhoneValid(value!)) {
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
                              if (!isPasswordValid(value!)) {
                                if(isSignUp) {
                                  return 'Le mot de passe doit contenir au \nmoins 8 caractères avec au moins un chiffre, \nune lettre majuscule et une lettre minuscule';
                                }
                                return 'Mot de passe invalide';
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
                    width: 130,
                    decoration: boxDecorationWithRoundedCorners(
                        backgroundColor: LSColorPrimary, borderRadius: BorderRadius.circular(50)),
                    child: Icon(Icons.arrow_right_alt, color: white, size: 40),
                  ).onTap(() async {
                    if (_formKey.currentState!.validate()) {
                      if (isSignUp) {
                        Map credsSignup = {
                          'phone': phoneCont.text.trim(),
                          'password': passCont.text.trim(),
                          'first_name': firstNameCont.text.trim(),
                          'last_name': lastNameCont.text.trim(),
                          'cin': cinCont.text.trim(),
                          'device_name': 'android'
                        };
                        var authService = Provider.of<LSAuthService>(context, listen: false);
                        await authService.register(creds: credsSignup);
                        if (authService.user != null) {
                          LSHomeFragment().launch(context);
                          showToast(context, 'Inscription réussie');
                        }else {
                          showToast(context, 'Erreur lors de l\'inscription', isError: true);
                        }
                      } else {
                        Map credsSignin = {
                          'phone': phoneCont.text.trim(),
                          'password': passCont.text.trim(),
                          'device_name': 'android'
                        };
                        var authService = Provider.of<LSAuthService>(context, listen: false);
                        await authService.login(creds: credsSignin);

                        // Check if user is not null and has a role
                        if (authService.user != null) {
                          if (authService.user!.role == 'Client') {
                            LSHomeFragment().launch(context);
                            showToast(context, 'Connexion réussie');
                          } else {
                            // Handle other roles or scenarios
                            showToast(context, 'Veuillez vérifier vos données', isError: true);
                          }
                        }
                      }
                    }
                  }),
                  ],
        ),
      ),
    ),
    ),
    ),
    ),
    );
  }
}
