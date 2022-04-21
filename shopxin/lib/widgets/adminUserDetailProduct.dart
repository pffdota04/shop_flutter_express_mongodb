import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:shop_app/models/HttpException.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/provider/productProvider.dart';

class AdminUserDetailProduct extends StatelessWidget {
  final Product e;
  AdminUserDetailProduct({required this.e});
  @override
  Widget build(BuildContext context) {
    openDialog(String title, String content) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Okay!'),
            ),
          ],
        ),
      );
    }

    return Card(
      child: Dismissible(
        key: Key(e.id),
        direction: DismissDirection.startToEnd,
        background: Container(
          padding: const EdgeInsets.only(left: 30),
          alignment: Alignment.centerLeft,
          child: Icon(Icons.delete),
          color: Colors.red,
        ),
        confirmDismiss: (direction) {
          return showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                'Are you sure?',
                style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black),
              ),
              content: Text(
                'Do you want to remove this item?',
                style: GoogleFonts.poppins(),
              ),
              elevation: 20,
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    'No',
                    style: GoogleFonts.poppins(
                        color: Theme.of(context).accentColor),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    try {
                      await Provider.of<ProductProvider>(context, listen: false)
                          .deleteItem(e.id);
                      Navigator.of(context).pop(true);
                      openDialog('Successful', 'Item deleted Successfully!');
                    } on HttpException catch (err) {
                      Navigator.of(context).pop(false);
                      openDialog('Error', err.msg);
                    }
                  },
                  child: Text('Yes',
                      style: GoogleFonts.poppins(
                          color: Theme.of(context).accentColor)),
                )
              ],
            ),
          );
        },
        child: ListTile(
          contentPadding: const EdgeInsets.all(4),
          leading: CachedNetworkImage(
            imageUrl: e.image,
            height: 60,
            width: 60,
          ),
          title: Text(
            e.name,
            style: GoogleFonts.poppins(),
          ),
        ),
      ),
    );
  }
}
