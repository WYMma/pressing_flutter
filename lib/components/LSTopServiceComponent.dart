import 'package:flutter/material.dart';
import 'package:laundry/model/LSServicesModel.dart';
import 'package:laundry/screens/LSProductListScreen.dart';
import 'package:laundry/services/api/LSServicesAPI.dart';
import 'package:laundry/utils/LSContstants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../utils/LSWidgets.dart';

class LSTopServiceComponent extends StatefulWidget {
  static String tag = '/TopServiceComponent';

  @override
  LSTopServiceComponentState createState() => LSTopServiceComponentState();
}

class LSTopServiceComponentState extends State<LSTopServiceComponent> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    try {
      await Provider.of<LSServicesAPI>(context, listen: false).getAllServices();
    } catch (e) {
      print('Error fetching services: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return HorizontalList(
      itemCount: LSServicesModel.services.length,
      itemBuilder: (BuildContext context, int index) {
        LSServicesModel data = LSServicesModel.services[index];

        return Column(
          children: [
            Container(
              height: 80,
              width: 80,
              alignment: Alignment.center,
              margin: EdgeInsets.all(8),
              decoration: boxDecorationRoundedWithShadow(25, backgroundColor: context.cardColor),
              child: commonCacheImageWidget(host + data.image, 50, width: 50, fit: BoxFit.cover),
            ),
            8.height,
            Text(data.name.validate(), style: primaryTextStyle()),
          ],
        ).onTap(() {
          LSProductListScreen(data).launch(context);
        });
      },
    );
  }
}

