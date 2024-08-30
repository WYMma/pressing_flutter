import 'dart:convert';

class LSServicesModel {
  int serviceID;
  String name;
  String description;
  double price;
  String image; // URL or path to the image

  LSServicesModel({
    required this.serviceID,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });

  static List<LSServicesModel> services = [];

  factory LSServicesModel.fromJson(Map<String, dynamic> json) {
    return LSServicesModel(
      serviceID: json['serviceID'],
      name: json['name'],
      description: json['description'],
      price: double. parse(json['price']),
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceID': serviceID,
      'name': name,
      'nameServ': description,
      'price': price,
      'image': image,
    };
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}
