/*import 'package:flutter/material.dart';
import 'package:laundry/main.dart';
import 'package:laundry/model/LSWalkThroughModel.dart';
import 'package:laundry/screens/LSSignInScreen.dart';
import 'package:laundry/utils/LSColors.dart';
import 'package:laundry/utils/LSContstants.dart';
import 'package:laundry/utils/LSWidgets.dart';
import 'package:nb_utils/nb_utils.dart';

class LSWalkThroughScreen extends StatefulWidget {
  static String tag = '/LSWalkThroughScreen';

  @override
  LSWalkThroughScreenState createState() => LSWalkThroughScreenState();
}

class LSWalkThroughScreenState extends State<LSWalkThroughScreen> {
  int currentIndex = 0;
  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    pageController.addListener(() {
      currentIndex = pageController.page.validate().toInt();
      setState(() {});
    });
    await 2.seconds.delay;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: context.height() * 0.89,
            child: PageView.builder(
                controller: pageController,
                itemCount: lsWalkThroughList.length,
                itemBuilder: (_, index) {
                  LSWalkThroughModel data = lsWalkThroughList[index];

                  return Stack(
                    children: [
                      commonCacheImageWidget(
                        data.backgroundImg.validate(),
                        context.height() * 0.82,
                        width: context.width(),
                        fit: BoxFit.cover,
                      ),
                      Container(
                        color: appStore.isDarkModeOn ? Colors.transparent : white.withOpacity(0.5),
                        height: context.height(),
                        width: context.width(),
                      ),
                      Positioned(
                        top: context.height() * 0.14,
                        right: 0,
                        left: 0,
                        child: Column(
                          children: [
                            commonCacheImageWidget(data.img.validate(), 120, fit: BoxFit.cover),
                            20.height,
                            Text(data.title.validate(), style: boldTextStyle(size: 24)),
                            16.height,
                            Text(lsWalkSubTitle, style: secondaryTextStyle(), textAlign: TextAlign.center).paddingOnly(left: 8, right: 8),
                          ],
                        ).paddingOnly(left: 8, right: 8),
                      )
                    ],
                  );
                }),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: DotIndicator(pageController: pageController, pages: lsWalkThroughList, indicatorColor: LSColorPrimary).center(),
          ),
        ],
      ),
      bottomNavigationBar: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              LSSignInScreen().launch(context);
            },
            child: Text('SKIP', style: boldTextStyle(color: LSColorPrimary)),
          ),
          Container(
            height: 50,
            width: currentIndex == 4 ? 120 : 50,
            color: LSColorPrimary,
            child: currentIndex == 4 ? Text('Commencer'.toUpperCase(), style: boldTextStyle(color: white)).center() : Icon(Icons.arrow_right_alt_rounded, color: white),
          ).cornerRadiusWithClipRRect(25).onTap(
            () {
              if (currentIndex == 4) LSSignInScreen().launch(context);
              pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
              setState(() {});
            },
            borderRadius: BorderRadius.circular(25),
          ).paddingRight(12),
        ],
      ).paddingBottom(8),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:concentric_transition/concentric_transition.dart';
import 'package:laundry/screens/LSSignInScreen.dart';
import 'package:nb_utils/nb_utils.dart';

final pages = [
  const PageData(
    icon: Icons.dry_cleaning_rounded,
    title: "Choisissez vos vêtements",
    bgColor: Color(0xff004ba0), // Dark Blue
    textColor: Colors.white,
  ),
  const PageData(
    icon: Icons.schedule_rounded,
    title: "Planifier le ramassage",
    bgColor: Color(0xff4caf50), // Green
    textColor: Color(0xff004ba0), // Dark Blue
  ),
  const PageData(
    icon: Icons.local_laundry_service_rounded,
    title: "Meilleures services de pressing",
    bgColor: Color(0xfff1f8e9), // Light Green
    textColor: Color(0xff004ba0), // Dark Blue
  ),
  const PageData(
    icon: Icons.local_shipping_rounded,
    title: "Livraison à temps",
    bgColor: Color(0xffbbdefb), // Light Blue
    textColor: Color(0xff004ba0), // Dark Blue
  ),
  const PageData(
    icon: Icons.money_rounded,
    title: "Payez plus tard et soyez satisfait",
    bgColor: Color(0xfffff9c4), // Light Yellow
    textColor: Color(0xff004ba0), // Dark Blue
  ),
];

class LSWalkThroughScreen extends StatefulWidget {
  const LSWalkThroughScreen({Key? key}) : super(key: key);

  @override
  _LSWalkThroughScreenState createState() => _LSWalkThroughScreenState();
}

class _LSWalkThroughScreenState extends State<LSWalkThroughScreen> {
  late PageController _pageController;
  DateTime? lastPressed;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    Future<bool> onWillPop() async {
      DateTime now = DateTime.now();
      if (lastPressed == null || now.difference(lastPressed!) > Duration(seconds: 2)) {
        lastPressed = now;
        toast('Appuyez à nouveau pour quitter');
        return Future.value(false);
      }
      return Future.value(true);
    }

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: ConcentricPageView(
          pageController: _pageController, // Assign page controller
          colors: pages.map((p) => p.bgColor).toList(),
          radius: screenWidth * 0.1,
          nextButtonBuilder: (context) => Padding(
            padding: const EdgeInsets.only(left: 3), // visual center
            child: GestureDetector(
              onTap: () {
                if (_pageController.page?.toInt() == pages.length - 1) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LSSignInScreen()),
                  );
                } else {
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                }
              },
              child: Icon(
                Icons.navigate_next,
                size: screenWidth * 0.08,
              ),
            ),
          ),
          itemCount: pages.length,
          itemBuilder: (index) {
            final page = pages[index % pages.length];
            return SafeArea(
              child: _Page(page: page),
            );
          },
        ),
      ),
    );
  }
}

class PageData {
  final String? title;
  final IconData? icon;
  final Color bgColor;
  final Color textColor;

  const PageData({
    this.title,
    this.icon,
    this.bgColor = Colors.white,
    this.textColor = Colors.black,
  });
}

class _Page extends StatelessWidget {
  final PageData page;

  const _Page({Key? key, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(shape: BoxShape.circle, color: page.textColor),
          child: Icon(
            page.icon,
            size: screenHeight * 0.1,
            color: page.bgColor,
          ),
        ),
        Text(
          page.title ?? "",
          style: TextStyle(
              color: page.textColor,
              fontSize: screenHeight * 0.035,
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}



