import 'package:flutter/material.dart';
import 'package:laundry/main.dart';
import 'package:laundry/services/LSAuthService.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../utils/LSColors.dart';

class LSModifyProfilePage extends StatefulWidget {
  const LSModifyProfilePage({Key? key}) : super(key: key);

  @override
  _LSModifyProfilePage createState() => _LSModifyProfilePage();
}

class _LSModifyProfilePage extends State<LSModifyProfilePage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _cinController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    var authService = Provider.of<LSAuthService>(context, listen: false);
    if (authService.user!.role == 'Client') {
      _firstNameController.text = authService.client!.first_name;
      _lastNameController.text = authService.client!.last_name;
      _cinController.text = authService.client!.cin;
      _emailController.text = authService.client!.email!;
    } else {
      _firstNameController.text = authService.transporteur!.first_name;
      _lastNameController.text = authService.transporteur!.last_name;
      _cinController.text = authService.transporteur!.cin;
      _emailController.text = authService.transporteur!.email!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('Modifier Profil', center: true, color: context.cardColor),
      backgroundColor: appStore.isDarkModeOn ? context.scaffoldBackgroundColor : LSColorSecondary,
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                25.height,
                AppTextField(
                  controller: _firstNameController,
                  textFieldType: TextFieldType.NAME,
                  decoration: InputDecoration(
                    labelText: 'Prenom',
                    labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color), // Adjusted for dark mode
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer votre prenom';
                    }
                    return null;
                  },

                ),
                16.height,
                AppTextField(
                  controller: _lastNameController,
                  textFieldType: TextFieldType.NAME,
                  decoration: InputDecoration(
                    labelText: 'Nom',
                    labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color), // Adjusted for dark mode
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer votre nom';
                    }
                    return null;
                  },

                ),
                16.height,
                AppTextField(
                  controller: _cinController,
                  textFieldType: TextFieldType.NUMBER,
                  decoration: InputDecoration(
                    labelText: 'CIN',
                    labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color), // Adjusted for dark mode
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    prefixIcon: Icon(Icons.badge_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer votre CIN';
                    }
                    if (value.length != 8) {
                      return 'Veuillez entrer un CIN valide';
                    }
                    return null;
                  },

                ),
                16.height,
                AppTextField(
                  controller: _emailController,
                  textFieldType: TextFieldType.EMAIL,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color), // Adjusted for dark mode
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    prefixIcon: Icon(Icons.alternate_email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer votre email';
                    }
                    if (!value.validateEmail()) {
                      return 'Veuillez entrer un email valide';
                    }
                    return null;
                  },

                ),
                30.height,
                AppButton(
                  onTap: () async{
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });
                      try {
                        Map<String, dynamic> data = {
                          'first_name': _firstNameController.text,
                          'last_name': _lastNameController.text,
                          'cin': _cinController.text,
                          'email': _emailController.text,
                        };
                        var authService = Provider.of<LSAuthService>(context, listen: false);
                        if (authService.user!.role == 'Client') {
                          await authService.updateClient(clientID: authService.client?.clientID, creds: data);
                        } else {
                          print(authService.transporteur!.personnelID);
                          await authService.updateTransporteur(personnelID: authService.transporteur?.personnelID, creds: data);
                        }
                        Fluttertoast.showToast(
                          msg: 'Profile Modifiée avec Succès',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                        Navigator.pop(context);
                      } on Exception catch (e) {
                        print('Error editing profile: $e');
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
                  text: isLoading? 'Chargement...': 'Enregistrer',
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
