import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/models/product.dart';
import 'package:shop_app/provider/cartProvider.dart';
import 'package:shop_app/provider/productProvider.dart';
import 'package:shop_app/provider/userProvider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shop_app/screens/add_product_screen.dart';
import 'package:shop_app/screens/cartPage.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    var isFav = Provider.of<User>(context).isFav(productId);
    var userId = Provider.of<User>(context).userId;

    final loadedProduct = Provider.of<ProductProvider>(
      context,
      listen: false,
    ).findById(productId);
    List<String> _des = loadedProduct.description.split("  ");
    List<Widget> des = _des.map((element) {
      return element.trim() == ""
          ? SizedBox()
          : Text(
              "\u2022  $element",
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.subtitle2,
            );
    }).toList();

    var image = Stack(
      children: [
        Container(
          constraints: BoxConstraints(
              minHeight: 200,
              maxHeight: 500,
              // minWidth: ,
              maxWidth: 400),
          decoration: BoxDecoration(
              border: Border.all(width: 1),
              color: Colors.white,
              borderRadius: BorderRadius.circular(20)),
          child: Center(
            child: Hero(
              tag: productId,
              child: CachedNetworkImage(
                imageUrl: loadedProduct.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned(
          right: 10,
          top: 10,
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black87
                    : Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    offset: Offset(4, 4),
                    color: Colors.black38,
                  )
                ]),
            child: IconButton(
              icon: Icon(
                Icons.favorite,
                color: isFav ? Colors.red : null,
              ),
              onPressed: () {
                Provider.of<User>(context, listen: false)
                    .toggleFavorite(loadedProduct);
              },
            ),
          ),
        )
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FlutterStore',
          style: Theme.of(context).textTheme.headline6!.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? null
                  : Colors.white),
        ),
        actions: [
          if (userId == loadedProduct.sellerId)
            IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(
                      AddProductScreen.routeName,
                      arguments: loadedProduct.id);
                }),
        ],
      ),
      body: Container(
        // constraints: BoxConstraints(maxWidth: 1000),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return constraints.maxWidth > 960
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: image,
                      ),
                      Expanded(
                        child: Container(
                            padding: const EdgeInsets.all(40),
                            child: productDetail(
                                image, loadedProduct, des, false)),
                      ),
                    ],
                  )
                : productDetail(image, loadedProduct, des, true);
          },
        ),
      ),
      bottomNavigationBar: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.orange),
              ),
              onPressed: () {
                Provider.of<Cart>(context, listen: false).addItem(
                  loadedProduct.id,
                  loadedProduct.price,
                  loadedProduct.name,
                  loadedProduct.image,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Product added to cart!'),
                    action: SnackBarAction(
                      label: 'Go to Cart',
                      onPressed: () {
                        Navigator.of(context).pushNamed(CartPage.routeName);
                      },
                    ),
                  ),
                );
              },
              child: Container(
                height: 60,
                child: Center(child: Text('Add to cart')),
              ),
            ),
          ),
          Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green),
              ),
              onPressed: () {
                Provider.of<Cart>(context, listen: false).addItem(
                  loadedProduct.id,
                  loadedProduct.price,
                  loadedProduct.name,
                  loadedProduct.image,
                );
                Navigator.of(context).pushNamed(CartPage.routeName);
              },
              child: Container(
                height: 60,
                child: Center(child: Text('Buy')),
              ),
            ),
          ),
        ],
      ),
    );
  }

  SingleChildScrollView productDetail(
      Stack image, Product loadedProduct, List<Widget> des, bool disIamge) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (disIamge) Center(child: image),
          SizedBox(
            height: 10,
          ),
          Text(
            loadedProduct.name,
            style:
                GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          Text('₹ ${loadedProduct.price}',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.bold)),
          Text('Seller - ${loadedProduct.sellerName}',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.blue)),
          SizedBox(
            height: 16,
          ),
          Text('Features',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.bold)),
          ...des,
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
