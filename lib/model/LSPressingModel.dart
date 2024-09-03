import 'package:laundry/services/dio.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LSPressingModel {
  String name;
  String writtenAddress;
  String googleMapAddress;
  String phoneNumber;
  String description;
  String image;

  LSPressingModel({
    required this.name,
    required this.writtenAddress,
    required this.googleMapAddress,
    required this.phoneNumber,
    required this.description,
    required this.image,
  });

  static List<LSPressingModel> pressings = [];

  factory LSPressingModel.fromJson(Map<String, dynamic> json) {
    return LSPressingModel(
      name: json['name'],
      writtenAddress: json['written_address'],
      googleMapAddress: json['google_map_address'],
      phoneNumber: json['phone_number'],
      description: json['description'],
      image: json['image'],
    );
  }


  @override
  String toString() {
    return 'LSPressingModel{name: $name, writtenAddress: $writtenAddress, googleMapAddress: $googleMapAddress, phoneNumber: $phoneNumber, image: $image, description: $description}';
  }

  static Future<void> fetchPressings() async {
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'token');
    try {
      Dio.Response response = await dio().get(
        '/pressing',
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.statusCode == 200) {
        pressings = List<LSPressingModel>.from(response.data.map((shop) => LSPressingModel.fromJson(shop)));
      }
    } catch (e) {
      print("Error fetching shops: $e");
    }
  }
}
