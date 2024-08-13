import 'package:flutter/material.dart';
import 'package:laundry/fragments/LSHomeFragment.dart';
import 'package:laundry/main.dart';
import 'package:laundry/screens/LSForgotPasswordScreen.dart';
import 'package:laundry/utils/LSColors.dart';
import 'package:laundry/utils/LSImages.dart';
import 'package:laundry/utils/LSWidgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:http/http.dart' as http;

class LSSignInScreen extends StatefulWidget {
  static String tag = '/LSSignInScreen';

  @override
  LSSignInScreenState createState() => LSSignInScreenState();
}

class LSSignInScreenState extends State<LSSignInScreen> {
  bool isSignUp = false;
  TextEditingController phoneCont = TextEditingController();
  TextEditingController passCont = TextEditingController();
  TextEditingController cPassCont = TextEditingController();
  TextEditingController firstNameCont = TextEditingController();
  TextEditingController lastNameCont = TextEditingController();
  TextEditingController cinCont = TextEditingController();
  MySQLConnection? conn;
  DateTime? lastPressed;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    afterBuildCreated(() {
      changeStatusColor(appStore.isDarkModeOn ? context.scaffoldBackgroundColor : LSColorSecondary);
    });

    conn = await MySQLConnection.createConnection(
      host: "192.168.1.77", // Add your host IP address or server name
      port: 3305, // Add the port the server is running on
      userName: "root", // Your username
      password: "", // Your password
      databaseName: "pressing", // Your DataBase name
    );

    await conn!.connect();
  }

  Future<bool> userExists(String phone) async {
    var result = await conn!.execute("SELECT * FROM users WHERE numTel = :phone", {"phone": phone});
    return result.rows.isNotEmpty;
  }

  Future<void> addUser(String firstName, String lastName, String cin, String phone, String password) async {
    await conn!.execute(
      "INSERT INTO users (nom, prenom, numTel, cn, password) VALUES (:lastName, :firstName, :phone, :cin, :password)",
      {"firstName": firstName, "lastName": lastName, "cin": cin, "phone": phone, "password": password},
    );
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

  void showToast(BuildContext context, String message, {bool isError = false}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: isError ? Colors.red : Colors.green,
      textColor: Colors.white,
    );
  }

  bool isCINValid(String cin) {
    return cin.length == 8 && int.tryParse(cin) != null;
  }

  bool isPhoneValid(String phone) {
    return phone.length == 8 && int.tryParse(phone) != null;
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

  Future<bool> onWillPop() async {
    DateTime now = DateTime.now();
    if (lastPressed == null || now.difference(lastPressed!) > Duration(seconds: 2)) {
      lastPressed = now;
      toast('Appuyez à nouveau pour quitter');
      return Future.value(false);
    }
    return Future.value(true);
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
                              setState(() {});
                            }),
                            Container(
                              alignment: Alignment.center,
                              color: isSignUp ? LSColorPrimary : LSColorSecondary,
                              padding: EdgeInsets.only(left: 16, right: 20, top: 8, bottom: 8),
                              child: Text("S'inscrire", style: boldTextStyle(color: isSignUp ? white : black)),
                            ).cornerRadiusWithClipRRectOnly(topRight: 30, bottomRight: 30).onTap(() {
                              isSignUp = true;
                              setState(() {});
                            }),
                          ],
                        ),
                        16.height,
                        Text(isSignUp ? "S'il vous plaît entrer vos informations ci-dessous." : "Veuillez vous connecter à votre compte", style: boldTextStyle()),
                        16.height,
                        AppTextField(
                          controller: firstNameCont,
                          textFieldType: TextFieldType.NAME,
                          decoration: InputDecoration(hintText: 'Prénom'),
                        ).visible(isSignUp),
                        16.height.visible(isSignUp),
                        AppTextField(
                          controller: lastNameCont,
                          textFieldType: TextFieldType.NAME,
                          decoration: InputDecoration(hintText: 'Nom'),
                        ).visible(isSignUp),
                        16.height.visible(isSignUp),
                        AppTextField(
                          controller: cinCont,
                          textFieldType: TextFieldType.NUMBER,
                          decoration: InputDecoration(hintText: 'CIN'),
                        ).visible(isSignUp),
                        16.height.visible(isSignUp),
                        AppTextField(
                          controller: phoneCont,
                          textFieldType: TextFieldType.PHONE,
                          decoration: InputDecoration(hintText: 'Numéro de téléphone'),
                        ),
                        16.height,
                        AppTextField(
                          controller: passCont,
                          textFieldType: TextFieldType.PASSWORD,
                          decoration: InputDecoration(hintText: 'Mot de Passe'),
                        ),
                        16.height,
                        AppTextField(
                          controller: cPassCont,
                          textFieldType: TextFieldType.PASSWORD,
                          decoration: InputDecoration(hintText: 'Confirmer mot de Passe'),
                        ).visible(isSignUp),
                        16.height.visible(isSignUp),
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
                    decoration: boxDecorationWithRoundedCorners(backgroundColor: LSColorPrimary, borderRadius: BorderRadius.circular(50)),
                    child: Icon(Icons.arrow_right_alt, color: white, size: 40),
                  ).onTap(() async {
                    if (isSignUp) {
                      // Registration logic
                      String firstName = firstNameCont.text.trim();
                      String lastName = lastNameCont.text.trim();
                      String cin = cinCont.text.trim();
                      String phone = phoneCont.text.trim();
                      String password = passCont.text.trim();
                      String confirmPassword = cPassCont.text.trim();

                      if (password != confirmPassword) {
                        // Show error message for password mismatch
                        showToast(context, "Les mots de passe ne correspondent pas", isError: true);
                        return;
                      }
                      if (password == "" || confirmPassword == "" || phone == "" || firstName == "" || lastName == "" || cin == "") {
                        // Show error message for empty fields
                        showToast(context, "Veuillez remplir tous les champs", isError: true);
                        return;
                      }
                      if (!isCINValid(cin)) {
                        // Show error message for invalid CIN
                        showToast(context, "Le CIN doit contenir exactement 8 chiffres", isError: true);
                        return;
                      }
                      if (!isPhoneValid(phone)) {
                        // Show error message for invalid phone number
                        showToast(context, "Le numéro de téléphone doit contenir exactement 8 chiffres", isError: true);
                        return;
                      }
                      if (!isPasswordValid(password)) {
                        // Show error message for invalid password format
                        showToast(context, "Le mot de passe doit contenir au moins 8 caractères avec au moins un chiffre, une lettre majuscule et une lettre minuscule", isError: true);
                        return;
                      }

                      bool exists = await userExists(phone);
                      if (exists) {
                        // Show error message for existing user
                        showToast(context, "L'utilisateur existe déjà", isError: true);
                      } else {
                        await addUser(firstName, lastName, cin, phone, password);
                        // Show success message and navigate to another screen
                        showToast(context, "Inscription réussie");
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => LSHomeFragment()),
                              (Route<dynamic> route) => false,
                        );
                      }
                    } else {
                      // Login logic
                      String phone = phoneCont.text.trim();
                      String password = passCont.text.trim();

                      if (password == "" || phone == "") {
                        // Show error message for empty fields
                        showToast(context, "Veuillez remplir tous les champs", isError: true);
                        return;
                      }

                      var result = await conn!.execute(
                        "SELECT * FROM users WHERE numTel = :phone AND password = :password",
                        {"phone": phone, "password": password},
                      );

                      if (result.rows.isEmpty) {
                        // Show error message for invalid credentials
                        showToast(context, "Num Téléphone ou mot de passe invalide", isError: true);
                      } else {
                        // Show success message and navigate to another screen
                        showToast(context, "Connexion réussie");
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => LSHomeFragment()),
                              (Route<dynamic> route) => false,
                        );
                      }
                    }
                  }),
                  24.height.visible(!isSignUp),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
