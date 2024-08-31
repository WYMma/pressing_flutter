class LSItemModel {
  final String name;
  final double price;
  final String photo;
  final String categorieID;
  final String itemID;

  LSItemModel({
    required this.name,
    required this.price,
    required this.photo,
    required this.categorieID,
    required this.itemID,
  });

  static List<LSItemModel> items = [];

  // Factory method to create an instance of LSItemModel from JSON
  factory LSItemModel.fromJson(Map<String, dynamic> json) {
    return LSItemModel(
      name: json['name'].toString(),
      price: double.parse(json['price']), // Ensure price is converted to double
      photo: json['photo'].toString(),
      categorieID: json['categorieID'].toString(),
      itemID: json['itemID'].toString(),
    );
  }

  @override
  String toString() {
    return 'LSItemModel{name: $name, price: $price, photo: $photo, categorieID: $categorieID, itemID: $itemID}';
  }
}
