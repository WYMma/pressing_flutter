import 'package:dio/dio.dart' as Dio;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:laundry/model/LSCartModel.dart';
import 'package:laundry/services/dio.dart';
import 'package:flutter/material.dart';

class LSLignePanierAPI extends ChangeNotifier {
  final storage = FlutterSecureStorage();

  // Method to create a new cart and return its ID
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

  // Method to upload LignePanier items to the server
  Future<void> uploadLignePanierItems(List<LSCartModel> cartItems, double totalPrice) async {
    try {
      // First, create a new cart and get its ID
      int? cartID = await createCart(totalPrice);
      if (cartID == null) {
        throw Exception('Failed to create cart');
      }

      // Upload each item to the server
      for (LSCartModel item in cartItems) {
        await storeLignePanierItem(item, cartID);
      }
    } catch (e) {
      print('Error uploading LignePanier items: $e');
      rethrow;
    }
  }

  // Method to store a single LignePanier item
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
}