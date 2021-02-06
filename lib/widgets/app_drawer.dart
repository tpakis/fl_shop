import 'package:flutter/material.dart';

import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';
import '../common/constants.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text("My Shop!"),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text("Shop"),
            onTap: () { Navigator.of(context).pushReplacementNamed(initialScreenRoute); },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text("Orders"),
            onTap: () { Navigator.of(context).pushNamed(OrdersScreen.routeName); },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("User Products"),
            onTap: () { Navigator.of(context).pushNamed(UserProductsScreen.routeName); },
          )
        ],
      ),
    );
  }
}
