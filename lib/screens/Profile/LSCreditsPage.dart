import 'package:flutter/material.dart';
import 'package:laundry/main.dart';
import 'package:laundry/utils/LSColors.dart';
import 'package:nb_utils/nb_utils.dart';

class LSCreditsPage extends StatelessWidget {
  const LSCreditsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('Credits', center: true, color: context.cardColor),
      backgroundColor: appStore.isDarkModeOn ? context.scaffoldBackgroundColor : LSColorSecondary,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'App developed by:',
              style: boldTextStyle(size: 24),
            ),
            16.height,
            Text(
              'Your Name\nYour Company\nYour Email',
              style: primaryTextStyle(size: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
