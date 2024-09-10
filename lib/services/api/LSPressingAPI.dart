import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:laundry/model/LSPressingModel.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:laundry/services/dio.dart';

class LSPressingAPI extends ChangeNotifier {

  final storage = FlutterSecureStorage();

  Future<void> fetchPressings() async {
    String? token = await storage.read(key: 'token');
    try {
      Dio.Response response = await dio().get(
        '/pressing',
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.statusCode == 200) {
        LSPressingModel.pressings = List<LSPressingModel>.from(response.data.map((shop) => LSPressingModel.fromJson(shop)));
      }
    } catch (e) {
      print("Error fetching shops: $e");
    }
  }
}