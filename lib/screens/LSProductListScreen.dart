import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:laundry/main.dart';
import 'package:laundry/model/LSNotificationsModel.dart';
import 'package:laundry/model/LSSalesModel.dart';
import 'package:laundry/model/LSServicesModel.dart';
import 'package:laundry/services/api/LSItemAPI.dart';
import 'package:laundry/utils/LSColors.dart';
import 'package:laundry/utils/LSConstants.dart';
import 'package:laundry/utils/LSWidgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:laundry/services/localDB/LSCartProvider.dart';
import 'package:laundry/fragments/LSCartFragment.dart';
import 'package:laundry/model/LSItemModel.dart';
import 'package:laundry/services/localDB/LSDBHelper.dart';
import 'package:laundry/model/LSCartModel.dart';

import 'LSNotificationsScreen.dart';

class LSProductListScreen extends StatefulWidget {
  static String tag = '/LSProductListScreen';
  final LSServicesModel? data;
  LSProductListScreen(this.data);
  @override
  _LSProductListScreenState createState() => _LSProductListScreenState();
}

class _LSProductListScreenState extends State<LSProductListScreen> {

  double checkForSale(int serviceID) {
    for (var sale in LSSalesModel.sales) {
      if (sale.serviceID == serviceID && !sale.isOfferExpired()) {
        return sale.discount;
      }
    }
    return 0.0;
  }

  final Map<int, String> categories = LSItemAPI.categories;

  String selectedCategory = 'Tout';

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {});
    });
    init();
  }

  init() async {
    await 2.microseconds.delay;
    setStatusBarColor(context.cardColor);
    try {
      await Provider.of<LSItemAPI>(context, listen: false).getAllItems();
    } catch (e) {
      print('Error fetching sales: $e');
    }
  }

  // Function to retrieve the key from the value in the categories map
  int? getKeyFromValue(Map<int, String> map, String value) {
    for (var entry in map.entries) {
      if (entry.value == value) {
        return entry.key; // Return the key if the value matches
      }
    }
    return null; // Return null if no match is found
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<LSCartProvider>(context);
    final dbHelper = LSDBHelper();

    // Get the key (category ID) corresponding to the selected category
    int? selectedCategoryID = getKeyFromValue(categories, selectedCategory);

    // Filter products based on the selected category
    List<LSItemModel> filteredProducts = selectedCategoryID == 0 // 'Tout'
        ? LSItemModel.items
        : LSItemModel.items.where((product) => product.categorieID == selectedCategoryID.toString()).toList();

    return Scaffold(
      appBar: appBarWidget(
        widget.data!.name,
        center: true,
        showBack: false,
        color: context.cardColor,
        actions: [
          InkWell(
            onTap: () {
              LSNotificationsScreen().launch(context);
            },
            child: Center(
              child: Badge(
                label: Text(LSNotificationsModel.unreadCount.toString(), style: TextStyle(color: Colors.white)),
                child: Icon(LSNotificationsModel.unreadCount == 0 ? Icons.notifications_none : Icons.notifications, color: context.iconColor),
              ),
            ),
          ),
          SizedBox(width: 10.0),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LSCartFragment()),
              );
            },
            child: Center(
              child: Badge(
                label: Consumer<LSCartProvider>(
                  builder: (context, value, child) {
                    return Text(
                      value.getCounter().toString(),
                      style: TextStyle(color: Colors.white),
                    );
                  },
                ),
                child: Icon(Icons.shopping_cart, color: context.iconColor),
              ),
            ),
          ),
          SizedBox(width: 20.0),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: Container(
            margin: EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = categories.values.elementAt(index);
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 17.5, vertical: 8.0),
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      color: selectedCategory == categories.values.elementAt(index) ? Colors.blue : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        categories.values.elementAt(index),
                        style: TextStyle(
                          color: selectedCategory == categories.values.elementAt(index) ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      backgroundColor: appStore.isDarkModeOn ? context.scaffoldBackgroundColor : LSColorSecondary,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15,),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return Card(
                  elevation: 0,
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: ListTile(
                      leading: commonCacheImageWidget(host + product.photo, 80, fit: BoxFit.cover),
                      title: Text(product.name),
                      subtitle: Row(
                        children: [
                          if (checkForSale(widget.data!.serviceID) < 1.0) // If there's a discount
                            Text(
                              '${(product.price + widget.data!.price).toStringAsFixed(2)} DT',
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough, // Crossed out style
                                color: Colors.grey, // Red color for the original price
                              ),
                            ),
                          SizedBox(width: 5), // Space between the prices
                          Text(
                            '${((product.price + widget.data!.price) * (1-checkForSale(widget.data!.serviceID))).toStringAsFixed(2)} DT',
                            style: TextStyle(
                              color: Colors.green, // Green color for the discounted price
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      trailing: AppButton(
                        elevation: 0,
                        width: 40,
                        onTap: () {
                          cart.addCounter();
                          cart.addTotalPrice((product.price + widget.data!.price)*(1-checkForSale(widget.data!.serviceID)));
                          Fluttertoast.showToast(
                            msg: '${product.name} ajouté avec succès au panier',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                          );
                          dbHelper.insertItem(
                            LSCartModel(
                              id: int.parse(product.itemID), // Use productId as id
                              productId: product.itemID,
                              serviceID: widget.data!.serviceID.toString(),
                              productName: product.name,
                              initialPrice: product.price,
                              productPrice: (product.price + widget.data!.price)*(1-checkForSale(widget.data!.serviceID)),
                              quantity: ValueNotifier(1),
                              categorieID: product.categorieID,
                              image: product.photo,
                            ),
                          );
                        },
                        child: Icon(Icons.add_shopping_cart_rounded, color: white),
                        color: LSColorPrimary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
