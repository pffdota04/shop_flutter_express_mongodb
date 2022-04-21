import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/provider/productProvider.dart';
import 'package:shop_app/widgets/order_page_item.dart';

class OrderPageOrder extends StatelessWidget {
  final List<dynamic> _items;
  final List<dynamic> _q;
  final DateTime dateTime;
  final String id;
  OrderPageOrder(this._items, this._q, this.dateTime, this.id);
  @override
  Widget build(BuildContext context) {
    List<Product> products =
        Provider.of<ProductProvider>(context, listen: false)
            .getItemOfProduct(_items);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Card(
        elevation: 16,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order ID - #${id.toUpperCase()}',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                DateFormat.yMMMEd().format(dateTime),
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              ...products.map((e) {
                int index = _items.indexWhere((element) => element == e.id);
                int quantity = _q[index];
                return OrderPageItem(
                  quantity: quantity,
                  product: e,
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
