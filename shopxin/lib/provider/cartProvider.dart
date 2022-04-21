import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shop_app/models/HttpException.dart';
import 'package:shop_app/models/cart.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/order.dart';

class Cart with ChangeNotifier {
  final String _userId;
  final String _token;
  Map<String, CartItem> _items = {};
  List<String> _ps = [];
  List<int> _q = [];
  List<Order> _orders = [];

  Cart(this._userId, this._token);

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  int get total {
    int total = 0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  List<Order> get orders {
    return List.from(_orders.reversed);
  }

  Future<void> getOrder(String userId) async {
    final Uri url = Uri.http("fluttershop-backend.herokuapp.com", 'orders');
    var response = await http
        .get(url, headers: {'Authorization': 'Bearer $_token', 'user': userId});
    var responseData = json.decode(response.body);
    var orders = responseData['orders'];
    int count = responseData['count'];
    List<Order> o = [];
    for (int i = 0; i < count; i++) {
      var x = orders[i];
      o.add(
        new Order(
            id: x['id'],
            dateTime: DateTime.parse(x['date']),
            q: x['quantity'],
            pIds: x['products']),
      );
    }
    _orders = o;
    notifyListeners();
  }

  Future<void> placeOrder() async {
    final Uri url = Uri.http("fluttershop-backend.herokuapp.com", 'orders');
    try {
      var response = await http.post(url,
          body: json.encode(
            {
              "user": _userId,
              'date': DateTime.now().toIso8601String(),
              'products': _ps,
              'quantity': _q
            },
          ),
          headers: {
            'Authorization': 'Bearer $_token',
            'Content-Type': 'application/json'
          });
      var responsedata = json.decode(response.body);
      if (responsedata['error'] != null) {
        throw HttpException(responsedata['error']);
      }
    } catch (err) {
      throw err;
    }
  }

  void addItem(String pId, int price, String title, String image) {
    if (_items.containsKey(pId)) {
      _items.update(
        pId,
        (value) => CartItem(
            id: value.id,
            price: value.price,
            image: value.image,
            quantity: value.quantity + 1,
            title: value.title),
      );
      var index = _ps.indexWhere((element) => element == pId);
      _q[index] += 1;
    } else {
      _items.putIfAbsent(
        pId,
        () => CartItem(
          id: pId,
          price: price,
          image: image,
          quantity: 1,
          title: title,
        ),
      );
      _ps.add(pId);
      _q.add(1);
    }
    notifyListeners();
  }

  void remove(String id) {
    _items.remove(id);
    var index = _ps.indexWhere((element) => element == id);
    _ps.removeAt(index);
    _q.removeAt(index);
    notifyListeners();
  }

  void removeSingleItem(String id) {
    if (!_items.containsKey(id)) return;
    if (_items[id]!.quantity > 1) {
      _items.update(
        id,
        (value) => CartItem(
          id: value.id,
          price: value.price,
          image: value.image,
          quantity: value.quantity - 1,
          title: value.title,
        ),
      );
      var index = _ps.indexWhere((element) => element == id);
      _q[index] -= 1;
    } else {
      remove(id);
    }
    notifyListeners();
  }
}
