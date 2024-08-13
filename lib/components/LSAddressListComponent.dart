import 'package:flutter/material.dart';
import 'package:laundry/main.dart';
import 'package:laundry/model/LSAddressModel.dart';
import 'package:laundry/screens/Profile/Addresse/LSAddAddressScreen.dart';
import 'package:laundry/screens/Profile/Addresse/LSEditAddressScreen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:laundry/utils/LSColors.dart';

import '../model/LSOrder.dart';

class LSAddressListComponent extends StatefulWidget {
  final Function refreshCallback;

  LSAddressListComponent({required this.refreshCallback});

  @override
  _LSAddressListComponentState createState() => _LSAddressListComponentState();
}

class _LSAddressListComponentState extends State<LSAddressListComponent> {
  LSAddressModel? selectedAddress = LSOrder.exists() ? LSOrder().address : null;

  void _showOptionsOverlay(BuildContext context, LSAddressModel address) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.edit, color: LSColorPrimary),
                  title: Text('Modifier', style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LSEditAddressScreen(address: address)),
                    ).then((_) {
                      widget.refreshCallback();
                      setState(() {});
                    });
                  },
                ),
                ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text('Supprimer', style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color)),
                  onTap: () {
                    LSAddressModel.deleteAddress(address);
                    widget.refreshCallback();
                    setState(() {});
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _addAddress(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LSAddAddressScreen()),
    ).then((_) {
      widget.refreshCallback(); // Refresh list when coming back from add screen
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: LSAddressModel.savedAddresses.length,
        itemBuilder: (context, index) {
          LSAddressModel address = LSAddressModel.savedAddresses[index];
          bool isSelected = address == selectedAddress;
          return GestureDetector(
            onLongPress: () {
              setState(() {
                selectedAddress = address;
                if (LSOrder.exists()) {
                  LSOrder order = LSOrder();
                  order.setAddress(address);
                }
              });
              _showOptionsOverlay(context, address);
            },
            onTap: () {
              setState(() {
                selectedAddress = address;
                if (LSOrder.exists()) {
                  LSOrder order = LSOrder();
                  order.setAddress(address);
                }
              });
            },
            child: Card(
              color: isSelected ? Colors.blue : context.cardColor,
              elevation: isSelected ? 4 : 0,
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: ListTile(
                title: Text(address.toString(), style: boldTextStyle(weight: isSelected ? FontWeight.w600 : FontWeight.normal)),
              ),
            ).paddingTop(25),
          );
        },
      ),
      backgroundColor: appStore.isDarkModeOn ? context.scaffoldBackgroundColor : LSColorSecondary,
      floatingActionButton: FloatingActionButton(
        backgroundColor: LSColorPrimary,
        onPressed: () => _addAddress(context),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
