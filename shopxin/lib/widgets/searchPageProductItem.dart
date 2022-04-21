import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/screens/product_detail_screen.dart';

class SimpleProductInfo extends StatelessWidget {
  const SimpleProductInfo({
    Key? key,
    required this.product,
  }) : super(key: key);

  final List<Product> product;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1,
            ),
          ),
        ),
        child: ListTile(
          onTap: () => Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product[index].id),
          leading: Hero(
            tag: product[index].id,
            child: CachedNetworkImage(
              imageUrl: product[index].image,
              height: 60,
              width: 60,
            ),
          ),
          title: Hero(
            tag: '${product[index].id}-name',
            child: Text(product[index].name,
                style: GoogleFonts.poppins(fontSize: 14)),
          ),
        ),
      ),
      itemCount: product.length,
    );
  }
}
