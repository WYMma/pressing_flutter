import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:laundry/components/LSNavBar.dart';
import 'package:laundry/localDB/LSCartProvider.dart';
import 'package:laundry/fragments/LSCartFragment.dart';
import 'package:laundry/fragments/LSOfferFragment.dart';
import 'package:laundry/model/LSNotificationsModel.dart';
import 'package:laundry/services/LSAuthService.dart';
import 'package:laundry/utils/LSColors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import '../components/LSSOfferPackageComponent.dart';
import '../components/LSServiceNearByComponent.dart';
import '../components/LSTopServiceComponent.dart';
import '../screens/LSNearByScreen.dart';
import '../screens/LSNotificationsScreen.dart';
import '../main.dart';

class LSHomeFragment extends StatefulWidget {
  static String tag = '/LSHomeFragment';

  @override
  LSHomeFragmentState createState() => LSHomeFragmentState();
}

class LSHomeFragmentState extends State<LSHomeFragment> {
  int _selectedIndex = 0;
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    init();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {});
    });
    readToken();
  }

  void readToken() async {
    try {
      String? token = await storage.read(key: 'token');
      Provider.of<LSAuthService>(context, listen: false).tryToken(token: token);
    } on Exception catch (e) {
      print(e);
    }
  }

  init() async {
    await 2.microseconds.delay;
    setStatusBarColor(appStore.isDarkModeOn ? context.cardColor : LSColorPrimary);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  String welcometext() {
    final now = DateTime.now();

    if (now.hour < 12) {
      return 'Bonjour,';
    } else if (now.hour < 18) {
      return 'Bon après-midi,';
    } else {
      return 'Bonsoir,';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appStore.isDarkModeOn ? context.cardColor : LSColorPrimary,
        toolbarHeight: 80, // Set the height of the app bar
        title: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Consumer<LSAuthService>(
                  builder: (context, authService, child) {
                    return Text(
                      welcometext() + '\n' + authService.client!.first_name + ' ' + authService.client!.last_name,
                      style: boldTextStyle(color: white, size: 20),
                      maxLines: 2,
                    );
                  },
                ),
              ),
              InkWell(
                onTap: () {
                  LSNotificationsScreen().launch(context);
                },
                child: Center(
                  child: Badge(
                    label: Text(LSNotificationsModel.unreadCount.toString(), style: TextStyle(color: Colors.white)),
                    child: Icon(LSNotificationsModel.unreadCount == 0 ? Icons.notifications_none : Icons.notifications, color: context.iconColor),
                  ),
                ),
              ),
              SizedBox(width: 10.0),
              InkWell(
                onTap: () {
                  LSCartFragment().launch(context);
                },
                child: Center(
                  child: Badge(
                    label: Consumer<LSCartProvider>(
                      builder: (context, value, child) {
                        return Text(
                          value.getCounter().toString(),
                          style: TextStyle(color: Colors.white),
                        );
                      },
                    ),
                    child: Icon(Icons.shopping_cart, color: context.iconColor),
                  ),
                ),
              ),
            ],
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: appStore.isDarkModeOn ? context.scaffoldBackgroundColor : LSColorSecondary.withOpacity(0.55),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              8.height,
              Text('Top Services', style: boldTextStyle(size: 18)).paddingOnly(left: 16, top: 16, right: 16, bottom: 8),
              LSTopServiceComponent(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Nos Pressings', style: boldTextStyle(size: 18)).expand(),
                  TextButton(
                    onPressed: () {
                      LSNearByScreen().launch(context);
                    },
                    child: Text('Voir tout', style: secondaryTextStyle()),
                  ),
                ],
              ).paddingOnly(left: 16, top: 16, right: 16),
              LSServiceNearByComponent(),
              Row(
                children: [
                  Text('Offres et forfaits spéciaux', style: boldTextStyle(size: 18)).expand(),
                  TextButton(
                    onPressed: () {
                      LSOfferFragment().launch(context);
                    },
                    child: Text('Voir tout', style: secondaryTextStyle()),
                  ),
                ],
              ).paddingOnly(left: 16, right: 16),
              LSSOfferPackageComponent(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: LSNavBar(selectedIndex: _selectedIndex),
    );
  }
}
