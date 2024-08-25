import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:laundry/main.dart';
import 'package:laundry/model/user.dart';
import 'package:laundry/services/dio.dart';
import 'package:laundry/model/client.dart';

class LSAuthService extends ChangeNotifier {
  bool _isLoggedIn = appStore.isSignedIn;
  User? _user;
  Client? _client;
  String? _token;

  bool get authenticated => _isLoggedIn;
  User? get user => _user;
  Client? get client => _client;

  final storage = FlutterSecureStorage();

  Future<void> login({Map? creds}) async{
    try {
      Dio.Response response = await dio().post('/sanctum/token', data: creds);
      print(response.data.toString());
      _token = response.data.toString();
      this.tryToken(token: _token);
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
        'device_name': creds['device_name']
      };
      this.login(creds: credsSignin);
      notifyListeners();
    } on Exception catch (e) {
      print(e);
    }
  }


  Future<void> updateClient({String? clientID, Map? creds}) async {
    try {
      String? token = await storage.read(key: 'token');
        Dio.Response response = await dio().put('/client/$clientID', data: creds, options: Dio.Options(headers: {'Authorization' : 'Bearer $token'}));
        this._client = Client.fromJson(response.data);
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
        this._client = Client.fromJson(response.data);
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

        this._isLoggedIn = true;
        appStore.toggleSignInStatus(value: _isLoggedIn);
        this._user = User.fromJson(response.data);

        // Ensure the userID is treated as a string
        String userID = response.data['id'].toString();
        await this.retrieveClient(userID: userID, token: token);
        this._token = token;
        this.storeToken(token: token);
        print(_user);
        print(_client);
        notifyListeners();
      } catch (e) {
        print(e);
      }
    }
  }


  void storeToken({String? token}) async {
    this.storage.write(key: 'token', value: token);
  }

  Future<void> logout() async {
    try {
      await dio().get('/user/revoke',
          options: Dio.Options(headers: {'Authorization' : 'Bearer $_token'}));
      cleanUp();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void cleanUp() async {
    this._user = null;
    this._client = null;
    this._isLoggedIn = false;
    appStore.isSignedIn = this._isLoggedIn;
    this._token = null;
    await storage.delete(key: 'token');
  }
}