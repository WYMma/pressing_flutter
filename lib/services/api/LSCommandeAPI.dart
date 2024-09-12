import 'package:dio/dio.dart' as Dio;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:laundry/model/LSAddressModel.dart';
import 'package:laundry/model/LSCartModel.dart';
import 'package:laundry/model/LSOrder.dart';
import 'package:laundry/services/dio.dart';
import 'package:flutter/material.dart';

class LSCommandeAPI extends ChangeNotifier {
  final storage = FlutterSecureStorage();

  Future<int?> createCart(double totalPrice) async {
    try {
      String? token = await storage.read(key: 'token');
      Dio.Response response = await dio().post(
        '/create-cart',
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
        data: {'total_price': totalPrice},
      );
      return response.data['cartID'] as int;
    } catch (e) {
      print('Error creating cart: $e');
      return null;
    }
  }

  Future<void> uploadLignePanierItems(LSOrder order, double totalPrice) async {
    try {
      // First, create a new cart and get its ID
      int? cartID = await createCart(totalPrice);
      if (cartID == null) {
        throw Exception('Failed to create cart');
      }

      // Upload each item to the server
      for (LSCartModel item in order.cartItems) {
        await storeLignePanierItem(item, cartID);
      }

      await createCommande(order, cartID);

    } catch (e) {
      print('Error uploading LignePanier items: $e');
      rethrow;
    }
  }

  Future<void> storeLignePanierItem(LSCartModel item, int cartID) async {
    try {
      String? token = await storage.read(key: 'token');
      await dio().post(
        '/lignepanier',
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
        data: {
          'quantity': item.quantity.value,
          'serviceID': item.serviceID,
          'cartID': cartID,
          'itemID': item.productId,
          'initialPrice': item.initialPrice,
          'productPrice': item.productPrice,
          'categorieID': item.categorieID,
        },
      );
    } catch (e) {
      print('Error storing LignePanier item: $e');
    }
  }

  Future<void> createCommande(LSOrder order, int cartID) async {
    String? token = await storage.read(key: 'token');

    // Define a date format
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

    try {
      Dio.Response response = await dio().post(
        '/commande',
        data: {
          'clientID': order.clientID,
          'addressID': order.address?.id,
          'pickUpDate': dateFormat.format(order.pickUpDate), // Format the DateTime
          'deliveryDate': dateFormat.format(order.deliveryDate), // Format the DateTime
          'paymentMethod': order.paymentMethod,
          'deliveryType': order.deliveryType,
          'confirmationTimestamp': dateFormat.format(order.confirmationTimestamp), // Format the DateTime
          'status': order.status,
          'cartID': cartID,
          'totalPrice': order.totalPrice,
          'isConfirmed': order.isConfirmed,
          'isPickedUp': order.isPickedUp,
          'isInProgress': order.isInProgress,
          'isShipped': order.isShipped,
          'isDelivered': order.isDelivered,
        },
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 201) {
        print("Commande created successfully");
        await getAllCommandes();
      } else {
        print("Failed to create Commande: ${response.statusCode}");
      }
    } catch (e) {
      print("Error creating Commande: $e");
    }
  }

  Future<List<LSCartModel>> fetchLignePaniers(int cartID) async {
    String? token = await storage.read(key: 'token');
    List<LSCartModel> cartItems = [];

    try {
      Dio.Response response = await dio().get(
        '/lignepanier/$cartID',
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      print(response.data);
      if (response.statusCode == 200) {
        List<dynamic>? data = response.data;
        if (data != null) {
          cartItems = data
              .map((item) {
            if (item is Map<String, dynamic>) {
              return LSCartModel.fromMap2(item);
            } else {
              print("Warning: Item is not a valid map");
              return null; // Filter out invalid items
            }
          })
              .whereType<LSCartModel>() // Filters out null values
              .toList();
        } else {
          print("Warning: Response data is null");
        }
      } else {
        print("Failed to fetch LignePanier items: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching LignePanier items: $e");
    }

    return cartItems;
  }

  Future<void> updateCommande(int commandeID, LSOrder updatedOrder) async {
    String? token = await storage.read(key: 'token');
    try {
      Dio.Response response = await dio().put(
        '/commande/$commandeID',
        data: {
          'clientID': updatedOrder.clientID,
          'addressID': updatedOrder.address?.id,
          'pickUpDate': updatedOrder.pickUpDate.toIso8601String(),
          'deliveryDate': updatedOrder.deliveryDate.toIso8601String(),
          'paymentMethod': updatedOrder.paymentMethod,
          'deliveryType': updatedOrder.deliveryType,
          'confirmationTimestamp': updatedOrder.confirmationTimestamp.toIso8601String(),
          'status': updatedOrder.status,
          'cartID': updatedOrder.cartID,
          'totalPrice': updatedOrder.totalPrice,
          'isConfirmed': updatedOrder.isConfirmed,
          'isPickedUp': updatedOrder.isPickedUp,
          'isInProgress': updatedOrder.isInProgress,
          'isShipped': updatedOrder.isShipped,
          'isDelivered': updatedOrder.isDelivered,
        },
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        print("Commande updated successfully");
      } else {
        print("Failed to update Commande: ${response.statusCode}");
      }
    } catch (e) {
      print("Error updating Commande: $e");
    }
  }

  Future<void> pickup(int commandeID) async {
    String? token = await storage.read(key: 'token');
    try {
      Dio.Response response = await dio().put(
        '/commande/pickup/$commandeID',
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.statusCode == 200) {
        print("Commande updated successfully");
      } else {
        print("Failed to update Commande: ${response.statusCode}");
      }
    } catch (e) {
      print("Error updating Commande: $e");
    }
  }

  Future<void> deliver(int commandeID) async {
    String? token = await storage.read(key: 'token');
    try {
      Dio.Response response = await dio().put(
        '/commande/deliver/$commandeID',
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.statusCode == 200) {
        print("Commande updated successfully");
      } else {
        print("Failed to update Commande: ${response.statusCode}");
      }
    } catch (e) {
      print("Error updating Commande: $e");
    }
  }

  Future<void> deleteCommande(int commandeID) async {
    String? token = await storage.read(key: 'token');
    try {
      Dio.Response response = await dio().delete(
        '/commande/$commandeID',
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 204) {
        print("Commande deleted successfully");
      } else {
        print("Failed to delete Commande: ${response.statusCode}");
      }
      await getAllCommandes();
    } catch (e) {
      print("Error deleting Commande: $e");
    }
  }

  Future<void> getAllCommandes() async {
    String? token = await storage.read(key: 'token');
    try {
      Dio.Response response = await dio().get(
        '/commande',
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        LSOrder.OrderHistory.clear();

        for (var json in data) {
          LSOrder.reset();
          LSOrder order = LSOrder();
          order.id = json['commandeID'];
          order.clientID = json['clientID'].toString();
          order.address = LSAddressModel.savedAddresses.firstWhere((address) => address.id == json['addressID']);
          order.pickUpDate = DateTime.parse(json['pickUpDate']);
          order.deliveryDate = DateTime.parse(json['deliveryDate']);
          order.paymentMethod = json['paymentMethod'];
          order.deliveryType = json['deliveryType'];
          order.confirmationTimestamp = DateTime.parse(json['confirmationTimestamp']);
          order.status = json['status'];
          order.cartID = json['cartID'].toString();
          // Fetch the cart items and await the result
          order.setCartItems(await fetchLignePaniers(json['cartID']));
          order.totalPrice = double.parse(json['totalPrice']);
          order.isConfirmed = json['isConfirmed'] == 1;
          order.isPickedUp = json['isPickedUp'] == 1;
          order.isInProgress = json['isInProgress'] == 1;
          order.isShipped = json['isShipped'] == 1;
          order.isDelivered = json['isDelivered'] == 1;
          LSOrder.OrderHistory.add(order);
          LSOrder.reset();
        }
      } else {
        print("Failed to retrieve Commandes: ${response.statusCode}");
      }
    } catch (e) {
      print("Error retrieving Commandes: $e");
    }
  }
}