//@dart=2.9

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/provider/authProvider.dart';
import 'package:shop_app/provider/cartProvider.dart';
import 'package:shop_app/provider/productProvider.dart';
import 'package:shop_app/provider/userProvider.dart';

import 'package:shop_app/screens/add_product_screen.dart';
import 'package:shop_app/screens/adminScreens/userDetailScreen_admin.dart';
import 'package:shop_app/screens/cartPage.dart';
import 'package:shop_app/screens/my_account_page.dart';
import 'package:shop_app/screens/my_favorite_screen.dart';
import 'package:shop_app/screens/my_orders_page.dart';
import 'package:shop_app/screens/my_product_screen.dart';
import 'package:shop_app/screens/order_detail_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/searchpage.dart';

import './screens/mainPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProductProvider>(
          create: (context) => ProductProvider('', '', []),
          update: (context, auth, previous) => ProductProvider(auth.token,
              auth.userId, previous == null ? [] : previous.products),
        ),
        ChangeNotifierProxyProvider<AuthProvider, User>(
          create: (context) => User('', '', -1),
          update: (context, auth, previous) =>
              User(auth.token, auth.userId, auth.role),
        ),
        ChangeNotifierProxyProvider<AuthProvider, Cart>(
          create: (context) => Cart('', ''),
          update: (context, auth, previous) => Cart(auth.userId, auth.token),
        ),
      ],
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            currentFocus.focusedChild?.unfocus();
          }
        },
        child: Consumer<AuthProvider>(
          builder: (context, auth, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'SoulShop',
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                primarySwatch: Colors.indigo,
                accentColor: Colors.amber,
                fontFamily: 'Poppins',
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  TargetPlatform.android: ZoomPageTransitionsBuilder()
                }),
                textTheme: TextTheme(
                  headline6: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, color: Colors.white),
                  bodyText1: GoogleFonts.raleway(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  subtitle2: GoogleFonts.notoSans(fontSize: 16),
                ),
              ),
              themeMode: auth.isDark ? ThemeMode.dark : ThemeMode.light,
              theme: ThemeData(
                primarySwatch: Colors.indigo,
                accentColor: Colors.amber,
                fontFamily: 'Poppins',
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  TargetPlatform.android: ZoomPageTransitionsBuilder()
                }),
                textTheme: TextTheme(
                  headline6: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                  ),
                  bodyText1: GoogleFonts.raleway(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  subtitle2: GoogleFonts.notoSans(fontSize: 16),
                ),
              ),
              home: MainScreen(auth),
              routes: {
                ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
                AddProductScreen.routeName: (ctx) => AddProductScreen(),
                SearchPage.routeName: (ctx) => SearchPage(),
                UserDetailScreenAdmin.routeName: (ctx) =>
                    UserDetailScreenAdmin(),
                MyAccountPage.routeName: (ctx) => MyAccountPage(),
                CartPage.routeName: (ctx) => CartPage(),
                MyOrderPage.routeName: (ctx) => MyOrderPage(),
                MyProduct.routeName: (ctx) => MyProduct(),
                MyFavScreen.routeName: (ctx) => MyFavScreen(),
                OrderDetailPage.routeName: (ctx) => OrderDetailPage()
              },
            );
          },
        ),
      ),
    );
  }
}
