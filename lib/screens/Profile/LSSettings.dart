import 'package:flutter/material.dart';
import 'package:laundry/components/LSNavBar.dart';
import 'package:laundry/utils/LSColors.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:laundry/screens/Profile/LSModifyProfilePage.dart';
import 'package:laundry/screens/Profile/LSChangePasswordPage.dart';
import 'package:laundry/screens/Profile/LSCreditsPage.dart';

import '../../main.dart';

class LSSettings extends StatefulWidget {
  const LSSettings({Key? key}) : super(key: key);

  @override
  _LSSettings createState() => _LSSettings();
}

class _LSSettings extends State<LSSettings> {
  bool isDarkModeOn = appStore.isDarkModeOn;
  int _selectedIndex = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('Paramètres', center: true, color: context.cardColor),
      backgroundColor: appStore.isDarkModeOn ? context.scaffoldBackgroundColor : LSColorSecondary,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          buildSettingItem(
            context,
            title: 'Modifier Profile',
            icon: Icons.person,
            onTap: () {
              LSModifyProfilePage().launch(context);
            },
          ),
          buildSettingItem(
            context,
            title: 'Changer Mot de Passe',
            icon: Icons.lock,
            onTap: () {
              LSChangePasswordPage().launch(context);
            },
          ),
          buildSettingItem(
            context,
            title: 'Changer Theme',
            icon: isDarkModeOn ? Icons.brightness_2 : Icons.wb_sunny_rounded,
            trailing: Switch(
              value: isDarkModeOn,
              activeColor: LSColorPrimary,
              activeTrackColor: LSColorSecondary,
              onChanged: (value) {
                setState(() {
                  isDarkModeOn = value;
                  appStore.toggleDarkMode(value: value);
                });
              },
            ),
            onTap: () {
              setState(() {
                isDarkModeOn = !isDarkModeOn;
                appStore.toggleDarkMode(value: isDarkModeOn);
              });
            },
          ),
          buildSettingItem(
            context,
            title: 'Credits',
            icon: Icons.info,
            onTap: () {
              LSCreditsPage().launch(context);
            },
          ),
        ],
      ),
      bottomNavigationBar: LSNavBar(selectedIndex: _selectedIndex),
    );
  }

  Widget buildSettingItem(BuildContext context,
      {required String title,
        required IconData icon,
        Widget? trailing,
        required Function() onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Card(
        elevation: 4,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: Icon(icon),
          title: Text(
            title,
            style: boldTextStyle(),
          ),
          trailing: trailing ?? const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      ),
    );
  }//
}