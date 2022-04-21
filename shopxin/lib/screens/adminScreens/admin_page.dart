import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:shop_app/models/user.dart' as user;
import 'package:shop_app/provider/userProvider.dart';
import 'package:shop_app/widgets/user_tile.dart';

class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<User>(context).getUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        List<user.User> _user = snapshot.data as List<user.User>;
        return ListView.builder(
          itemBuilder: (context, index) => UserTile(user: _user[index]),
          itemCount: _user.length,
        );
      },
    );
  }
}
