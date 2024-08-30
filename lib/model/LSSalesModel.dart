import 'dart:convert';

class LSSalesModel {
  int saleID;
  String name;
  String description;
  double discount;
  DateTime startDate;
  DateTime endDate;
  String image; // URL or path to the image
  int serviceID;

  LSSalesModel({
    required this.saleID,
    required this.name,
    required this.description,
    required this.discount,
    required this.startDate,
    required this.endDate,
    required this.image,
    required this.serviceID,
  });

  factory LSSalesModel.fromJson(Map<String, dynamic> json) {
    return LSSalesModel(
      saleID: json['saleID'],
      name: json['name'],
      description: json['description'],
      discount: double.parse(json['discount']),
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      image: json['image'],
      serviceID: json['serviceID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'saleID': saleID,
      'name': name,
      'description': description,
      'discount': discount,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'image': image,
      'serviceID': serviceID,
    };
  }

  @override
  String toString() {
    return jsonEncode(this);
  }

  static List<LSSalesModel> sales = [];
}
