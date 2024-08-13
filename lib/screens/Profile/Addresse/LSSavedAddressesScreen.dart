import 'package:flutter/material.dart';
import 'package:laundry/components/LSAddressListComponent.dart';
import 'package:laundry/components/LSNavBar.dart';
import 'package:laundry/main.dart';
import 'package:laundry/utils/LSColors.dart';
import 'package:nb_utils/nb_utils.dart';

class LSSavedAddressesScreen extends StatefulWidget {
  @override
  _LSSavedAddressesScreenState createState() => _LSSavedAddressesScreenState();
}

class _LSSavedAddressesScreenState extends State<LSSavedAddressesScreen> {
  int _selectedIndex = 4;
  void refreshAddressList() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('Adresses sauvegardées', center: true, color: context.cardColor),
      backgroundColor: appStore.isDarkModeOn ? context.scaffoldBackgroundColor : LSColorSecondary,
      body: LSAddressListComponent(refreshCallback: refreshAddressList),
      bottomNavigationBar: LSNavBar(selectedIndex: _selectedIndex),
    );
  }
}
