import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
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
  String _id;
  String _consulId;
  String _docId;
  bool consulStatus;
  bool consulApproval;
  bool consulRejection;
  int _consolStatusCode = 0;

  String _patientID;

  bool get isAuth {
    return token != null;
  }

  String get id {
    return _id;
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

  String get getDocID {
    return _docId;
  }

  String get entryLevel {
    return _entryLevel;
  }

  int get consulstatusget {
    return _consolStatusCode;
  }

  Future<void> addDocID(String id) {
    _docId = id;
  }

  Future<void> _pushNotifications() {
    final FirebaseMessaging _messaging = FirebaseMessaging();
    _messaging.getToken().then((token) {
      sendReg(token);
    });
  }

  Future<void> sendReg(String deviceId) async {
    String url = 'http://fitknees.herokuapp.com/auth/notify/';
    try {
      final response = await http.post(
        url,
        headers: {'Authorization': _token},
        body: {'device_id': deviceId},
      );
      if (response.statusCode == 204) {
        notifyListeners();
      } else {
        throw HttpException('Unable to login.');
      }
    } on HttpException catch (e) {
    }
  }

  Future<void> startConsult() async {
    String url = 'https://fitknees.herokuapp.com/auth/consult/';
    try {
      final response = await http.post(url, headers: {
        'Authorization': _token
      }, body: {
        'docId': _docId,
      });
      final responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        _consulId = responseBody['consul_id'];
        consulStatus = responseBody['case_closed'];
        consulApproval = responseBody['doc_approval'];
        notifyListeners();
      } else {
        throw HttpException('No Cash in your wallet');
      }
    } on HttpException catch (e) {
      throw e;
    }
  }

  Future<void> getConsol() async {
    String url = 'https://fitknees.herokuapp.com/auth/consult/';
    try {
      final response = await http.get(url, headers: {'Authorization': _token});
      final responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        if (responseBody.length != 0) {
          consulRejection = responseBody[0]['doc_rejection'];
          if (consulRejection == true) {
            _consolStatusCode = 1;
          } else {
            consulApproval = responseBody[0]['doc_approval'];

            if (consulApproval == true) {
              _consolStatusCode = 3;
              _consulId = responseBody[0]['consul_id'];
              _patientID = responseBody[0]['pat_id'];
            } else {
              _consolStatusCode = 2;
            }
          }
        } else {
          _consolStatusCode = 1;
        }

        notifyListeners();
      } else {
        throw HttpException('Error retrieving consultation');
      }
    } on HttpException catch (e) {
      throw e;
    }
  }

  Future<void> makeVideoCall(docId, patientId) async {
    String url = 'https://fitknees.herokuapp.com/auth/patient/vcall/';

    try {
      final response = await http.post(url, headers: {
        'Authorization': _token,
      }, body: {
        'doctor': docId,
        'patient': patientId,
      });
      final responseBody = json.decode(response.body);
    } catch (e) {
      throw HttpException('Unable to log in with provided credentials.');
    }
  }

  Future<void> login(String username, String password) async {
    String url = 'https://fitknees.herokuapp.com/auth/token/login/';

    try {
      final response = await http.post(url, body: {
        'username': username,
        'password': password,
      });
      final responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        _userType = responseBody['userInfo']['userType'];
        _token = 'Token ' + responseBody['token']['auth_token'];
        _username = responseBody['username'];
        _name = responseBody['name'];
        _id = responseBody['userInfo']['id'];
        _entryLevel = responseBody['userInfo']['entryLevel'];
        final prefs = await SharedPreferences.getInstance();
        final data = json.encode({
          'token': _token,
          'userType': _userType,
          'username': _username,
          'name': _name,
          'id': _id,
          'entryLevel': _entryLevel,
        });
        prefs.setString('userData', data);
        _pushNotifications();
        notifyListeners();
      } else {
        final prefs = await SharedPreferences.getInstance();
        prefs.clear();
        _token = null;
        _userType = null;
        _username = null;
        _name = null;
        _id = null;
        throw HttpException('Unable to log in with provided credentials.');
      }
    } on HttpException catch (e) {
      final prefs = await SharedPreferences.getInstance();
      prefs.clear();
      _token = null;
      _userType = null;
      _username = null;
      _name = null;
      _id = null;
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
    _token = extractedUserData['token'];
    _userType = extractedUserData['userType'];
    _username = extractedUserData['username'];
    _name = extractedUserData['name'];
    _id = extractedUserData['id'];
    _entryLevel = extractedUserData['entryLevel'];
    notifyListeners();
    return true;
  }

  Future<void> changePass(
      String currentPass, String newPass, String newConfirmPass) async {
    String url = 'https://fitknees.herokuapp.com/auth/users/set_password/';
    try {
      final response = await http.post(url, headers: {
        'Authorization': _token
      }, body: {
        'current_password': currentPass,
        'new_password': newPass,
      });
      if (response.statusCode == 204) {
        notifyListeners();
      } else {
        throw HttpException(
            'Unable to change password with provided credentials.');
      }
    } on HttpException catch (e) {
      throw e;
    }
  }

  Future<void> changeEntryLevel() async {
    _entryLevel = 'Not First';
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    final data = json.encode({
      'token': _token,
      'userType': _userType,
      'username': _username,
      'name': _name,
      'id': _id,
      'entryLevel': _entryLevel,
    });
    prefs.setString('userData', data);
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _token = null;
    _userType = null;
    _username = null;
    _name = null;
    _id = null;
    notifyListeners();
  }
}
