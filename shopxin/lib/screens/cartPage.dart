import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/provider/cartProvider.dart';
import 'package:shop_app/screens/order_detail_screen.dart';
import 'package:shop_app/widgets/cart_item.dart';
import 'package:shop_app/widgets/cart_total.dart';

class CartPage extends StatelessWidget {
  static const routeName = "/cart-page";

  @override
  Widget build(BuildContext context) {
    var list = Provider.of<Cart>(context).items;
    var cartItems = list.values.toList();
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cart',
          style: Theme.of(context).textTheme.headline6!.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? null
                    : Colors.white,
              ),
        ),
      ),
      body: Container(
        height: size.height,
        // width: double.infinity,
        alignment: Alignment.topCenter,
        child: Container(
          constraints: BoxConstraints(maxWidth: 960),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ...cartItems.map((cartItem) => GenCartItem(cartItem)).toList(),
                if (cartItems.length > 0) GenTotalDetail(),
                if (cartItems.length == 0)
                  Container(
                    height: size.height - 100,
                    width: size.width,
                    child: Center(
                      child: Text(
                        'Cart is Empty!',
                        style: GoogleFonts.poppins(fontSize: 28),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: cartItems.length == 0
          ? null
          : ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed(OrderDetailPage.routeName);
              },
              icon: Icon(Icons.shopping_cart_outlined),
              label: Container(
                child: Center(
                  child: Text(
                    'Place Order!',
                    style: GoogleFonts.poppins(),
                  ),
                ),
                height: 60,
              ),
            ),
    );
  }
}
