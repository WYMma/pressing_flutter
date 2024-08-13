import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:laundry/fragments/LSBookingFragment.dart';
import 'package:laundry/fragments/LSHomeFragment.dart';
import 'package:laundry/fragments/LSCartFragment.dart';
import 'package:laundry/fragments/LSOfferFragment.dart';
import 'package:laundry/fragments/LSProfileFragment.dart';
import 'package:laundry/utils/LSColors.dart';
import 'package:laundry/utils/LSImages.dart';
import 'package:nb_utils/nb_utils.dart';

class LSOnBoardingScreen extends StatefulWidget {
  static String tag = '/LSOnBoardingScreen';

  @override
  LSOnBoardingScreenState createState() => LSOnBoardingScreenState();
}

class LSOnBoardingScreenState extends State<LSOnBoardingScreen> {
  int selectedIndex = 0;
  DateTime? lastPressed;
  PageController _pageController = PageController();

  List<Widget> viewContainer = [];

  LSHomeFragment homeFragment = LSHomeFragment();
  LSCartFragment nearByFragment = LSCartFragment();
  LSBookingFragment bookingFragment = LSBookingFragment();
  LSOfferFragment offerFragment = LSOfferFragment();
  LSProfileFragment profileFragment = LSProfileFragment();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    viewContainer = [
      homeFragment,
      offerFragment,
      nearByFragment,
      bookingFragment,
      profileFragment,
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<bool> onWillPop() async {
    DateTime now = DateTime.now();
    if (lastPressed == null || now.difference(lastPressed!) > Duration(seconds: 2)) {
      lastPressed = now;
      toast('Appuyez à nouveau pour quitter');
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          children: viewContainer,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: context.scaffoldBackgroundColor, offset: Offset.fromDirection(3, 1), spreadRadius: 1, blurRadius: 5),
            ],
          ),
          child: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(LSHome, fit: BoxFit.fitHeight, color: lightGrey, height: 24, width: 24),
                activeIcon: SvgPicture.asset(LSHome, color: LSColorPrimary, height: 24, width: 24),
                label: 'Acceuil',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(LSSale, fit: BoxFit.fitHeight, color: lightGrey, height: 24, width: 24),
                activeIcon: SvgPicture.asset(LSSale, color: LSColorPrimary, height: 24, width: 24),
                label: 'Offres',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(LSBasket, fit: BoxFit.fitHeight, color: lightGrey, height: 24, width: 24),
                activeIcon: SvgPicture.asset(LSBasket, color: LSColorPrimary, height: 24, width: 24),
                label: 'Panier',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(LSBooking, fit: BoxFit.fitHeight, color: lightGrey, height: 24, width: 24),
                activeIcon: SvgPicture.asset(LSBooking, color: LSColorPrimary, height: 24, width: 24),
                label: 'Historique',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(LSUser, fit: BoxFit.fitHeight, color: lightGrey, height: 24, width: 24),
                activeIcon: SvgPicture.asset(LSUser, color: LSColorPrimary, height: 24, width: 24),
                label: 'Profile',
              ),
            ],
            currentIndex: selectedIndex,
            unselectedIconTheme: IconThemeData(color: lightGrey, size: 24),
            selectedIconTheme: IconThemeData(color: LSColorPrimary, size: 24),
            selectedLabelStyle: TextStyle(color: LSColorPrimary),
            onTap: (int index) {
              setState(() {
                selectedIndex = index;
              });
              _pageController.animateToPage(index, duration: Duration(milliseconds: 50), curve: Curves.linear);
            },
            type: BottomNavigationBarType.fixed,
          ),
        ),
      ),
    );
  }
}
