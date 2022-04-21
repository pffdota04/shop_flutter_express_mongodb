import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/provider/authProvider.dart';
import 'package:shop_app/provider/productProvider.dart';
import 'package:shop_app/screens/mainPage.dart';
import 'package:shop_app/widgets/product_grid_item.dart';

class MyProduct extends StatelessWidget {
  static const routeName = 'my-products';

  @override
  Widget build(BuildContext context) {
    final String user =
        Provider.of<AuthProvider>(context, listen: false).userId;
    List<Product> _p = Provider.of<ProductProvider>(context).findBySeller(user);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Products',
          style: Theme.of(context).textTheme.headline6!.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? null
                    : Colors.white,
              ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LayoutBuilder(builder: (context, constraints) {
          ScreenSize screenSize = constraints.maxWidth < 960
              ? ScreenSize.small
              : constraints.maxWidth < 1200
                  ? ScreenSize.medium
                  : constraints.maxWidth < 1920
                      ? ScreenSize.large
                      : ScreenSize.extraLarge;
          return StaggeredGridView.countBuilder(
            crossAxisCount: screenSize == ScreenSize.small
                ? 2
                : screenSize == ScreenSize.extraLarge
                    ? 4
                    : 3,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _p.length,
            itemBuilder: (context, index) {
              return ProductGridItem(
                product: _p[index],
                screenSize: screenSize,
              );
            },
            staggeredTileBuilder: (int i) => new StaggeredTile.fit(1),
          );
        }),
      ),
    );
  }
}
