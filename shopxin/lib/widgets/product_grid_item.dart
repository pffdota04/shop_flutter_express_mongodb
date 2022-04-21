import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/provider/cartProvider.dart';
import 'package:shop_app/provider/userProvider.dart';
import 'package:shop_app/screens/cartPage.dart';
import 'package:shop_app/screens/mainPage.dart';
import 'package:shop_app/screens/my_favorite_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';

class ProductGridItem extends StatefulWidget {
  const ProductGridItem({
    Key? key,
    required this.product,
    required this.screenSize,
  }) : super(key: key);

  final Product product;
  final ScreenSize screenSize;
  @override
  _ProductGridItemState createState() => _ProductGridItemState();
}

class _ProductGridItemState extends State<ProductGridItem> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          isHovering = true;
        });
      },
      onExit: (event) {
        setState(() {
          isHovering = false;
        });
      },
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
              arguments: widget.product.id);
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: isHovering
                ? Colors.grey.shade200
                : Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade800
                    : Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: isHovering ? 10 : 6,
                spreadRadius: isHovering ? 4 : 0,
                offset: Offset(0, 6),
                color: Colors.black38,
              )
            ],
            borderRadius: BorderRadius.circular(
                widget.screenSize == ScreenSize.small ||
                        widget.screenSize == ScreenSize.medium
                    ? 6
                    : 10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                        widget.screenSize == ScreenSize.small ||
                                widget.screenSize == ScreenSize.medium
                            ? 6
                            : 10),
                    child: Container(
                        padding:
                            const EdgeInsets.only(top: 8, left: 2, right: 2),
                        constraints: widget.screenSize == ScreenSize.small
                            ? BoxConstraints(
                                minWidth: 800, minHeight: 200, maxHeight: 200)
                            : BoxConstraints(
                                minWidth: 800, minHeight: 200, maxHeight: 600),
                        color: Colors.white,
                        child: Hero(
                          tag: widget.product.id,
                          child: CachedNetworkImage(
                            imageUrl: widget.product.image,
                            placeholder: (context, url) {
                              return LottieBuilder.asset(
                                "assets/images/loading.json",
                                height: 60,
                                width: 60,
                              );
                            },
                          ),
                        )),
                  ),
                  if (widget.screenSize != ScreenSize.small)
                    AnimatedPositioned(
                      duration: Duration(milliseconds: 300),
                      right: isHovering ? 0 : -100,
                      child: Container(
                        width: isHovering ? 100 : 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Provider.of<User>(context, listen: false)
                                    .toggleFavorite(widget.product);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Product added to favorite!'),
                                    action: SnackBarAction(
                                      label: 'Go to Favorite',
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushNamed(MyFavScreen.routeName);
                                      },
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                height: 50,
                                width: 40,
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Provider.of<Cart>(context, listen: false)
                                    .addItem(
                                        widget.product.id,
                                        widget.product.price,
                                        widget.product.name,
                                        widget.product.image);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Product added to cart!'),
                                    action: SnackBarAction(
                                      label: 'Go to Cart',
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushNamed(CartPage.routeName);
                                      },
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                height: 50,
                                width: 40,
                                child: Icon(
                                  Icons.add,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              Container(
                padding: widget.screenSize == ScreenSize.small
                    ? const EdgeInsets.only(left: 8, top: 4, right: 8)
                    : const EdgeInsets.only(left: 16, top: 4, right: 16),
                child: Hero(
                  tag: '${widget.product.id}-name',
                  child: Text(
                    widget.product.name,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(fontSize: 18),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Container(
                padding: widget.screenSize == ScreenSize.small
                    ? const EdgeInsets.only(left: 10, bottom: 8, right: 10)
                    : const EdgeInsets.only(left: 16, bottom: 8, right: 16),
                child: Text(
                  '₹ ${widget.product.price.toString()}',
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
