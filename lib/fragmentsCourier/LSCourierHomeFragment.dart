import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:laundry/components/LSNavBarCourier.dart';
import 'package:laundry/fragmentsCourier/LSMissionFragment.dart';
import 'package:laundry/main.dart';
import 'package:laundry/model/LSMissionModel.dart';
import 'package:laundry/screens/LSNoInternet.dart';
import 'package:laundry/services/LSAuthService.dart';
import 'package:laundry/services/api/LSMissionAPI.dart';
import 'package:laundry/utils/LSColors.dart';
import 'package:laundry/utils/LSImages.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

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
      await authService.retrieveApiKeys();
      await Provider.of<LSMissionAPI>(context, listen: false).getAllMissions(context);
      print('Retrived missions: ' + LSMissionModel.MissionHistory.toString());
    } on Exception {
      LSNoInternet().launch(context);
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Missions', style: boldTextStyle(size: 18)),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            alignment: Alignment.bottomCenter,
                            curve: Curves.easeInOut,
                            duration: const Duration(milliseconds: 50),
                            reverseDuration: const Duration(milliseconds: 50),
                            type: PageTransitionType.rightToLeft,
                            child: LSMissionFragment(),
                          ),
                        );
                      },
                      child: Text('Voir tout', style: secondaryTextStyle()),
                    ),
                  ],
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text('En cours', style: boldTextStyle(size: 16)),
                          8.height,
                          Text(LSMissionModel.MissionHistory.where((mission) => mission.status == "En cours").length.toString(), style: boldTextStyle(size: 24, color: LSColorPrimary)),
                        ],
                      ),
                      VerticalDivider(
                        color: Colors.grey.withOpacity(0.5),
                        thickness: 1,
                        width: 32,
                      ),
                      Column(
                        children: [
                          Text('Complété', style: boldTextStyle(size: 16)),
                          8.height,
                          Text(LSMissionModel.MissionHistory.where((mission) => mission.status == "Terminée").length.toString(), style: boldTextStyle(size: 24, color: LSColorPrimary)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              16.height,
              // Team Details Section
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Détails D'équipe", style: boldTextStyle(size: 18)),
                    8.height,
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(Yassin), // Replace with actual image or network image
                      ),
                      title: Text('John Doe', style: primaryTextStyle(size: 16)),
                      subtitle: Text('Driver', style: secondaryTextStyle()),
                      trailing: Icon(Icons.message, color: LSColorPrimary),
                      onTap: () {
                        // Contact team member
                      },
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(Yassin),
                      ),
                      title: Text('Jane Smith', style: primaryTextStyle(size: 16)),
                      subtitle: Text('Support', style: secondaryTextStyle()),
                      trailing: Icon(Icons.message, color: LSColorPrimary),
                      onTap: () {
                        // Contact team member
                      },
                    ),
                  ],
                ),
              ),
              // Add your team details section here
            ],
          ),
        ),
      ),
      bottomNavigationBar: LSNavBarCourier(selectedIndex: _selectedIndex),
    );
  }
}

class ShimmerAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double appBarHeight;

  const ShimmerAppBar({this.appBarHeight = 80});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.3),
      highlightColor: Colors.grey.withOpacity(0.1),
      child: AppBar(
        backgroundColor: Colors.grey[300]!.withOpacity(0.3),
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

Widget buildBodyShimmer() {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        8.height,
        Shimmer.fromColors(
          baseColor: Colors.grey.withOpacity(0.3),
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
