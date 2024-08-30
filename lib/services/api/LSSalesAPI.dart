import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:laundry/model/LSSalesModel.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:laundry/services/dio.dart';

class LSSalesAPI extends ChangeNotifier {

  final storage = FlutterSecureStorage();

  Future<void> getAllSales() async {
    try {
      String? token = await storage.read(key: 'token');
      Dio.Response response = await dio().get('/sales',
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      List<LSSalesModel> sales = [];
      (response.data as List).forEach((saleJson) {
        sales.insert(0, LSSalesModel.fromJson(saleJson));
      });
      LSSalesModel.sales = sales;
      print('Sales fetched: $sales');
    } catch (e) {
      print('Error fetching sales: $e');
      rethrow;
    }
  }
}