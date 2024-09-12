import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:laundry/model/LSMissionModel.dart';
import 'package:laundry/model/LSOrder.dart';
import 'package:laundry/services/api/LSAddressAPI.dart';
import 'package:laundry/services/api/LSCommandeAPI.dart';
import 'package:laundry/services/dio.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:provider/provider.dart';

class LSMissionAPI extends ChangeNotifier {
  final storage = FlutterSecureStorage();

  Future<void> getAllMissions(BuildContext context) async {
    String? token = await storage.read(key: 'token');
    try {
      Dio.Response response = await dio().get(
        '/missions',
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      List data = response.data;
      LSMissionModel.MissionHistory.clear();
      for (var item in data) {
        LSMissionModel mission = LSMissionModel.fromJson(item);
        LSOrder order = LSOrder();
        order.id = item['commande']['commandeID'];
        order.clientID = item['commande']['clientID'].toString();
        order.address = await Provider.of<LSAddressAPI>(context, listen: false).getAddressById(item['commande']['addressID'].toString());
        order.pickUpDate = DateTime.parse(item['commande']['pickUpDate']);
        order.deliveryDate = DateTime.parse(item['commande']['deliveryDate']);
        order.paymentMethod = item['commande']['paymentMethod'];
        order.deliveryType = item['commande']['deliveryType'];
        order.confirmationTimestamp = DateTime.parse(item['commande']['confirmationTimestamp']);
        order.status = item['commande']['status'];
        order.cartID = item['commande']['cartID'].toString();
        order.setCartItems(await Provider.of<LSCommandeAPI>(context, listen: false).fetchLignePaniers((item['commande']['cartID'])));
        order.totalPrice = double.parse(item['commande']['totalPrice']);
        order.isConfirmed = item['commande']['isConfirmed'] == 1;
        order.isPickedUp = item['commande']['isPickedUp'] == 1;
        order.isInProgress = item['commande']['isInProgress'] == 1;
        order.isShipped = item['commande']['isShipped'] == 1;
        order.isDelivered = item['commande']['isDelivered'] == 1;
        mission.setOrder(order);
        LSOrder.reset();
        LSMissionModel.MissionHistory.add(mission);
      }
    } catch (e) {
      print("Error retrieving Missions: $e");
    }
  }

  Future<void> updateMission(int id) async {
    String? token = await storage.read(key: 'token');
    try {
      await dio().get(
        '/missions/$id',
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } catch (e) {
      print("Error updating Mission: $e");
    }
  }
}
