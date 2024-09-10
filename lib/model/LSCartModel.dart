import 'package:flutter/cupertino.dart';
import 'package:laundry/model/LSItemModel.dart';

class LSCartModel {
  final int id;
  final String productId;
  final String serviceID;
  final String productName;
  final double initialPrice;
  final double productPrice;
  final ValueNotifier<int> quantity;
  final String categorieID;
  final String image;

  LSCartModel({
    required this.id,
    required this.productId,
    required this.serviceID,
    required this.productName,
    required this.initialPrice,
    required this.productPrice,
    required this.quantity,
    required this.categorieID,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'serviceID': serviceID,
      'productName': productName,
      'initialPrice': initialPrice,
      'productPrice': productPrice,
      'quantity': quantity.value,
      'categorieID': categorieID,
      'image': image,
    };
  }

  static LSCartModel fromMap(Map<String, dynamic> map) {
    return LSCartModel(
      id: map['id'],
      productId: map['productId'],
      serviceID: map['serviceID'],
      productName: map['productName'],
      initialPrice: (map['initialPrice']),
      productPrice: map['productPrice'],
      quantity: ValueNotifier(map['quantity']),
      categorieID: map['categorieID'],
      image: map['image'],
    );
  }

  static LSCartModel fromMap2(Map<String, dynamic> map) {
    return LSCartModel(
      id: map['cartID'] is int ? map['cartID'] as int : 0, // Ensure `id` is an int
      productId: map['itemID']?.toString() ?? '', // Ensure `productId` is a string
      serviceID: map['serviceID']?.toString() ?? '', // Ensure `serviceID` is a string
      productName: LSItemModel.items.firstWhere((item) => item.itemID == map['itemID']?.toString()).name, // Ensure `productName` is a string
      initialPrice: double.tryParse(map['initialPrice']?.toString() ?? '0') ?? 0.0, // Convert to double safely
      productPrice: double.tryParse(map['productPrice']?.toString() ?? '0') ?? 0.0, // Convert to double safely
      quantity: ValueNotifier<int>(map['quantity']?.toInt() ?? 0), // Ensure quantity is an int
      categorieID: map['categorieID']?.toString() ?? '', // Ensure `categorieID` is a string
      image: map['image']?.toString() ?? '', // Ensure `image` is a string
    );
  }

  @override
  String toString() {
    return 'LSCartModel{id: $id, productId: $productId, serviceID: $serviceID, productName: $productName, initialPrice: $initialPrice, productPrice: $productPrice, quantity: $quantity, categorieID: $categorieID, image: $image}';
  }
}
