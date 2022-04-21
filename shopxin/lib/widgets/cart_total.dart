import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cartProvider.dart';

enum Type {
  Price,
  Discount,
  Total,
}

class GenTotalDetail extends StatelessWidget {
  const GenTotalDetail({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<Cart>(context);
    var total = provider.total;
    var itemCount = provider.itemCount;

    var countAndPrice = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Price ($itemCount item)',
            style: GoogleFonts.poppins(),
          ),
          Text(
            '$total',
            style: GoogleFonts.poppins(),
          )
        ],
      ),
    );
    var deliveryCharges = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Delivery Charges',
            style: GoogleFonts.poppins(),
          ),
          Text(
            'FREE',
            style: GoogleFonts.poppins(),
          )
        ],
      ),
    );
    var totalAmount = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total Amount',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          Text(
            '$total',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'PRICE DETAILS',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white54
                        : Colors.black45,
                  ),
                ),
              ),
              Divider(
                thickness: 1.5,
              ),
              countAndPrice,
              deliveryCharges,
              Divider(
                thickness: 1.5,
              ),
              totalAmount,
            ],
          ),
        ),
      ),
    );
  }
}
