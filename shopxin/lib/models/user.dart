//@dart=2.9

import 'package:flutter/foundation.dart';
import 'package:shop_app/models/product.dart';

class User {
  final int role;
  final String firstname;
  final String lastname;
  final String email;
  final String id;
  final String address;
  final String phoneNo;
  final List<Product> favs;

  User({
    @required this.email,
    @required this.firstname,
    @required this.lastname,
    @required this.role,
    @required this.id,
    this.address,
    this.phoneNo,
    this.favs,
  });
}
