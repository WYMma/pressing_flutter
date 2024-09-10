import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../../model/LSOrder.dart';
import '../../utils/LSColors.dart';

class LSDateTimeComponent extends StatefulWidget {
  static String tag = '/LSDateTimeComponent';

  @override
  LSDateTimeComponentState createState() => LSDateTimeComponentState();
}

class LSDateTimeComponentState extends State<LSDateTimeComponent> with AutomaticKeepAliveClientMixin {
  TextEditingController pickUpDateTimeCont = TextEditingController();
  TextEditingController deliveryDateTimeCont = TextEditingController();

  DateTime pickUpDateTime = DateTime.now();
  DateTime deliveryDateTime = DateTime.now().add(Duration(days: 3));
  bool isPrimeService = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    // Initialize your state
    pickUpDateTimeCont.text = pickUpDateTime.toString();
    deliveryDateTimeCont.text = deliveryDateTime.toString();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void updateDeliveryDate() {
    setState(() {
      if (isPrimeService) {
        deliveryDateTime = pickUpDateTime.add(Duration(days: 1));
      } else {
        deliveryDateTime = pickUpDateTime.add(Duration(days: 3));
      }
      deliveryDateTimeCont.text = deliveryDateTime.toString();
      if (LSOrder.exists()) {
        LSOrder order = LSOrder();
        order.setDeliveryDate(deliveryDateTime);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    DateTime nextWeek = today.add(Duration(days: 7));

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            32.height,
            Text('Date et Heure de Ramassage', style: boldTextStyle()),
            Container(
              width: context.width(),
              decoration: boxDecorationWithRoundedCorners(
                backgroundColor: appStore.isDarkModeOn
                    ? context.scaffoldBackgroundColor
                    : LSColorSecondary.withOpacity(0.55),
              ),
              child: Column(
                children: [
                  16.height,
                  Theme(
                    data: appStore.isDarkModeOn
                        ? ThemeData.dark()
                        : ThemeData.light(),
                    child: DateTimePicker(
                      type: DateTimePickerType.dateTime,
                      controller: pickUpDateTimeCont,
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                      style: primaryTextStyle(),
                      initialDate: pickUpDateTime,
                      firstDate: today,
                      lastDate: nextWeek,
                      use24HourFormat: true,
                      autofocus: false,
                      locale: Locale('en', 'US'),
                      useRootNavigator: true,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color), // Adjusted for dark mode
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        hintText: 'Sélectionnez la Date et l\'Heure',
                        prefixIcon: Icon(Icons.date_range),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (val) {
                        setState(() {
                          pickUpDateTime = DateTime.parse(val);
                          pickUpDateTimeCont.text = val;
                          updateDeliveryDate();
                        });
                        if (LSOrder.exists()) {
                          LSOrder order = LSOrder();
                          order.setPickUpDate(pickUpDateTime);
                        }
                      },
                      onSaved: (val) {
                        // Add save logic if needed
                      },
                    ),
                  ).paddingOnly(top: 16, bottom: 8, left: 16, right: 16),
                ],
              ),
            ),
            16.height,
            Row(
              children: [
                Checkbox(
                  value: isPrimeService,
                  activeColor: LSColorPrimary,
                  onChanged: (value) {
                    setState(() {
                      isPrimeService = value!;
                      if (LSOrder.exists() && isPrimeService) {
                        LSOrder order = LSOrder();
                        order.setdeliveryType("Livraison Express");
                        order.addPrice(5.0);
                      }else{
                        LSOrder order = LSOrder();
                        order.setdeliveryType("Livraison Standard");
                        order.addPrice(-5.0);
                      }
                      updateDeliveryDate();
                    });
                  },
                ),
                Text('Service Express (+5DT)', style: primaryTextStyle()),
              ],
            ),
            32.height,
            Text('Date et Heure de Livraison', style: boldTextStyle()),
            Container(
              width: context.width(),
              decoration: boxDecorationWithRoundedCorners(
                backgroundColor: appStore.isDarkModeOn
                    ? context.scaffoldBackgroundColor
                    : LSColorSecondary.withOpacity(0.55),
              ),
              child: Column(
                children: [
                  16.height,
                  Theme(
                    data: appStore.isDarkModeOn
                        ? ThemeData.dark()
                        : ThemeData.light(),
                    child: DateTimePicker(
                      enabled: false,
                      type: DateTimePickerType.dateTime,
                      controller: deliveryDateTimeCont,
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                      style: primaryTextStyle(),
                      initialDate: deliveryDateTime,
                      firstDate: today,
                      lastDate: nextWeek,
                      use24HourFormat: true,
                      locale: Locale('fr', 'FR'),
                      useRootNavigator: true,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color), // Adjusted for dark mode
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        hintText: 'Date et Heure de Livraison',
                        prefixIcon: Icon(Icons.date_range),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (val) {
                        setState(() {
                          deliveryDateTime = DateTime.parse(val);
                          deliveryDateTimeCont.text = deliveryDateTime.toString();
                        });
                      },
                      onSaved: (val) {
                        // Add save logic if needed
                      },
                    ),
                  ).paddingOnly(top: 16, bottom: 8, left: 16, right: 16),
                ],
              ),
            ),
          ],
        ).paddingAll(8),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
