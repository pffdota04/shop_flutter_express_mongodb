import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:day_night_switcher/day_night_switcher.dart';

import 'package:provider/provider.dart';
import 'package:shop_app/provider/authProvider.dart';
import 'package:shop_app/screens/cartPage.dart';
import 'package:shop_app/screens/my_account_page.dart';
import 'package:shop_app/screens/my_favorite_screen.dart';
import 'package:shop_app/screens/my_orders_page.dart';
import 'package:shop_app/screens/my_product_screen.dart';

class CustomDrawer extends StatefulWidget {
  final int role;

  CustomDrawer(this.role);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool isDark = false;
  int role = 1;

  @override
  void initState() {
    isDark = Provider.of<AuthProvider>(context, listen: false).isDark;
    role = Provider.of<AuthProvider>(context, listen: false).role;
    super.initState();
  }

  toggleDark() {
    Provider.of<AuthProvider>(context, listen: false).toggleDark();
    setState(() {
      isDark = !isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget drawerHeader = Container(
      height: 230,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/app_drawer.jpg'),
            fit: BoxFit.cover),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 40,
              child: Icon(
                Icons.person,
                size: 40,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Hello There!',
            style: GoogleFonts.poppins(fontSize: 24, color: Colors.white),
          ),
        ],
      ),
    );

    return Drawer(
      elevation: 60,
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            drawerHeader,
            option(context, 'My Orders', Icons.shopping_bag, () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(MyOrderPage.routeName);
            }),
            option(context, 'My Account', Icons.person, () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(MyAccountPage.routeName);
            }),
            if (role == 0 || role == 1)
              option(context, 'My Cart', Icons.shopping_cart, () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(CartPage.routeName);
              }),
            if (role == 0 || role == 1)
              option(context, 'My Favorite', Icons.favorite, () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(MyFavScreen.routeName);
              }),
            option(context, 'My Products', Icons.list, () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(MyProduct.routeName);
            }),
            option(context, 'About Us', Icons.help_outline, () {}),
            option(context, 'Rate Us', Icons.star, () {}),
            option(context, 'Log Out', Icons.logout, () {
              Provider.of<AuthProvider>(context, listen: false).logout();
            }),
            Spacer(),
            ListTile(
              title: Text(
                'Switch Mode',
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              trailing: DayNightSwitcher(
                isDarkModeEnabled: isDark,
                onStateChanged: (isDarkModeEnabled) {
                  toggleDark();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListTile option(
      BuildContext context, String name, IconData icon, Function function) {
    return ListTile(
      leading: Icon(
        icon,
        size: 24,
      ),
      title: Text(
        name,
        style: GoogleFonts.poppins(fontSize: 14),
      ),
      onTap: () {
        function();
      },
    );
  }
}
