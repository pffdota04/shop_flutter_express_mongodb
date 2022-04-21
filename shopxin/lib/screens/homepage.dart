import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cartProvider.dart';
import 'package:shop_app/provider/userProvider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shop_app/screens/add_product_screen.dart';
import 'package:shop_app/screens/adminScreens/admin_page.dart';
import 'package:shop_app/screens/cartPage.dart';

import 'package:shop_app/screens/mainPage.dart';
import 'package:shop_app/screens/searchpage.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/custom_app_drawer.dart';
import 'package:shop_app/widgets/product_grid.dart';
import 'package:shop_app/provider/productProvider.dart';

class HomePage extends StatefulWidget {
  final ScreenSize size;
  final Size screenSize;
  final int role;
  HomePage(this.size, this.screenSize, this.role);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _isLoading = false;
  List<String> _categories = [
    "All",
    "Grocery",
    "Mobiles",
    "Fashion",
    "Electronics",
    "Home",
    "Appliances",
    "Beauty, Toy & More",
  ];
  int selected = 2;
  var sort = -1;
  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<ProductProvider>(context, listen: false)
        .getProducts()
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });
    Provider.of<User>(context, listen: false).getMyDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(Platform.operatingSystem);
    return Scaffold(
      appBar: _isLoading
          ? null
          : AppBar(
              title: Text(
                'FlutterStore',
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? null
                          : Colors.white,
                    ),
              ),
              centerTitle: widget.role == 1,
              actions: [
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    Navigator.of(context).pushNamed(SearchPage.routeName);
                  },
                ),
                Consumer<Cart>(
                  builder: (context, cart, child) {
                    return Badge(
                      child: child,
                      value: cart.itemCount.toString(),
                    );
                  },
                  child: IconButton(
                    icon: Icon(
                      Icons.shopping_cart,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(CartPage.routeName);
                    },
                  ),
                ),
                if (widget.role == 0)
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(AddProductScreen.routeName);
                    },
                  )
              ],
            ),
      drawer: CustomDrawer(widget.role),
      body: widget.role == 12101998
          ? AdminPage()
          : RefreshIndicator(
              onRefresh: () {
                return Provider.of<ProductProvider>(context, listen: false)
                    .getProducts();
              },
              child: HawkFabMenu(
                fabColor: Theme.of(context).accentColor,
                body: Container(
                  padding: const EdgeInsets.only(top: 8),
                  child: Center(
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 5),
                                height: 50,
                                width: widget.screenSize.width,
                                child: ListView.builder(
                                  itemBuilder: (context, index) => Card(
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          selected = index;
                                        });
                                      },
                                      child: Container(
                                        constraints:
                                            widget.size == ScreenSize.small
                                                ? null
                                                : BoxConstraints(minWidth: 200),
                                        decoration: BoxDecoration(
                                            color: selected == index
                                                ? Colors.blue.shade200
                                                : null,
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        child: Center(
                                          child: Text(
                                            _categories[index],
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.raleway(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                      ),
                                    ),
                                  ),
                                  itemCount: _categories.length,
                                  scrollDirection: Axis.horizontal,
                                ),
                              ),
                              Expanded(
                                child: ProductGrid(
                                    widget.size,
                                    widget.screenSize,
                                    selected == 0 ? "" : _categories[selected],
                                    sort),
                              ),
                            ],
                          ),
                  ),
                ),
                items: [
                  HawkFabMenuItem(
                    label: 'Price: High to Low',
                    ontap: () {
                      setState(() {
                        sort = 0;
                      });
                    },
                    icon: Icon(
                      Icons.arrow_upward,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : null,
                    ),
                    labelColor: Colors.white,
                    labelBackgroundColor: Colors.blue,
                  ),
                  HawkFabMenuItem(
                    label: 'Price: Low to High',
                    ontap: () {
                      setState(() {
                        sort = 1;
                      });
                    },
                    icon: Icon(Icons.arrow_downward),
                    color: Theme.of(context).accentColor,
                    labelColor: Colors.blue,
                  ),
                ],
              ),
            ),
    );
  }
}
