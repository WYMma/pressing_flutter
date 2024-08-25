import 'package:flutter/material.dart';
import 'package:laundry/api/LSAddressAPI.dart';
import 'package:laundry/main.dart';
import 'package:laundry/model/LSAddressModel.dart';
import 'package:laundry/screens/Profile/Addresse/LSAddAddressScreen.dart';
import 'package:laundry/screens/Profile/Addresse/LSEditAddressScreen.dart';
import 'package:laundry/services/LSAuthService.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:laundry/utils/LSColors.dart';
import 'package:provider/provider.dart';

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
                    Navigator.pop(context);
                    _deleteAddress(address);
                    widget.refreshCallback();
                    setState(() {});
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

  void _deleteAddress(LSAddressModel address) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Êtes-vous sûr de vouloir supprimer cette adresse ?'),
          elevation: 5,
          actions: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.cancel, color: Colors.red), // Add your trailing icon
              label: Text('Non', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton.icon(
              icon: Icon(Icons.check_circle, color: LSColorPrimary), // Add your trailing icon
              label: Text('Oui', style: TextStyle(color: LSColorPrimary, fontWeight: FontWeight.bold)),
              onPressed: () async {
                var authService = Provider.of<LSAuthService>(context, listen: false);
                await Provider.of<LSAddressAPI>(context, listen: false).deleteAddress(
                  addressID: address.id.toString(),
                  clientID: authService.client!.clientID,
                );
                widget.refreshCallback();
                setState(() {});
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
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
