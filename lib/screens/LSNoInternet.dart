import 'package:flutter/material.dart';
import 'package:laundry/main.dart';
import 'package:laundry/utils/LSColors.dart';
import 'package:laundry/utils/LSImages.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:restart_app/restart_app.dart';

class LSNoInternet extends StatelessWidget {
  const LSNoInternet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: appStore.isDarkModeOn
                ? ColorFiltered(
              colorFilter: ColorFilter.matrix(
                [
                  -1,  0,  0,  0,  255, // Red
                  0, -1,  0,  0,  255, // Green
                  0,  0, -1,  0,  255, // Blue
                  0,  0,  0,  1,    0, // Alpha
                ],),
              child: Image.asset(LSError, fit: BoxFit.cover),
            )
                : Image.asset(LSError, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Aucune connexion Internet détectée.',
                  style: boldTextStyle(), // White text for contrast
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'Veuillez vérifier votre connexion réseau et réessayer.',
                  style: secondaryTextStyle(), // White text for contrast
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Restart.restartApp();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: primaryTextStyle(),
                    backgroundColor: LSColorPrimary,
                  ),
                  child: Text('Réessayer', style: primaryTextStyle()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
