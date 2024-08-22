import 'package:flutter/material.dart';
import 'package:laundry/main.dart';
import 'package:laundry/utils/LSColors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:coupon_uikit/coupon_uikit.dart';

class LSCoupon extends StatelessWidget {
  const LSCoupon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('Coupon', center: true, color: context.cardColor),
      backgroundColor: appStore.isDarkModeOn ? context.scaffoldBackgroundColor : LSColorSecondary,
      body: Padding(
        padding: const EdgeInsets.all(45),
        child: Column(
          children: [
            CouponCard(
              height: 300,
              curvePosition: 180,
              curveRadius: 30,
              borderRadius: 10,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.purple,
                    Colors.purple.shade700,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              firstChild: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'CHIRISTMAS SALES',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '16%',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'OFF',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              secondChild: Container(
                width: double.maxFinite,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.white),
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60),
                      ),
                    ),
                    padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(horizontal: 80),
                    ),
                    backgroundColor: WidgetStateProperty.all<Color>(
                      Colors.white,
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'REDEEM',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
