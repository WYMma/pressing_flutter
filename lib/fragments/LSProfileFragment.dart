import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laundry/components/LSNavBarCourier.dart';
import 'package:laundry/main.dart';
import 'package:laundry/screens/LSNotificationsScreen.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:laundry/components/LSNavBar.dart';
import 'package:laundry/services/localDB/LSCartProvider.dart';
import 'package:laundry/fragments/LSCartFragment.dart';
import 'package:laundry/model/LSNotificationsModel.dart';
import 'package:laundry/screens/LSSignInScreen.dart';
import 'package:laundry/services/LSAuthService.dart';
import 'package:laundry/screens/Profile/Addresse/LSSavedAddressesScreen.dart';
import 'package:laundry/screens/Profile/Paiement/LSSavedPaymentMethodsScreen.dart';
import 'package:laundry/screens/Profile/LSSettings.dart';
import 'package:laundry/utils/LSColors.dart';

class LSProfileFragment extends StatefulWidget {
  const LSProfileFragment({Key? key}) : super(key: key);

  @override
  LSProfileFragmentState createState() => LSProfileFragmentState();
}

class LSProfileFragmentState extends State<LSProfileFragment> {
  bool isNotificationsEnabled = appStore.isNotificationsEnabled;
  bool isSignedIn = appStore.isSignedIn;
  int _selectedIndex = 4;

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
        Consumer<LSAuthService>(
          builder: (context, authService, child) {
            if (authService.user!.role == 'Client') {
              return Row(
                children: [
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
                ],
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
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
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.red,
                        backgroundImage: CachedNetworkImageProvider(
                          authService.user!.avatar,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        authService.user!.role == 'Client' ? '${authService.client!.first_name} ${authService.client!.last_name}' : '${authService.transporteur!.first_name} ${authService.transporteur!.last_name}',
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
          Consumer<LSAuthService>(
            builder: (context, authService, child) {
              if (authService.user!.role == 'Client') {
                return Column(
                  children: [
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
                  ],
                );
              } else {
                return SizedBox.shrink();
              }
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
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    title: Text('Confirmation'),
                    content: Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
                    actions: <Widget>[
                      TextButton.icon(
                        icon: Icon(Icons.cancel, color: LSColorPrimary),
                        label: Text('Non', style: TextStyle(color: LSColorPrimary, fontWeight: FontWeight.bold)),
                        onPressed: () {
                          Navigator.of(dialogContext).pop(); // Close the dialog
                        },
                      ),
                      TextButton.icon(
                        icon: Icon(Icons.logout, color: Colors.red),
                        label: Text('Oui', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                        onPressed: () async {
                          // Perform logout actions
                          context.read<LSCartProvider>().clearCart();
                          Navigator.of(dialogContext).pop();
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => LSSignInScreen()),
                                (Route<dynamic> route) => false,
                          );
                          var authService = Provider.of<LSAuthService>(context, listen: false);
                          await authService.logout();
                          Fluttertoast.showToast(msg: "Déconnexion réussie");
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: Provider.of<LSAuthService>(context, listen: false).user?.role == 'Client' ? LSNavBar(selectedIndex: _selectedIndex) : LSNavBarCourier(selectedIndex: 3),
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
