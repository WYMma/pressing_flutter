import 'package:flutter/material.dart';
import 'package:laundry/components/LSNavBar.dart';
import 'package:laundry/model/LSPressingModel.dart';
import 'package:laundry/utils/LSColors.dart';
import 'package:laundry/utils/LSConstants.dart';
import 'package:laundry/utils/LSWidgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class LSServiceDetailScreen extends StatefulWidget {
  static String tag = '/LSServiceDetailScreen';

  final LSPressingModel? data;
  LSServiceDetailScreen(this.data);
  @override
  LSServiceDetailScreenState createState() => LSServiceDetailScreenState();
}

class LSServiceDetailScreenState extends State<LSServiceDetailScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await 2.microseconds.delay;
    setStatusBarColor(Colors.transparent);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  Future<void> _openMap(String url) async {
    final Uri mapUri = Uri.parse(url);
    if (await canLaunchUrl(mapUri)) {
      await launchUrl(mapUri);
    } else {
      throw 'Could not open map';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              commonCacheImageWidget(host+widget.data!.image, 300, width: context.width(), fit: BoxFit.cover),
              Container(
                height: 300,
                width: context.width(),
                color: black.withOpacity(0.6),
              ),
              Positioned(
                top: 40,
                left: 16,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: white),
                  onPressed: () {
                    finish(context);
                  },
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.data!.name, style: boldTextStyle(size: 20, color: white)),
                    4.height,
                    Text(widget.data!.writtenAddress, style: secondaryTextStyle(color: white)),
                  ],
                ),
              ),
            ],
          ),
          16.height,
          Row(
            children: [
              GestureDetector(
                onTap: () => _makePhoneCall(widget.data!.phoneNumber), // Replace with the actual phone number
                child: Column(
                  children: [
                    Icon(LineIcons.phone, size: 30, color: LSColorPrimary),
                    8.height,
                    Text('Appelez', style: primaryTextStyle()),
                  ],
                ),
              ).expand(),
              GestureDetector(
                onTap: () => _openMap(widget.data!.googleMapAddress), // Replace with the actual Google Maps link
                child: Column(
                  children: [
                    Icon(LineIcons.directions, size: 30, color: LSColorPrimary),
                    8.height,
                    Text('Direction', style: primaryTextStyle()),
                  ],
                ),
              ).expand(),
            ],
          ),
          16.height,
          Divider(thickness: 3, color: lightGrey.withOpacity(0.4)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'À propos de nous',
                style: primaryTextStyle(size: 20, weight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              widget.data!.description,
              style: secondaryTextStyle(),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
      bottomNavigationBar: LSNavBar(selectedIndex: 0),
    );
  }
}
