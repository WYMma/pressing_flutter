import 'package:flutter/cupertino.dart';

class LSCartModel {
  final int id;
  final String productId;
  final String productName;
  final double initialPrice;
  final double productPrice;
  final ValueNotifier<int> quantity;
  final String unitTag;
  final String image;

  LSCartModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.initialPrice,
    required this.productPrice,
    required this.quantity,
    required this.unitTag,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'initialPrice': initialPrice,
      'productPrice': productPrice,
      'quantity': quantity.value,
      'unitTag': unitTag,
      'image': image,
    };
  }

  static LSCartModel fromMap(Map<String, dynamic> map) {
    return LSCartModel(
      id: map['id'],
      productId: map['productId'],
      productName: map['productName'],
      initialPrice: map['initialPrice'],
      productPrice: map['productPrice'],
      quantity: ValueNotifier(map['quantity']),
      unitTag: map['unitTag'],
      image: map['image'],
    );
  }
}
