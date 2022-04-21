import 'dart:convert';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/HttpException.dart';

import 'package:shop_app/provider/secureStorage.dart';

class AuthProvider with ChangeNotifier {
  String _token = '';
  DateTime _expiryDate = DateTime.now();
  String _userId = '';
  // late Timer _authTimer;
  int _role = 1;
  bool _isDark = false;

  final SecureStroage secureStroage = SecureStroage();

  bool get isAuth {
    return token != '';
  }

  String get token {
    if (_expiryDate != DateTime.now() &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != '') {
      return _token;
    }
    return '';
  }

  String get userId {
    return _userId;
  }

  int get role {
    return _role;
  }

  bool get isDark {
    return _isDark;
  }

  toggleDark() {
    _isDark = !_isDark;

    secureStroage.writeSecureStorage('isDark', isDark.toString());
    notifyListeners();
  }

  Future<void> authenticate(String urlpath, Object data) async {
    final Uri url =
        Uri.http("fluttershop-backend.herokuapp.com", 'user/$urlpath');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: data,
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']);
      }
      _token = responseData['token'];
      _userId = responseData['userId'];
      _role = responseData['role'];
      _expiryDate = DateTime.now().add(
        Duration(
          hours: responseData['expiresIn'],
        ),
      );

      secureStroage.writeSecureStorage('token', _token);
      secureStroage.writeSecureStorage('userId', _userId);
      secureStroage.writeSecureStorage('role', _role.toString());
      secureStroage.writeSecureStorage('expiry', _expiryDate.toIso8601String());
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password, String fname, String lname,
      int role) async {
    final data = json.encode(
      {
        'email': email,
        'password': password,
        'firstname': fname,
        'lastname': lname,
        'role': role,
      },
    );

    return authenticate('signup', data);
  }

  Future<void> login(String email, String password) async {
    final data = json.encode({'email': email, 'password': password});
    return authenticate('login', data);
  }

  Future<bool> tryAutoLogin() async {
    Map<String, String> data = await secureStroage.realStorage();
    _userId = data['userId']!;
    _token = data['token']!;
    _role = int.parse(data['role']!);
    _expiryDate = DateTime.parse(data['expiry']!);
    _isDark = data['isDark'] == "true" ? true : false;

    notifyListeners();

    return true;
  }

  void logout() async {
    _expiryDate = DateTime.now();
    _role = -1;
    _token = "";
    _userId = "";
    _isDark = false;
    notifyListeners();
    secureStroage.deleteStorage();
  }
}
