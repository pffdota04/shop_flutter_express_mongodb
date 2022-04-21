import 'package:flutter/material.dart';

import 'package:shop_app/screens/homepage.dart';
import 'loginpage.dart';

enum ScreenSize {
  extraLarge,
  large,
  medium,
  small,
}

class MainScreen extends StatelessWidget {
  final auth;
  MainScreen(this.auth);
  @override
  Widget build(BuildContext context) {
    ScreenSize size;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1920) {
          size = ScreenSize.extraLarge;
        } else if (constraints.maxWidth > 1200) {
          size = ScreenSize.large;
        } else if (constraints.maxWidth > 960) {
          size = ScreenSize.medium;
        } else {
          size = ScreenSize.small;
        }
        return !auth.isAuth
            ? FutureBuilder(
                future: auth.tryAutoLogin(),
                builder: (context, snapshot) => LoginPage(
                    Size(constraints.maxWidth, constraints.maxHeight)),
              )
            : HomePage(size, Size(constraints.maxWidth, constraints.maxHeight),
                auth.role);
      },
    );

    // return Consumer<AuthProvider>(
    //   builder: (context, auth, _) {
    //     if (!auth.isAuth) {
    //       return FutureBuilder(
    //         future: auth.tryAutoLogin(),
    //         builder: (context, snapshot) => LoginPage(screenSize),
    //       );
    //     }
    //     return HomePage(size, screenSize, auth.role);
    //   },
    // );
  }
}
