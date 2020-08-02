import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/helpers/custom_routes.dart';
import 'package:shopping_app/providers/auth.dart';
import 'package:shopping_app/screens/user_products_screen.dart';

import '../screens/orders_screen.dart';

class DrawersWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello!'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () => Navigator.of(context).pushReplacementNamed('/'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(OrdersScreen.routeName),

            // Navigator.pushReplacement(context,CustomRoute(
            //   builder: (context)=>OrdersScreen(),
            // ));}
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(UserProductsScreen.routeName),
          ),
          Divider(
            thickness: 2,
            color: Colors.black87,
          ),
          ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.blue,
              ),
              title: Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/');
                Provider.of<Auth>(context, listen: false).logOut();
              }),
        ],
      ),
    );
  }
}
