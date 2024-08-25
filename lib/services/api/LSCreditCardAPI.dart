import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:laundry/components/LSCreditCardComponent.dart';
import 'package:laundry/services/dio.dart';


class LSCreditCardAPI extends ChangeNotifier {
  final storage = FlutterSecureStorage();

  Future<void> getCreditCard(String? clientID) async {
    try {
      print('Fetching cards for client: $clientID');
      String? token = await storage.read(key: 'token');
      Dio.Response response = await dio().get(
        '/credit-cards/$clientID',
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      // Check if response data is a list
      if (response.data is List) {
        List<dynamic> data = response.data;
        print('Fetched cards: $data');

        // Clear existing saved payment methods
        LSCreditCardComponent.savedPaymentMethods.clear();

        // Convert JSON to Map<String, String> and add to savedPaymentMethods
        LSCreditCardComponent.savedPaymentMethods = data.map((json) {
          // Ensure each field is treated as String and handle null values
          return {
            'cardID': json['cardID']?.toString() ?? '', // Default to empty string if null
            'number': json['number']?.toString() ?? '', // Default to empty string if null
            'holder': json['holder']?.toString() ?? '', // Default to empty string if null
            'expiry': json['expiry']?.toString() ?? '', // Default to empty string if null
            'cvv': json['cvv']?.toString() ?? '', // Default to empty string if null
          };
        }).toList();

        print('Saved payment methods: ${LSCreditCardComponent.savedPaymentMethods}');
      } else {
        print('Unexpected response data format');
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching credit cards: $e');
    }
  }

  Future<void> addCreditCard({Map? creditCard}) async{
    try {
      String? token = await storage.read(key: 'token');
      await dio().post(
        '/credit-cards',
        data: creditCard,
        options: Dio.Options(headers: {'Authorization': 'Bearer $token'}),
      );
      await getCreditCard(creditCard!['clientID']);
      notifyListeners();
    } on Exception catch (e) {
      print(e);
    }
  }
  Future<void> editCreditCard({Map? creditCard, required String cardID, required String clientID}) async{
    try {
      String? token = await storage.read(key: 'token');
      await dio().put(
        '/credit-cards/$cardID',
        data: creditCard,
        options: Dio.Options(headers: {'Authorization': 'Bearer $token'}),
      );
      await getCreditCard(clientID);
      notifyListeners();
    } on Exception catch (e) {
      print(e);
    }
  }
  Future<void> deleteCreditCard({required String cardID, required String clientID}) async{
    try {
      String? token = await storage.read(key: 'token');
      print('Deleting card with ID: $cardID');
      await dio().delete(
        '/credit-cards/$cardID',
        options: Dio.Options(headers: {'Authorization': 'Bearer $token'}),
      );
      print('Deleted card with ID: $cardID');
      await getCreditCard(clientID);
      notifyListeners();
    } on Exception catch (e) {
      print(e);
    }
  }
}
