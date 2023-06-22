import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/auth.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/provider/orders.dart';
import 'package:shop_app/provider/products.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_details_screen.dart';
import 'package:shop_app/screens/product_overview_screens.dart';
import 'package:shop_app/screens/user_products_screen.dart';

import 'shared/Themes/themes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:
      [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProxyProvider<Auth,Products>(
          // we here move data from auth to product
          create: (_) => Products(),
          update:(ctx,auth, previousProducts) => previousProducts!..update(
              auth.token, auth.userId,
              previousProducts.products ) ,
        ),
        ChangeNotifierProvider.value(value: Cart()),
        ChangeNotifierProxyProvider<Auth,Orders>(
          create: (_) => Orders(),
          update:(ctx,auth,previousOrders) =>
              previousOrders!..update(auth.token,auth.userId, previousOrders.orders),
        ),
      ],


        child: Consumer<Auth>(
          builder: (BuildContext context, value, Widget? child) =>
              MaterialApp(
            debugShowCheckedModeBanner: false,
            title:'MyShop',
            theme: lightTheme,
            home: value.isAuth ? ProductOverviewScreen() : AuthScreen(),
            routes: {
              ProductDetailsScreen.routeName : (context) => ProductDetailsScreen(),
              CartScreen.routeName : (context) => CartScreen() ,
              OrdersScreen.routeName : (context) => OrdersScreen(),
              UserProductsScreen.routeName : (context) => UserProductsScreen(),
              EditProductScreen.routeName : (context) => EditProductScreen(),
            },
          ) ,
        ),
    );
  }
}

