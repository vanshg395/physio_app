import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  String _userType;
  String _username;
  String _name;
  String _entryLevel;

  bool get isAuth {
    return token != null;
  }

  String get token {
    return _token;
  }

  String get userType {
    return _userType;
  }

  String get username {
    return _username;
  }

  String get name {
    return _name;
  }

  String get entryLevel {
    return _entryLevel;
  }

  Future<void> login(String username, String password) async {
    String url = 'https://fitknees.herokuapp.com/auth/token/login/';

    try {
      final response = await http.post(url, body: {
        'username': username,
        'password': password,
      });
      final responseBody = json.decode(response.body);
      print(responseBody);
      if (response.statusCode == 200) {
        _userType = responseBody['userInfo']['userType'];
        _token = 'Token ' + responseBody['token']['auth_token'];
        _username = responseBody['username'];
        _name = responseBody['name'];
        _entryLevel = responseBody['userInfo']['entryLevel'];
        final prefs = await SharedPreferences.getInstance();
        final data = json.encode({
          'token': _token,
          'userType': _userType,
          'username': _username,
          'name': _name,
        });
        prefs.setString('userData', data);
        notifyListeners();
      } else {
        throw HttpException('Unable to log in with provided credentials.');
      }
    } on HttpException catch (e) {
      print(e);
      throw e;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    print('extractedUserData : ' + extractedUserData.toString());
    _token = extractedUserData['token'];
    _userType = extractedUserData['userType'];
    _username = extractedUserData['username'];
    _name = extractedUserData['name'];
    notifyListeners();
    return true;
  }

  // Future<void> logout() async {
  //   print(1);
  //   String url = 'https://fitknees.herokuapp.com/auth/token/login/';
  //   final response = await http.get(url, headers: {'Authorization': _token});
  //   print(response.statusCode);
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.clear();
  //   _token = null;
  //   _userType = null;
  //   _username = null;
  //   _name = null;
  //   notifyListeners();
  // }
}
