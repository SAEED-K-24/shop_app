import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/auth.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: Column(
        children:
        [
          AppBar(
            title: Text('Hello friends!' ,),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop,),
            title: Text('Shop'),
            onTap: ()
            {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          ListTile(
            leading: Icon(Icons.payment,),
            title: Text('Your Order'),
            onTap: ()
            {
              Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.edit,),
            title: Text('Mange products'),
            onTap: ()
            {
              Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app,),
            title: Text('Logout'),
            onTap: ()
            {
              Navigator.of(context).pop();
             // Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName);
              Provider.of<Auth>(context , listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}