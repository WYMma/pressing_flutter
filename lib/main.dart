//region imports
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:laundry/db/LSCartProvider.dart';
import 'package:laundry/fragments/LSHomeFragment.dart';
import 'package:laundry/screens/LSWalkThroughScreen.dart';
import 'package:laundry/store/AppStore.dart';
import 'package:laundry/utils/AppTheme.dart';
import 'package:laundry/utils/LSContstants.dart';
import 'package:laundry/utils/LSWidgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

AppStore appStore = AppStore();

int currentIndex = 0;

void main() async {
  //region Entry Point
  WidgetsFlutterBinding.ensureInitialized();
  await initialize(aLocaleLanguageList: languageList());
  await initializeDateFormatting('fr-FR', null);

  appStore.toggleDarkMode(value: getBoolAsync(isDarkModeOnPref));
  appStore.toggleSignInStatus(value: getBoolAsync(isSignedInPref));
  appStore.toggleNotificationsStatus(value: getBoolAsync(isNotificationsEnabledPref));

  defaultRadius = 10;
  defaultToastGravityGlobal = ToastGravity.BOTTOM;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LSCartProvider()),
      ],
      child: MyApp(),
    ),
  );
  //endregion
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '$appName${!isMobile ? ' ${platformName()}' : ''}',
        home: appStore.isSignedIn ? LSHomeFragment() : LSWalkThroughScreen(),
        theme: !appStore.isDarkModeOn ? AppThemeData.lightTheme : AppThemeData.darkTheme,
        navigatorKey: navigatorKey,
        scrollBehavior: SBehavior(),
        supportedLocales: LanguageDataModel.languageLocales(),
        localeResolutionCallback: (locale, supportedLocales) => locale,
      ),
    );
  }
}
