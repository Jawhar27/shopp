import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shopp/models/httpException.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer authtimer;

  bool get isAuth {
    return _token != null;
  }

  String get getUserId {
    return _userId;
  }

  String get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate.isAfter(DateTime.now())) {
      return _token;
    } else {
      return null;
    }
  }

  Future<void> authenticate(
      String email, String password, String urlType) async {
    try {
      final url =
          "https://identitytoolkit.googleapis.com/v1/accounts:$urlType?key=AIzaSyDAWDBuIdtASXwsC9W-ObOl4smHtqy3NMs";

      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(message: responseData['error']['message']);
      }
      _userId = responseData['localId'];
      _token = responseData['idToken'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final authData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String()
      });
      prefs.setString('auth', authData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    return authenticate(email, password, "signUp");
  }

  Future<void> signIn(String email, String password) async {
    return authenticate(email, password, "signInWithPassword");
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (authtimer != null) {
      authtimer.cancel();
      authtimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void autoLogout() {
    if (authtimer != null) {
      authtimer.cancel();
    }
    final _timeDuration = _expiryDate.difference(DateTime.now()).inSeconds;
    Timer(Duration(seconds: _timeDuration), logout);
  }

  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('auth')) {
      //no auth user data
      return false;
    }
    final extractedData =
        json.decode(prefs.getString('auth')) as Map<String, Object>;
    final expiryDate = DateTime.parse(
        extractedData['expiryDate']); //converting to DateTime format

    if (expiryDate.isBefore(DateTime.now())) {
      //if token is expired
      return false;
    }
    _token = extractedData['token'];
    _userId = extractedData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    autoLogout(); // setting the time for auto logout
    return true;
  }
}
