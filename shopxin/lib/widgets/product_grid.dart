import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/provider/productProvider.dart';
import 'package:shop_app/screens/mainPage.dart';
import 'package:shop_app/widgets/product_grid_item.dart';

class ProductGrid extends StatelessWidget {
  final ScreenSize size;
  final Size screenSize;
  final String category;
  final int sort;
  ProductGrid(this.size, this.screenSize, this.category, this.sort);
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ProductProvider>(context);
    List<Product> products =
        category == "" ? provider.products : provider.getByCategory(category);
    sort == -1
        // ignore: unnecessary_statements
        ? null
        : sort != 0
            ? products.sort((a, b) => a.price.compareTo(b.price))
            : products.sort((a, b) => b.price.compareTo(a.price));
    return CupertinoScrollbar(
      thickness: 4,
      radius: Radius.circular(20),
      child: StaggeredGridView.countBuilder(
        crossAxisCount: size == ScreenSize.small
            ? 2
            : size == ScreenSize.extraLarge
                ? 4
                : 3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ProductGridItem(
            product: products[index],
            screenSize: size,
          );
        },
        staggeredTileBuilder: (int i) => new StaggeredTile.fit(1),
      ),
    );
  }
}
