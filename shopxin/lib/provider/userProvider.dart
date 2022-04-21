import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/HttpException.dart';
import 'package:shop_app/models/product.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shop_app/models/user.dart' as user;

class User with ChangeNotifier {
  String _token = '';
  String _userId = '';
  int _role = 1;
  List<user.User> users = [];
  List<Product> _fav = [];
  var _currUser = {
    'email': '',
    'firstname': '',
    'lastname': '',
    'address': '',
    'phone': '',
  };

  User(this._token, this._userId, this._role);

  String get userId {
    return _userId;
  }

  String get token {
    return _token;
  }

  int get role {
    return _role;
  }

  List<Product> get favs {
    return _fav;
  }

  Map<String, String> get currUser {
    return _currUser;
  }

  Future getUsers() async {
    final Uri url = Uri.http("fluttershop-backend.herokuapp.com", 'user');
    var response =
        await http.get(url, headers: {"Authorization": "Bearer $_token"});
    var responseData = json.decode(response.body);
    var data = responseData['users'] as List<dynamic>;

    List<user.User> temp = [];
    data.forEach(
      (element) {
        temp.add(
          new user.User(
              email: element['email'],
              firstname: element['firstname'],
              lastname: element['lastname'],
              role: element['role'],
              id: element['_id'],
              phoneNo: element['phone'],
              address: element['address']),
        );
      },
    );
    users = temp;
    return users;
  }

  user.User findById(String id) {
    return users.firstWhere((element) => element.id == id);
  }

  Future<void> toggleFavFromDB(String route, String pid) async {
    Uri uri =
        Uri.parse("https://fluttershop-backend.herokuapp.com/user/$route/$pid");
    var response =
        await http.post(uri, headers: {"Authorization": "Bearer $_token"});
    print(response.body);
  }

  void toggleFavorite(Product product) {
    int index = _fav.indexWhere((element) => element.id == product.id);
    if (index == -1) {
      _fav.add(product);
      toggleFavFromDB('add', product.id);
    } else {
      _fav.removeAt(index);
      toggleFavFromDB('remove', product.id);
    }
    print(_fav.length);
    notifyListeners();
  }

  bool isFav(String id) {
    return _fav.indexWhere((element) => element.id == id) != -1;
  }

  Future<void> getMyDetail() async {
    Uri uri =
        Uri.parse("https://fluttershop-backend.herokuapp.com/user/$_userId");
    try {
      var response =
          await http.get(uri, headers: {'Authorization': "Bearer $_token"});
      var rd = json.decode(response.body);
      if (rd['error'] != null) {
        throw HttpException(rd['error']);
      }
      var responseData = rd['user'];
      // print(responseData);
      _currUser['email'] = responseData['email'];
      _currUser['firstname'] = responseData['firstname'];
      _currUser['lastname'] = responseData['lastname'];
      _currUser['address'] = responseData['address'];
      _currUser['phone'] = responseData['phone'];
      var temp = responseData['favorite'] as List<dynamic>;
      List<Product> _tempfav = [];
      temp.forEach((p) {
        _tempfav.add(
          Product(
              id: p['_id'],
              name: p['name'],
              price: p['price'],
              description: p['description'],
              image: "https://fluttershop-backend.herokuapp.com/" +
                  p['productImage'],
              category: p['category'],
              sellerId: p['sellerId'],
              sellerName: p['seller']),
        );
      });
      _fav = _tempfav;
      notifyListeners();
    } catch (err) {
      print(err);
    }
  }

  Future<void> updateUser(Map<String, String> info) async {
    Uri url =
        Uri.parse("https://fluttershop-backend.herokuapp.com/user/update");
    var details = json.encode({
      "email": info['email'],
      "firstname": info["firstname"],
      "lastname": info["lastname"],
      "phone": info["phone"],
      "address": info["address"]
    });
    try {
      var response = await http.post(url, body: details, headers: {
        "Authorization": "Bearer $_token",
        "Content-Type": "application/json"
      });
      var responseData = json.decode(response.body);
      print(responseData);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']);
      }
      _currUser = {
        "email": info['email']!,
        "firstname": info["firstname"]!,
        "lastname": info["lastname"]!,
        "phone": info["phone"]!,
        "address": info["address"]!,
      };
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> deleteUser(String id) async {
    Uri url = Uri.parse("https://fluttershop-backend.herokuapp.com/user/$id");
    try {
      var response =
          await http.delete(url, headers: {"Authorization": "Bearer $_token"});
      var responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']);
      }
      users.removeWhere((element) => element.id == id);
      notifyListeners();
    } catch (err) {}
  }
}
