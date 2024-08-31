import 'package:dio/dio.dart' as Dio;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:laundry/model/LSItemModel.dart';
import 'package:laundry/services/dio.dart';
import 'package:flutter/material.dart';

class LSItemAPI extends ChangeNotifier {
  final storage = FlutterSecureStorage();

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
}
