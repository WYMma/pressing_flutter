import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:laundry/main.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:laundry/model/LSAddressModel.dart';
import 'package:laundry/utils/LSColors.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LSAddAddressScreen extends StatefulWidget {
  static String tag = '/LSAddAddressScreen';

  @override
  LSAddAddressScreenState createState() => LSAddAddressScreenState();
}

class LSAddAddressScreenState extends State<LSAddAddressScreen> {
  TextEditingController areaCont = TextEditingController();
  TextEditingController streetCont = TextEditingController();
  TextEditingController cityCont = TextEditingController();
  TextEditingController postalCodeCont = TextEditingController();
  List<String> addressTypes = ['Domicile', 'Travail', 'Autre'];
  String selectedAddressType = 'Domicile'; // Default selection

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: 'La localisation est désactivée. Veuillez l\'activer.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: 'La localisation est refusée.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(msg: 'La localisation est refusée de manière permanente.');
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    await _getAddressFromLatLng(position);
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        setState(() {
          cityCont.text = place.administrativeArea ?? 'État inconnu';
          areaCont.text = place.locality ?? 'Ville inconnue';
          postalCodeCont.text = place.postalCode ?? 'Code postal inconnu';
          streetCont.text = place.street ?? 'Rue inconnue';
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Impossible de récupérer l\'adresse.');
    }
  }

  void selectLocationFromMap() {
    _determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('Ajouter une adresse', color: context.cardColor, center: true),
      backgroundColor: appStore.isDarkModeOn ? context.scaffoldBackgroundColor : LSColorSecondary,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 25),
            TextFormField(
              controller: cityCont,
              decoration: InputDecoration(
                labelText: 'Ville',
                labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color), // Adjusted for dark mode
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                hintText: 'Sélectionner votre Ville',
                prefixIcon: Icon(Icons.location_city),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: areaCont,
              decoration: InputDecoration(
                labelText: 'Région',
                labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color), // Adjusted for dark mode
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                hintText: 'Sélectionner votre Région',
                prefixIcon: Icon(Icons.map),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: streetCont,
              decoration: InputDecoration(
                labelText: 'Rue',
                labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color), // Adjusted for dark mode
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                hintText: 'Sélectionner votre Rue',
                prefixIcon: Icon(Icons.directions),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: postalCodeCont,
              decoration: InputDecoration(
                labelText: 'Code Postal',
                labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color), // Adjusted for dark mode
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                hintText: 'Sélectionner votre Code Postal',
                prefixIcon: Icon(Icons.markunread_mailbox),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Type d\'adresse',
                labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color), // Adjusted for dark mode
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                prefixIcon: Icon(Icons.pin_drop_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              value: selectedAddressType,
              items: addressTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  selectedAddressType = value!;
                });
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: LSColorPrimary,
        onPressed: () {
          selectLocationFromMap();
        },
        child: Icon(Icons.location_on, color: white),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: context.cardColor,
          boxShadow: defaultBoxShadow(),
        ),
        padding: EdgeInsets.all(8),
        child: AppButton(
          text: 'Enregistrer et continuer'.toUpperCase(),
          textColor: white,
          color: Colors.blue,
          onTap: () {
            // Logic to save the address
            LSAddressModel.addAddress(
              LSAddressModel(
                area: areaCont.text,
                street: streetCont.text,
                city: cityCont.text,
                postalCode: postalCodeCont.text,
                type: selectedAddressType,
              ),
            );
            Fluttertoast.showToast(
              msg: 'Adresse ajoutée avec succès.',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            Navigator.pop(context); // Close the add address screen
          },
        ),
      ),
    );
  }
}
