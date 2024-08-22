import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:laundry/main.dart';
import 'package:laundry/model/LSNotificationsModel.dart';
import 'package:laundry/utils/LSColors.dart';
import 'package:laundry/utils/LSImages.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:laundry/localDB/LSCartProvider.dart';
import 'package:laundry/fragments/LSCartFragment.dart';
import 'package:laundry/model/LSItemModel.dart';
import 'package:laundry/localDB/LSDBHelper.dart';
import 'package:laundry/model/LSCartModel.dart';

import 'LSNotificationsScreen.dart';

class LSProductListScreen extends StatefulWidget {
  @override
  _LSProductListScreenState createState() => _LSProductListScreenState();
}

class _LSProductListScreenState extends State<LSProductListScreen> {
  final List<String> categories = [
    'Tout',
    'Homme',
    'Femme',
    'Enfant',
  ];

  final List<LSItemModel> products = [
    LSItemModel(name: 'Capuche', price: 20, image: LSSweatshirt, category: 'Homme', productId: '1'),
    LSItemModel(name: 'Chemise', price: 30, image: LSShirt1, category: 'Homme', productId: '2'),
    LSItemModel(name: 'Polo', price: 10, image: LSShirt, category: 'Homme', productId: '3'),
    LSItemModel(name: 'Blazer', price: 8, image: LSShot, category: 'Homme', productId: '4'),
    LSItemModel(name: 'Costume', price: 25, image: LSSuit, category: 'Homme', productId: '5'),
    LSItemModel(name: 'Draps', price: 40, image: LSTowel, category: 'Homme', productId: '6'),
    LSItemModel(name: 'Robe', price: 15, image: LSDress, category: 'Femme', productId: '7'),
    LSItemModel(name: 'Peach', price: 8, image: LSSweatshirt, category: 'Femme', productId: '8'),
    LSItemModel(name: 'Strawberry', price: 12, image: LSSweatshirt, category: 'Femme', productId: '9'),
    LSItemModel(name: 'Fruit Basket', price: 55, image: LSSweatshirt, category: 'Femme', productId: '10'),
  ];

  String selectedCategory = 'Tout';

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<LSCartProvider>(context);
    final dbHelper = LSDBHelper();

    List<LSItemModel> filteredProducts = selectedCategory == 'Tout'
        ? products
        : products.where((product) => product.category == selectedCategory).toList();

    return Scaffold(
      appBar: appBarWidget(
        'Laveries à proximité',
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
                      selectedCategory = categories[index];
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 17.5, vertical: 8.0),
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      color: selectedCategory == categories[index] ? Colors.blue : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        categories[index],
                        style: TextStyle(
                          color: selectedCategory == categories[index] ? Colors.white : Colors.black,
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
                      leading: Image.asset(product.image),
                      title: Text(product.name),
                      subtitle: Text('${product.price} DT'),
                      trailing: AppButton(
                        elevation: 0,
                        width: 40,
                        onTap: () {
                          cart.addCounter();
                          cart.addTotalPrice(double.parse(product.price.toString()));
                          Fluttertoast.showToast(
                            msg: '${product.name} ajouté avec succès au panier',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                          );
                          dbHelper.insertItem(
                            LSCartModel(
                              id: int.parse(product.productId), // Use productId as id
                              productId: product.productId,
                              productName: product.name,
                              initialPrice: product.price,
                              productPrice: product.price,
                              quantity: ValueNotifier(1),
                              unitTag: product.category,
                              image: product.image,
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
