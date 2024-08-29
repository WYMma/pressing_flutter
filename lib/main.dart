//region imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:laundry/fragmentsCourier/LSCourierHomeFragment.dart';
import 'package:laundry/screens/LSNoInternet.dart';
import 'package:laundry/screens/LSSignInScreen.dart';
import 'package:laundry/services/api/LSAddressAPI.dart';
import 'package:laundry/services/api/LSCreditCardAPI.dart';
import 'package:laundry/services/api/firebase_api.dart';
import 'package:laundry/services/localDB/LSCartProvider.dart';
import 'package:laundry/fragments/LSHomeFragment.dart';
import 'package:laundry/screens/LSWalkThroughScreen.dart';
import 'package:laundry/services/LSAuthService.dart';
import 'package:laundry/store/AppStore.dart';
import 'package:laundry/utils/AppTheme.dart';
import 'package:laundry/utils/LSContstants.dart';
import 'package:laundry/utils/LSWidgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

AppStore appStore = AppStore();

int currentIndex = 0;

void main() async {
  //region Entry Point
  WidgetsFlutterBinding.ensureInitialized();
  await initialize(aLocaleLanguageList: languageList());
  await initializeDateFormatting('fr-FR', null);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAPI().initNotifications();

  appStore.toggleDarkMode(value: getBoolAsync(isDarkModeOnPref));
  appStore.toggleSignInStatus(value: getBoolAsync(isSignedInPref));
  appStore.toggleNotificationsStatus(value: !getBoolAsync(isNotificationsEnabledPref));

  defaultRadius = 10;
  defaultToastGravityGlobal = ToastGravity.BOTTOM;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LSCartProvider()),
        ChangeNotifierProvider(create: (_) => LSAuthService()),
        ChangeNotifierProvider(create: (_) => LSAddressAPI()),
        ChangeNotifierProvider(create: (_) => LSCreditCardAPI()),
      ],
      child: MyApp(),
    ),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  //endregion
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '$appName${!isMobile ? ' ${platformName()}' : ''}',
        home: StreamBuilder<List<ConnectivityResult>>(
          stream: Connectivity().onConnectivityChanged,
          builder: (BuildContext context, AsyncSnapshot<List<ConnectivityResult>> streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.none) {
              return LSNoInternet();
            } else {
              return FutureBuilder<String?>(
                future: FlutterSecureStorage().read(key: 'role'),
                builder: (BuildContext context, AsyncSnapshot<String?> futureSnapshot) {
                  if (!appStore.isSignedIn) {
                    return LSWalkThroughScreen();
                  } else if (futureSnapshot.hasError) {
                    return LSSignInScreen(); // Handle future error
                  } else {
                    return futureSnapshot.data == 'Client' ? LSHomeFragment() : LSCourierHomeFragment();
                  }
                },
              );
            }
          },
        ),
        theme: !appStore.isDarkModeOn ? AppThemeData.lightTheme : AppThemeData.darkTheme,
        navigatorKey: navigatorKey,
        scrollBehavior: SBehavior(),
        supportedLocales: LanguageDataModel.languageLocales(),
        localeResolutionCallback: (locale, supportedLocales) => locale,
      ),
    );
  }
}
