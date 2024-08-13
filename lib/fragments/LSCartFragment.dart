import 'package:flutter/material.dart';
import 'package:laundry/components/LSNavBar.dart';
import 'package:laundry/main.dart';
import 'package:laundry/model/LSOrder.dart';
import 'package:laundry/screens/LSNotificationsScreen.dart';
import 'package:laundry/screens/LSSchedule/LSScheduleScreen.dart';
import 'package:laundry/utils/LSColors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:laundry/db/LSCartProvider.dart';
import 'package:laundry/db/LSDBHelper.dart';
import 'package:laundry/model/LSCartModel.dart';

class LSCartFragment extends StatefulWidget {
  @override
  _LSCartFragmentState createState() => _LSCartFragmentState();
}

class _LSCartFragmentState extends State<LSCartFragment> {
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<LSCartProvider>(context);
    final dbHelper = LSDBHelper();

    return Scaffold(
      appBar: appBarWidget(
        'Panier',
        center: true,
        showBack: false,
        color: context.cardColor,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            color: context.iconColor,
            onPressed: () {
              LSNotificationsScreen().launch(context);
            },
          ),
          InkWell(
            onTap: () {},
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
      ),
      backgroundColor: appStore.isDarkModeOn ? context.scaffoldBackgroundColor : LSColorSecondary,
      body: FutureBuilder<List<LSCartModel>>(
        future: dbHelper.getCartItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Votre panier est vide.'));
          } else {
            final cartItems = snapshot.data!;

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Card(
                        child: ListTile(
                          contentPadding: EdgeInsets.all(15),
                          minVerticalPadding: 20,
                          leading: Image.asset(item.image),
                          title: Text(item.productName),
                          subtitle: Text('${item.productPrice} DT'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  if (item.quantity.value > 1) {
                                    cart.decreaseQuantity(item);
                                    dbHelper.updateItem(item);
                                  }
                                },
                              ),
                              ValueListenableBuilder<int>(
                                valueListenable: item.quantity,
                                builder: (context, value, child) {
                                  return Text(value.toString());
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  cart.increaseQuantity(item);
                                  dbHelper.updateItem(item);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  cart.removeItem(item);
                                  dbHelper.deleteItem(item.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        'Prix total : ${cart.totalPrice} DT',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 10),
                      AppButton(
                        text: 'Planifier un ramassage'.toUpperCase(),
                        textColor: white,
                        color: LSColorPrimary,
                        onTap: () {
                          LSOrder order = LSOrder();
                          order.setCartItems(cartItems);
                          LSScheduleScreen().launch(context);
                        },
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
      bottomNavigationBar: LSNavBar(selectedIndex: _selectedIndex),
    );
  }
}
