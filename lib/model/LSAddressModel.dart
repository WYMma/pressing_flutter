class LSAddressModel {
  final int id;
  final String area;
  final String street;
  final String city;
  final String postalCode;
  final String type;

  LSAddressModel({
    required this.id,
    required this.area,
    required this.street,
    required this.city,
    required this.postalCode,
    required this.type,
  });

  LSAddressModel.fromJson(Map<String, dynamic> json)
      : id = json['addressID'] as int,
        area = json['area'],
        street = json['street'],
        city = json['city'],
        postalCode = json['postal_code'],
        type = json['type'];

  static List<LSAddressModel> savedAddresses = [];

  @override
  String toString() {
    return 'Ville: $city,\nRégion: $area,\nRue: $street,\nCode Postal: $postalCode.';
  }
}
