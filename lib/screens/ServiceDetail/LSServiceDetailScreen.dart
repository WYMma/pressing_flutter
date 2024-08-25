import 'package:flutter/material.dart';
import 'package:laundry/components/LSNavBar.dart';
import 'package:laundry/screens/ServiceDetail/LSAboutComponent.dart';
import 'package:laundry/screens/ServiceDetail/LSPriceListComponent.dart';
import 'package:laundry/screens/ServiceDetail/LSServicesComponent.dart';
import 'package:laundry/utils/LSColors.dart';
import 'package:laundry/utils/LSImages.dart';
import 'package:laundry/utils/LSWidgets.dart';
import 'package:nb_utils/nb_utils.dart';

class LSServiceDetailScreen extends StatefulWidget {
  static String tag = '/LSServiceDetailScreen';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 4,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: innerBoxIsScrolled ? black : white),
                  onPressed: () {
                    finish(context);
                  },
                ),
                pinned: true,
                elevation: 0.5,
                expandedHeight: 400,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.only(bottom: 66, left: 30, right: 50),
                  collapseMode: CollapseMode.parallax,
                  title: Text(
                    'Rohan Patel',
                    style: boldTextStyle(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ).visible(innerBoxIsScrolled),
                  background: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          commonCacheImageWidget(LSWall, 300, width: context.width(), fit: BoxFit.cover),
                          Container(
                            height: 300,
                            width: context.width(),
                            color: black.withOpacity(0.6),
                          ),
                          Positioned(
                            bottom: 8,
                            left: 16,
                            right: 16,
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('XPress Laundry Service', style: boldTextStyle(size: 20, color: white)),
                                    4.height,
                                    Text('145 Valencia St, San Francisco, CA 94103', style: secondaryTextStyle(color: white)),
                                    16.height,
                                  ],
                                ).expand(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      16.height,
                      Row(
                        children: [
                          Column(
                            children: [
                              Icon(LineIcons.phone, size: 30, color: LSColorPrimary),
                              8.height,
                              Text('Call', style: primaryTextStyle()),
                            ],
                          ).expand(),
                          Column(
                            children: [
                              Icon(LineIcons.directions, size: 30, color: LSColorPrimary),
                              8.height,
                              Text('Direction', style: primaryTextStyle()),
                            ],
                          ).expand(),
                        ],
                      )
                    ],
                  ),
                ),
                bottom: TabBar(
                  labelStyle: boldTextStyle(color: black),
                  labelColor: LSColorPrimary,
                  isScrollable: false,
                  tabs: [
                    Tab(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('About'.toUpperCase(), style: primaryTextStyle(size: 13)),
                      ),
                    ),
                    Tab(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('Services'.toUpperCase(), style: primaryTextStyle(size: 13)),
                      ),
                    ),
                    Tab(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('PriceList'.toUpperCase(), style: primaryTextStyle(size: 13)),
                      ),
                    ),
                  ],
                ),
              )
            ];
          },
          body: TabBarView(
            children: [LSAboutComponent(), LSServicesComponent(), LSPriceListComponent()],
          ),
        ),
      ),
      bottomNavigationBar: LSNavBar(selectedIndex: 0),
    );
  }
}
