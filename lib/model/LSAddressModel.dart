import 'package:flutter/foundation.dart';

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

  static List<LSAddressModel> savedAddresses = [
    LSAddressModel(
      id: 1,
      area: 'Phase 5, Sector 59, Mohali',
      street: 'Plot no. F-126, First Floor, Phase 8b, Industrial Area Mohali',
      city: 'Mohali',
      postalCode: '160055',
      type: 'Travail',
    ),
    LSAddressModel(
      id: 2,
      area: 'Phase 5, Sector 59, Mohali',
      street: 'Plot no. F-126, First Floor, Phase 8b, Industrial Area Mohali',
      city: 'Mohali',
      postalCode: '160055',
      type: 'Travail',
    ),
  ];

  static void addAddress(LSAddressModel address) {
    savedAddresses.add(address);
  }

  static void editAddress(LSAddressModel oldAddress, LSAddressModel newAddress) {
    int index = savedAddresses.indexOf(oldAddress);
    if (index != -1) {
      savedAddresses[index] = newAddress;
    }
  }

  static void deleteAddress(LSAddressModel address) {
    savedAddresses.remove(address);
  }

  @override
  String toString() {
    return 'Ville: $city,\nRégion: $area,\nRue: $street,\nCode Postal: $postalCode.';
  }
}
