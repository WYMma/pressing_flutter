import 'package:flutter/material.dart';
import 'package:laundry/fragmentsCourier/LSMissionFragment.dart';
import 'package:laundry/fragmentsCourier/LSCourierHomeFragment.dart';
import 'package:laundry/fragments/LSProfileFragment.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:laundry/main.dart';
import 'package:laundry/utils/LSColors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:page_transition/page_transition.dart';

import 'package:laundry/fragmentsCourier/LSMapFragment.dart';

class LSNavBarCourier extends StatelessWidget {
  final int selectedIndex;

  LSNavBarCourier({super.key, required this.selectedIndex});

  final List<Widget> _widgetOptions = <Widget>[
    const LSCourierHomeFragment(),
    LSMapFragment(),
    LSMissionFragment(),
    const LSProfileFragment(),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withOpacity(.1),
          )
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: GNav(
            rippleColor: Colors.grey[300]!,
            hoverColor: LSColorPrimary,
            gap: 8,
            activeColor: appStore.isDarkModeOn ? lightGrey : Colors.black,
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: LSColorPrimary.withOpacity(0.7),
            color: appStore.isDarkModeOn ? lightGrey : Colors.black,
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Acceuil',
              ),
              GButton(
                icon: Icons.pin_drop_rounded,
                text: 'Map',
              ),
              GButton(
                icon: Icons.local_shipping_rounded,
                text: 'Missions',
              ),
              GButton(
                icon: Icons.person,
                text: 'Profile',
              ),
            ],
            selectedIndex: selectedIndex,
            onTabChange: (index) {
              Navigator.push(
                context,
                PageTransition(
                  alignment: Alignment.bottomCenter,
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 50),
                  reverseDuration: const Duration(milliseconds: 50),
                  type: selectedIndex>index? PageTransitionType.leftToRight:PageTransitionType.rightToLeft,
                  child: _widgetOptions[index],
                  childCurrent: _widgetOptions[selectedIndex],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
