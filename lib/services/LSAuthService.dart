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
      print(_user);
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



  void retrieveClient({String? userID, String? token}) async {
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

  void tryToken({String? token}) async {
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
        this.retrieveClient(userID: userID, token: token);
        this._token = token;
        this.storeToken(token: token);
        notifyListeners();

        print('Client: $_client');
        print('User: $_user');
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