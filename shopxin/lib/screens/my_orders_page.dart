import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/order.dart';
import 'package:shop_app/provider/cartProvider.dart';
import 'package:shop_app/widgets/order_page_order.dart';

class MyOrderPage extends StatefulWidget {
  static const routeName = "/my-order-page";

  @override
  _MyOrderPageState createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage> {
  bool loading = false;

  @override
  void initState() {
    setState(() {
      loading = true;
    });
    Provider.of<Cart>(context, listen: false).getOrder('').then((value) {
      setState(() {
        loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Order> order = Provider.of<Cart>(context).orders;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Orders',
           style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? null
                          : Colors.white,
                    ),
        ),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return OrderPageOrder(order[index].pIds, order[index].q,
                      order[index].dateTime, order[index].id);
                },
                itemCount: order.length,
              ),
            ),
    );
  }
}
