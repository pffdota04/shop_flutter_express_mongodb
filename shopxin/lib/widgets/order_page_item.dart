import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/models/product.dart';

class OrderPageItem extends StatelessWidget {
  const OrderPageItem({
    Key? key,
    required this.quantity,
    required this.product,
  }) : super(key: key);

  final int quantity;
  final Product product;

  @override
  Widget build(BuildContext context) {
    var productImage = Flexible(
      flex: 2,
      fit: FlexFit.tight,
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          child: CachedNetworkImage(
            imageUrl: product.image,
            height: 130,
          )),
    );
    var productInfo = Flexible(
      flex: 5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            product.name,
            maxLines: 2,
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '$quantity x ${product.price} = ₹${quantity * product.price}',
                style: GoogleFonts.raleway(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      height: 150,
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
            width: 1,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white54
                : Colors.black54,
          ),
        ),
      ),
      child: Row(
        children: [
          productImage,
          SizedBox(
            width: 10,
          ),
          productInfo,
        ],
      ),
    );
  }
}
