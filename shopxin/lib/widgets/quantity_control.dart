import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/models/cart.dart';
import 'package:shop_app/provider/cartProvider.dart';

class QuantityControl extends StatelessWidget {
  const QuantityControl({
    Key? key,
    required this.cartItem,
  }) : super(key: key);

  final CartItem cartItem;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: () {
            Provider.of<Cart>(context, listen: false)
                .removeSingleItem(cartItem.id);
          },
          child: Card(
            child: Container(
              width: 30,
              padding: const EdgeInsets.all(4.0),
              child: Text('-',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
            ),
          ),
        ),
        Text('Qty: ${cartItem.quantity}'),
        InkWell(
          onTap: () {
            Provider.of<Cart>(context, listen: false).addItem(
                cartItem.id, cartItem.price, cartItem.title, cartItem.image);
          },
          child: Card(
            child: Container(
              width: 30,
              padding: const EdgeInsets.all(4.0),
              child: Text(
                '+',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
