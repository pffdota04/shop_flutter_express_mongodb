import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/HttpException.dart';
import 'package:shop_app/models/cart.dart';
import 'package:shop_app/provider/cartProvider.dart';
import 'package:shop_app/widgets/cart_item.dart';

class OrderDetailPage extends StatefulWidget {
  static const routeName = "order-detail";

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  int _currentStep = 0;
  var paymentMethod = 'Cash on Delivery';
  List<CartItem> _cart = [];

  void placeOrder() async {
    try {
      await Provider.of<Cart>(context, listen: false).placeOrder();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Order Placed Successfully!',
            textAlign: TextAlign.center,
          ),
          content: LottieBuilder.asset(
            'assets/images/success.json',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text(
                'Okay!',
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            ),
          ],
        ),
      );
    } on HttpException catch (err) {
      print(err);
    }
  }

  tapped(int step) {
    setState(() {
      _currentStep = step;
    });
  }

  continued() {
    // ignore: unnecessary_statements
    _currentStep < 2
        ? setState(() {
            _currentStep += 1;
          })
        : placeOrder();
  }

  cancel() {
    _currentStep > 0
        ?
        // ignore: unnecessary_statements
        setState(() => _currentStep -= 1)
        : Navigator.of(context).pop();
  }

  @override
  void initState() {
    _cart = Provider.of<Cart>(context, listen: false).items.values.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Details',
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(color: Colors.white),
        ),
      ),
      body: Stepper(
        steps: [
          Step(
            title: new Text('Address'),
            content: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Home Address'),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Postcode'),
                ),
              ],
            ),
            isActive: _currentStep >= 0,
            state: _currentStep >= 0 ? StepState.complete : StepState.disabled,
          ),
          Step(
            title: new Text('Products'),
            content: Column(
              children: <Widget>[
                ..._cart.map((cartItem) => GenCartItem(cartItem)).toList(),
              ],
            ),
            isActive: _currentStep >= 0,
            state: _currentStep >= 1 ? StepState.complete : StepState.disabled,
          ),
          Step(
            title: new Text('Payment Method'),
            content: Column(
              children: <Widget>[
                paymentOption('Cash on Delivery'),
                paymentOption('Credit / Debit Card'),
                paymentOption('UPI / Wallet'),
              ],
            ),
            isActive: _currentStep >= 0,
            state: _currentStep >= 2 ? StepState.complete : StepState.disabled,
          ),
        ],
        currentStep: _currentStep,
        onStepCancel: cancel,
        onStepTapped: tapped,
        onStepContinue: continued,
      ),
    );
  }

  Row paymentOption(String val) {
    return Row(
      children: [
        Radio(
          value: val,
          groupValue: paymentMethod,
          onChanged: (cur) {
            // print(cur);
            setState(() {
              paymentMethod = cur.toString();
            });
          },
        ),
        Text(
          val,
          style: GoogleFonts.poppins(),
        ),
      ],
    );
  }
}
