import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

import '../provider/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> refreshProduct (BuildContext context) async
  {
    await Provider.of<Products>(context,listen: false).fetchAndSetData(true);
  }

  @override
  Widget build(BuildContext context) {
    //final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName, arguments: '');
                  /*
                  * we use pushNamed (not pushReplaceNamed) case we want the app open new page
                  * */
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: refreshProduct(context),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) =>
            snapshot.connectionState == ConnectionState.waiting ?
                Center(child: CircularProgressIndicator(),) :
          RefreshIndicator(
          onRefresh: () => refreshProduct(context),
          child: Consumer<Products>(
            builder: (ctx,productsData,_) =>  Padding(
              padding: EdgeInsets.all(8),
              child: ListView.builder(
                itemCount: productsData.products.length,
                itemBuilder: (_, i) => Column(
                  children: [
                    UserProductItem(
                      productsData.products[i].id,
                      productsData.products[i].title,
                      productsData.products[i].imageUrl,
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
