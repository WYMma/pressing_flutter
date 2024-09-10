import 'package:flutter/material.dart';
import 'package:laundry/components/LSMapComponent.dart';
import 'package:nb_utils/nb_utils.dart';
import '../main.dart';
import '../utils/LSColors.dart';
import 'package:laundry/components/LSNavBarCourier.dart';

class LSMapFragment extends StatefulWidget {
  static String tag = '/LSMapFragment';

  @override
  LSMapFragmentState createState() => LSMapFragmentState();
}

class LSMapFragmentState extends State<LSMapFragment> {
  int _selectedIndex = 1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> init() async {
    setStatusBarColor(context.cardColor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.isDarkModeOn
          ? context.scaffoldBackgroundColor
          : LSColorSecondary,
      body: LSMapComponent(),
      bottomNavigationBar: LSNavBarCourier(selectedIndex: _selectedIndex),
    );
  }
}
