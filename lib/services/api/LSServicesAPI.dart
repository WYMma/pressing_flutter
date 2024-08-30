import 'package:flutter/material.dart';
import 'package:laundry/model/LSServicesModel.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:laundry/services/dio.dart';

class LSServicesAPI extends ChangeNotifier {

  final storage = FlutterSecureStorage();

  Future<void> getAllServices() async {
    try {
      String? token = await storage.read(key: 'token');
      Dio.Response response = await dio().get('/services',
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      List<LSServicesModel> services = (response.data as List)
          .map((serviceJson) => LSServicesModel.fromJson(serviceJson))
          .toList();
      LSServicesModel.services = services;
      print('Services fetched: $services');
    } catch (e) {
      print('Error fetching services: $e');
      rethrow;
    }
  }
}