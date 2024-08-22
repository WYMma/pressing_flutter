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
    title: "Payez plus tard \net soyez satisfait",
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



