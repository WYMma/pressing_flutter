import 'package:flutter/material.dart';
import 'package:laundry/main.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../utils/LSColors.dart';

class LSModifyProfilePage extends StatefulWidget {
  const LSModifyProfilePage({Key? key}) : super(key: key);

  @override
  _LSModifyProfilePage createState() => _LSModifyProfilePage();
}

class _LSModifyProfilePage extends State<LSModifyProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load existing profile data
    _nameController.text = getStringAsync('userName');
    _emailController.text = getStringAsync('userEmail');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('Modifier Profil', center: true, color: context.cardColor),
      backgroundColor: appStore.isDarkModeOn ? context.scaffoldBackgroundColor : LSColorSecondary,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            25.height,
            AppTextField(
              controller: _nameController,
              textFieldType: TextFieldType.NAME,
              decoration: InputDecoration(
                labelText: 'Nom Complet',
                labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color), // Adjusted for dark mode
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),

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

            ),
            30.height,
            AppButton(
              onTap: () {
                // Save profile data
                setValue('userName', _nameController.text);
                setValue('userEmail', _emailController.text);
                finish(context);
              },
              text: 'Enregistrer',
              textColor: white,
              color: LSColorPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
