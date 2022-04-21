import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/models/product.dart';
import 'package:shop_app/provider/productProvider.dart';
import 'package:shop_app/widgets/searchPageProductItem.dart';

class SearchPage extends StatefulWidget {
  static const routeName = "/search";

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Product> product = [];
  @override
  void initState() {
    product = Provider.of<ProductProvider>(context, listen: false).products;
    super.initState();
  }

  search(String query) {
    if (query == "") {
      product = Provider.of<ProductProvider>(context, listen: false).products;
    } else {
      product = product.where((element) {
        return element.name.toLowerCase().startsWith(query) == true;
      }).toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search',
            hintStyle: GoogleFonts.poppins(color: Colors.white),
            border: InputBorder.none,
          ),
          cursorColor: Colors.white,
          onChanged: (value) {
            search(value);
          },
        ),
      ),
      body: SimpleProductInfo(product: product),
    );
  }
}
