import 'package:dio/dio.dart' as Dio;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:laundry/model/LSItemModel.dart';
import 'package:laundry/services/dio.dart';
import 'package:flutter/material.dart';

class LSItemAPI extends ChangeNotifier {
  final storage = FlutterSecureStorage();
  static Map<int, String> categories = {
    0: 'Tout',
  };

  Future<void> getAllItems() async {
    try {
      String? token = await storage.read(key: 'token');
      Dio.Response response = await dio().get(
        '/items',
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      List<LSItemModel> items = (response.data as List)
          .map((itemJson) => LSItemModel.fromJson(itemJson))
          .toList();
      LSItemModel.items = items; // Assign directly
    } catch (e) {
      print('Error fetching items: $e');
      rethrow;
    }
  }

  Future<void> fetchCategoryIdAndName() async {
    try {
      String? token = await storage.read(key: 'token');
      final response = await dio().get('/categories',
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),);

      if (response.statusCode == 200) {
        // Create a map from the response data
        for (var category in response.data) {
          int id = category['categorieID'];
          String name = category['name'];
          LSItemAPI.categories[id] = name;
        }
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error fetching categories: $e');
      throw e; // Optionally, you can handle the error differently
    }
  }
}
