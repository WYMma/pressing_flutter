import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laundry/components/LSNavBar.dart';
import 'package:laundry/localDB/LSCartProvider.dart';
import 'package:laundry/fragments/LSCartFragment.dart';
import 'package:laundry/model/LSNotificationsModel.dart';
import 'package:laundry/screens/LSSignInScreen.dart';
import 'package:laundry/services/LSAuthService.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../screens/LSNotificationsScreen.dart';
import '../screens/Profile/Addresse/LSSavedAddressesScreen.dart';
import '../screens/Profile/Paiement/LSSavedPaymentMethodsScreen.dart';
import '../screens/Profile/LSSettings.dart';
import '../utils/LSImages.dart';
import '../utils/LSColors.dart';

class LSProfileFragment extends StatefulWidget {
  const LSProfileFragment({Key? key}) : super(key: key);

  @override
  LSProfileFragmentState createState() => LSProfileFragmentState();
}

class LSProfileFragmentState extends State<LSProfileFragment> {
  bool isNotificationsEnabled = appStore.isNotificationsEnabled;
  bool isSignedIn = appStore.isSignedIn;
  File? _image;
  int _selectedIndex = 4;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Camera'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('Profile', center: true, color: context.cardColor, showBack: false, actions: [
        InkWell(
          onTap: () {
            LSNotificationsScreen().launch(context);
          },
          child: Center(
            child: Badge(
              label: Text(LSNotificationsModel.unreadCount.toString(), style: const TextStyle(color: Colors.white)),
              child: Icon(LSNotificationsModel.unreadCount == 0 ? Icons.notifications_none : Icons.notifications, color: context.iconColor),
            ),
          ),
        ),
        const SizedBox(width: 10.0),
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
                    style: const TextStyle(color: Colors.white),
                  );
                },
              ),
              child: Icon(Icons.shopping_cart, color: context.iconColor),
            ),
          ),
        ),
        const SizedBox(width: 20.0),
      ]),
      backgroundColor: appStore.isDarkModeOn ? context.scaffoldBackgroundColor : LSColorSecondary,
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Column(
            children: [
              Consumer<LSAuthService>(
                builder: (context, authService, child) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () => _showImagePickerOptions(context),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.red,
                          backgroundImage: CachedNetworkImageProvider(
                            authService.user!.avatar ?? LSAvatar,
                          ),
                          child: authService.user!.avatar == null
                              ? const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.white,
                          )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${authService.client!.first_name} ${authService.client!.last_name}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(authService.user!.role),
                    ],
                  );
                },
              ),
            ],
          ).paddingTop(16),
          const SizedBox(height: 35),
          buildProfileItem(
            context,
            title: 'Paramètres',
            icon: Icons.settings_rounded,
            onTap: () {
              LSSettings().launch(context);
            },
          ),
          buildProfileItem(
            context,
            icon: Icons.location_on_outlined,
            title: "Location",
            onTap: () {
              LSSavedAddressesScreen().launch(context);
            },
          ),
          buildProfileItem(
            context,
            icon: Icons.credit_card,
            title: "Méthode de Paiement",
            onTap: () {
              LSSavedPaymentMethodsScreen().launch(context);
            },
          ),
          buildProfileItem(
            context,
            title: "Notifications",
            icon: CupertinoIcons.bell,
            trailing: Switch(
              value: isNotificationsEnabled,
              activeColor: LSColorPrimary,
              activeTrackColor: LSColorSecondary,
              onChanged: (value) {
                setState(() {
                  isNotificationsEnabled = value;
                  appStore.toggleNotificationsStatus(value: value);
                });
              },
            ),
            onTap: () {
              setState(() {
                isNotificationsEnabled = !isNotificationsEnabled;
                appStore.toggleNotificationsStatus(value: isNotificationsEnabled);
              });
            },
          ),
          buildProfileItem(
            context,
            title: "Déconnexion",
            icon: CupertinoIcons.arrow_right_arrow_left,
            onTap: () {
              isSignedIn = false;
              appStore.toggleSignInStatus(value: isSignedIn);
              Fluttertoast.showToast(msg: "Déconnexion réussie");
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LSSignInScreen()),
                    (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: LSNavBar(selectedIndex: _selectedIndex),
    );
  }
}

Widget buildProfileItem(BuildContext context,
    {required String title,
      required IconData icon,
      Widget? trailing,
      required Function() onTap}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: Card(
      elevation: 4,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          title,
          style: boldTextStyle(),
        ),
        trailing: trailing ?? const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    ),
  );
}
