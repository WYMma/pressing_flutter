import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:laundry/main.dart';
import 'package:laundry/model/APIKey.dart';
import 'package:laundry/model/transporteur.dart';
import 'package:laundry/model/user.dart';
import 'package:laundry/services/dio.dart';
import 'package:laundry/model/client.dart';

class LSAuthService extends ChangeNotifier {
  bool _isLoggedIn = appStore.isSignedIn;
  User? _user;
  Client? _client;
  Transporteur? _transporteur;
  String? _token;

  bool get authenticated => _isLoggedIn;
  User? get user => _user;
  Client? get client => _client;
  Transporteur? get transporteur => _transporteur;

  final storage = FlutterSecureStorage();

  Future<void> login({Map? creds}) async{
    try {
      Dio.Response response = await dio().post('/sanctum/token', data: creds);
      print(response.data.toString());
      _token = response.data.toString();
      await tryToken(token: _token);
      notifyListeners();

    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> register({Map? creds}) async {
    try {
      await dio().post('/CreateUser', data: creds);
      Map credsSignin = {
        'phone': creds!['phone'],
        'password': creds['password'],
        'device_name': creds['device_name'],
        'tokenFCM': creds['tokenFCM'],
      };
      login(creds: credsSignin);
      notifyListeners();
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> updateClient({String? clientID, Map? creds}) async {
    try {
      String? token = await storage.read(key: 'token');
        Dio.Response response = await dio().put('/client/$clientID', data: creds, options: Dio.Options(headers: {'Authorization' : 'Bearer $token'}));
        _client = Client.fromJson(response.data);
        notifyListeners();
      } catch (e) {
        print(e);
      }
  }

  Future<void> updateTransporteur({String? personnelID, Map? creds}) async {
    try {
      String? token = await storage.read(key: 'token');
        Dio.Response response = await dio().put('/personnel/$personnelID', data: creds, options: Dio.Options(headers: {'Authorization' : 'Bearer $token'}));
        _transporteur = Transporteur.fromJson(response.data);
        notifyListeners();
      } catch (e) {
        print(e);
      }
  }

  Future<int?> changePassword(String currentPassword, String newPassword) async {
    String? token = await storage.read(key: 'token');

    try {
      Dio.Response response = await dio().post(
        '/change-password',
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
        },
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) {
            return status != null && status >= 200 && status < 500; // Handle any status code less than 500
          },
        ),
      );
      return response.statusCode;
    } catch (e) {
      print('Failed to update password: $e');
      return null; // Return null or an error code to handle in your Flutter app
    }
  }

  Future<void> retrieveClient({String? userID, String? token}) async {
    if (token == null) {
      return;
    } else {
      try {
        Dio.Response response = await dio().get('/client/$userID',  options: Dio.Options(headers: {'Authorization' : 'Bearer $token'}));
        _client = Client.fromJson(response.data);
        notifyListeners();
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> retrievePersonnels({String? userID, String? token}) async {
    if (token == null) {
      return;
    } else {
      try {
        Dio.Response response = await dio().get('/personnel/$userID',  options: Dio.Options(headers: {'Authorization' : 'Bearer $token'}));
        _transporteur = Transporteur.fromJson(response.data);
        notifyListeners();
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> tryToken({String? token}) async {
    if (token == null) {
      return;
    } else {
      try {
        Dio.Response response = await dio().get('/user',
            options: Dio.Options(headers: {'Authorization' : 'Bearer $token'}));

        _isLoggedIn = true;
        appStore.toggleSignInStatus(value: _isLoggedIn);
        _user = User.fromJson(response.data);

        // Ensure the userID is treated as a string
        String userID = response.data['id'].toString();
        String role = response.data['role'];
        if (role == 'Client') {
          await retrieveClient(userID: userID, token: token);
          print(_user);
          print(_client);
        } else if (role == 'Transporteur') {
          await retrievePersonnels(userID: userID, token: token);
          print(_user);
          print(_transporteur);
        }
        _token = token;
        storeToken(token: token);
        notifyListeners();
      } catch (e) {
        print(e);
      }
    }
  }


  void storeToken({String? token}) async {
    storage.write(key: 'token', value: token);
    storage.write(key: 'role', value: _user?.role);
  }

  Future<void> logout() async {
    try {
      await dio().get('/user/revoke',
          options: Dio.Options(headers: {'Authorization' : 'Bearer $_token'}));
      cleanUp();
      appStore.toggleSignInStatus(value: false);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void cleanUp() async {
    _user = null;
    _client = null;
    _isLoggedIn = false;
    appStore.isSignedIn = _isLoggedIn;
    _token = null;
    await storage.delete(key: 'token');
    await storage.delete(key: 'role');
  }

  Future<void> retrieveApiKeys() async {
    try {
      String? token = await storage.read(key: 'token');
      if (token == null) {
        print('No token found, unable to retrieve API keys.');
        return;
      }

      Dio.Response response = await dio().get(
        '/api-keys',  // Assuming this is the endpoint to retrieve API keys
        options: Dio.Options(headers: {'Authorization': 'Bearer $token'}),
      );

      // Clear the existing list
      APIKey.apiKeyList.clear();

      // Populate the static list with the retrieved API keys
      List<dynamic> apiKeysJson = response.data;
      for (var apiKeyJson in apiKeysJson) {
        APIKey apiKey = APIKey.fromJson(apiKeyJson);
        APIKey.addApiKey(apiKey);
      }

      print('API keys successfully retrieved and stored.');
      print(APIKey.apiKeyList);
      notifyListeners();
    } catch (e) {
      print('Failed to retrieve API keys: $e');
    }
  }
}