import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:laundry/model/LSAddressModel.dart';
import 'package:laundry/services/dio.dart';


class LSAddressAPI extends ChangeNotifier {
  final storage = FlutterSecureStorage();

  Future<void> getAddress(String? clientID) async {
    try {
      print('Fetching addresses for client: $clientID');
      String? token = await storage.read(key: 'token');
      Dio.Response response = await dio().get(
        '/addresses/$clientID',
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      // Check if response data is a list
      if (response.data is List) {
        List<dynamic> data = response.data;
        print('Fetched addresses: $data');
        // Convert JSON to LSAddressModel instances
        LSAddressModel.savedAddresses = data
            .map((json) => LSAddressModel.fromJson(json as Map<String, dynamic>))
            .toList();
        print('Fetched addresses: ${LSAddressModel.savedAddresses}');
      } else {
        print('Unexpected response data format');
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching addresses: $e');
    }
  }

  Future<void> addAddress({Map? addresse}) async{
    try {
      String? token = await storage.read(key: 'token');
      await dio().post(
        '/addresses',
        data: addresse,
        options: Dio.Options(headers: {'Authorization': 'Bearer $token'}),
      );
      await getAddress(addresse!['clientID']);
      notifyListeners();
    } on Exception catch (e) {
      print(e);
    }
  }
  Future<void> editAddress({Map? addresse, required String addressID, required String clientID}) async{
    try {
      String? token = await storage.read(key: 'token');
      await dio().put(
        '/addresses/$addressID',
        data: addresse,
        options: Dio.Options(headers: {'Authorization': 'Bearer $token'}),
      );
      await getAddress(clientID);
      notifyListeners();
    } on Exception catch (e) {
      print(e);
    }
  }
  Future<void> deleteAddress({required String addressID, required String clientID}) async{
    try {
      String? token = await storage.read(key: 'token');
      print('Deleting address with ID: $addressID');
      await dio().delete(
        '/addresses/$addressID',
        options: Dio.Options(headers: {'Authorization': 'Bearer $token'}),
      );
      print('Deleted address with ID: $addressID');
      await getAddress(clientID);
      notifyListeners();
    } on Exception catch (e) {
      print(e);
    }
  }
}
