import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:laundry/components/LSNavBarCourier.dart';
import 'package:laundry/fragments/LSOfferFragment.dart';
import 'package:laundry/services/LSAuthService.dart';
import 'package:laundry/utils/LSColors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import '../components/LSSOfferPackageComponent.dart';
import '../components/LSServiceNearByComponent.dart';
import '../components/LSTopServiceComponent.dart';
import '../main.dart';
import 'package:shimmer/shimmer.dart';


// Add the shimmer widget for the app bar
class ShimmerAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double appBarHeight;

  const ShimmerAppBar({this.appBarHeight = 80});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.3), // Add opacity to the shimmer effect
      highlightColor: Colors.grey.withOpacity(0.1),
      child: AppBar(
        backgroundColor: Colors.grey[300]!.withOpacity(0.3), // Add opacity to the shimmer effect
        toolbarHeight: appBarHeight,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 200,
                height: 20,
                color: Colors.white,
              ),
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: 40,
                    height: 40,
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        automaticallyImplyLeading: false,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);
}

// Add the shimmer widget for the body
Widget buildBodyShimmer() {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        8.height,
        Shimmer.fromColors(
          baseColor: Colors.grey.withOpacity(0.3), // Add opacity to the shimmer effect
          highlightColor: Colors.grey.withOpacity(0.1),
          child: Container(
            width: double.infinity,
            height: 20,
            color: Colors.white,
          ).paddingOnly(left: 16, top: 16, right: 16, bottom: 8),
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey.withOpacity(0.3),
          highlightColor: Colors.grey.withOpacity(0.1),
          child: Container(
            width: double.infinity,
            height: 150,
            color: Colors.white,
          ),
        ).paddingAll(16),
        Shimmer.fromColors(
          baseColor: Colors.grey.withOpacity(0.3),
          highlightColor: Colors.grey.withOpacity(0.1),
          child: Container(
            width: double.infinity,
            height: 150,
            color: Colors.white,
          ),
        ).paddingAll(16),
      ],
    ),
  );
}

// Your main widget class
class LSCourierHomeFragment extends StatefulWidget {
  static String tag = '/LSHomeFragment';

  const LSCourierHomeFragment({super.key});

  @override
  LSCourierHomeFragmentState createState() => LSCourierHomeFragmentState();
}

class LSCourierHomeFragmentState extends State<LSCourierHomeFragment> {
  final int _selectedIndex = 0;
  final storage = FlutterSecureStorage();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    init();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {});
    });
    if (Provider.of<LSAuthService>(context, listen: false).user == null) {
      readToken();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void readToken() async {
    try {
      String? token = await storage.read(key: 'token');
      final authService = Provider.of<LSAuthService>(context, listen: false);
      await authService.tryToken(token: token);
    } on Exception catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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

  init() async {
    await 2.microseconds.delay;
    setStatusBarColor(appStore.isDarkModeOn ? context.cardColor : LSColorPrimary);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isLoading ? ShimmerAppBar() : AppBar(
        backgroundColor: appStore.isDarkModeOn ? context.cardColor : LSColorPrimary,
        toolbarHeight: 80,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Consumer<LSAuthService>(
                  builder: (context, authService, child) {
                    return Text(
                      '${welcometext()}\n${authService.transporteur!.first_name} ${authService.transporteur!.last_name}',
                      style: boldTextStyle(color: white, size: 20),
                      maxLines: 2,
                    );
                  },
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
      body: isLoading
          ? buildBodyShimmer()
          : Container(
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
                ],
              ).paddingOnly(left: 16, top: 16, right: 16, bottom: 8),
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
      bottomNavigationBar: LSNavBarCourier(selectedIndex: _selectedIndex),
    );
  }
}


