import 'package:flutter/material.dart';
import 'package:laundry/localDB/LSCartProvider.dart';
import 'package:laundry/fragments/LSBookingFragment.dart';
import 'package:laundry/fragments/LSCartFragment.dart';
import 'package:laundry/fragments/LSHomeFragment.dart';
import 'package:laundry/fragments/LSOfferFragment.dart';
import 'package:laundry/fragments/LSProfileFragment.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:laundry/main.dart';
import 'package:laundry/utils/LSColors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class LSNavBar extends StatelessWidget {
  final int selectedIndex;

  LSNavBar({required this.selectedIndex});

  final List<Widget> _widgetOptions = <Widget>[
    LSHomeFragment(),
    LSOfferFragment(),
    LSCartFragment(),
    LSBookingFragment(),
    LSProfileFragment(),
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
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            duration: Duration(milliseconds: 400),
            tabBackgroundColor: LSColorPrimary.withOpacity(0.7),
            color: appStore.isDarkModeOn ? lightGrey : Colors.black,
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.percent_rounded,
                text: 'Offres',
              ),
              GButton(
                icon: Icons.shopping_cart,
                text: 'Panier',
                leading: Badge(
                  label: Consumer<LSCartProvider>(
                    builder: (context, value, child) {
                      return Text(
                        value.getCounter().toString(),
                        style: TextStyle(color: Colors.white),
                      );
                    },
                  ),
                  child: Icon(Icons.shopping_cart, color: appStore.isDarkModeOn ? lightGrey : Colors.black),
                ),
              ),
              GButton(
                icon: Icons.receipt_long_rounded,
                text: 'Histoire',
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
                  duration: Duration(milliseconds: 50),
                  reverseDuration: Duration(milliseconds: 50),
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
