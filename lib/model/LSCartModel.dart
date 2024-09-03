import 'package:flutter/cupertino.dart';

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
      initialPrice: map['initialPrice'],
      productPrice: map['productPrice'],
      quantity: ValueNotifier(map['quantity']),
      categorieID: map['categorieID'],
      image: map['image'],
    );
  }

  @override
  String toString() {
    return 'LSCartModel{id: $id, productId: $productId, serviceID: $serviceID, productName: $productName, initialPrice: $initialPrice, productPrice: $productPrice, quantity: $quantity, categorieID: $categorieID, image: $image}';
  }
}
