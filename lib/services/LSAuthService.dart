import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:laundry/model/user.dart';
import 'package:laundry/services/dio.dart';
import 'package:laundry/model/client.dart';

class LSAuthService extends ChangeNotifier {
  bool _isLoggedIn = false;
  User? _user;
  Client? _client;
  String? _token;

  bool get authenticated => _isLoggedIn;
  User? get user => _user;
  Client? get client => _client;

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
      Dio.Response response1 = await dio().post('/CreateUser', data: creds);
      final user = response1.data['user'];
      final client = response1.data['client'];
      this._client = Client.fromJson(client);
      this._user = User.fromJson(user);
      this._isLoggedIn = true;
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
        this._user = User.fromJson(response.data);

        // Ensure the userID is treated as a string
        String userID = response.data['id'].toString();
        this.retrieveClient(userID: userID, token: token);

        notifyListeners();

        print('Client: $_client');
        print('User: $_user');
      } catch (e) {
        print(e);
      }
    }
  }


  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}