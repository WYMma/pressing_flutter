import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laundry/components/LSNavBar.dart';
import 'package:laundry/db/LSCartProvider.dart';
import 'package:laundry/fragments/LSCartFragment.dart';
import 'package:laundry/screens/LSSignInScreen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:avatar_view/avatar_view.dart';
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

class LSProfileFragmentState extends State<LSProfileFragment> with AutomaticKeepAliveClientMixin {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('Profile', center: true, color: context.cardColor, showBack: false,actions: [
        IconButton(
          icon: Icon(Icons.notifications),
          color: context.iconColor,
          onPressed: () {
            LSNotificationsScreen().launch(context);
          },
        ),
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
      ]),
      backgroundColor: appStore.isDarkModeOn ? context.scaffoldBackgroundColor : LSColorSecondary,
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: () => _showImagePickerOptions(context),
                child: AvatarView(
                  radius: 60,
                  borderColor: Colors.yellow,
                  isOnlyText: false,
                  text: const Text(
                    'C',
                    style: TextStyle(color: Colors.white, fontSize: 50),
                  ),
                  avatarType: AvatarType.CIRCLE,
                  backgroundColor: Colors.red,
                  imagePath: _image?.path ?? LSAvatar,
                  placeHolder: const Icon(
                    Icons.person,
                    size: 50,
                  ),
                  errorWidget: const Icon(
                    Icons.error,
                    size: 50,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Yassin Manita",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text("Client"),
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

  @override
  bool get wantKeepAlive => true;

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
}//
