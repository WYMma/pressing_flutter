import 'package:dio/dio.dart';
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

  Future<LSServicesModel> addService(LSServicesModel service, {required MultipartFile imageFile}) async {
    try {
      String? token = await storage.read(key: 'token');
      FormData formData = FormData.fromMap({
        'name': service.name,
        'description': service.description,
        'price': service.price,
        'image': imageFile, // Attach the file here
      });

      Dio.Response response = await dio().post(
        '/services',
        data: formData,
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return LSServicesModel.fromJson(response.data);
    } catch (e) {
      print('Error adding service: $e');
      rethrow;
    }
  }

  Future<LSServicesModel> updateService(LSServicesModel service, {MultipartFile? imageFile}) async {
    try {
      String? token = await storage.read(key: 'token');
      FormData formData = FormData.fromMap({
        'name': service.name,
        'description': service.description,
        'price': service.price,
        'image': imageFile, // Attach the file here, if provided
      });

      Dio.Response response = await dio().put(
        '/services/${service.serviceID}',
        data: formData,
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return LSServicesModel.fromJson(response.data);
    } catch (e) {
      print('Error updating service: $e');
      rethrow;
    }
  }

  Future<void> deleteService(int id) async {
    try {
      String? token = await storage.read(key: 'token');
      await dio().delete('/services/$id',
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } catch (e) {
      print('Error deleting service: $e');
      rethrow;
    }
  }
}