import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/userProvider.dart';
import 'package:shop_app/screens/adminScreens/userDetailScreen_admin.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shop_app/models/user.dart' as user;

class UserTile extends StatelessWidget {
  const UserTile({
    Key? key,
    required user.User user,
  })   : _user = user,
        super(key: key);

  final user.User _user;

  @override
  Widget build(BuildContext context) {
    var userDetail = ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      onTap: () {
        Navigator.of(context)
            .pushNamed(UserDetailScreenAdmin.routeName, arguments: _user.id);
      },
      tileColor: _user.role == 0 ? Colors.yellow.shade800 : Colors.lightGreen,
      leading: CircleAvatar(
        child: Icon(Icons.person),
      ),
      title: Text(
        '${_user.firstname} ${_user.lastname}',
        style: Theme.of(context).textTheme.bodyText1!.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : null,
            ),
      ),
      subtitle: Text(
        _user.role == 0 ? 'Seller' : 'Buyer',
        style: Theme.of(context).textTheme.subtitle2!.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : null,
            ),
      ),
    );
    return Dismissible(
      key: Key(_user.id),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Confirmation',
              style: Theme.of(context).textTheme.headline6!.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black),
            ),
            content: Text('Do you want to delete this user?',
                style: GoogleFonts.poppins()),
            actions: [
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                icon: Icon(Icons.cancel_outlined,
                    color: Theme.of(context).accentColor),
                label: Text(
                  'No',
                  style:
                      GoogleFonts.poppins(color: Theme.of(context).accentColor),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  Provider.of<User>(context, listen: false)
                      .deleteUser(_user.id);
                },
                icon: Icon(
                  Icons.check_circle_outline,
                  color: Theme.of(context).accentColor,
                ),
                label: Text(
                  'Yes',
                  style:
                      GoogleFonts.poppins(color: Theme.of(context).accentColor),
                ),
              )
            ],
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: userDetail,
          ),
        ),
      ),
    );
  }
}
