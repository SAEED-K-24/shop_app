import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/auth.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/provider/product.dart';
import 'package:shop_app/screens/product_details_screen.dart';

class ProductItem extends StatelessWidget
{
  /*final String id ;
  final String title ;
  final String imageUrl ;

  ProductItem(this.id, this.title, this.imageUrl);*/
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context,listen: false);//here it just get the data without rebuild
    final cart = Provider.of<Cart>(context,listen: false);
    final authData = Provider.of<Auth>(context , listen: false);

    // TODO: implement build
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
    child:GridTile(
    child: GestureDetector(
    onTap: ()
    {
    Navigator.of(context).pushNamed(ProductDetailsScreen.routeName , arguments: product.id);
    },
    child: Image.network(
    product.imageUrl,
    fit: BoxFit.cover,
    ),
    ),
    footer: GridTileBar(
    backgroundColor: Colors.black87,
    leading: Consumer<Product>(
      // here is the only way rebuild cause we have the consumer
      builder: (ctx , product , child) => IconButton(
        icon: Icon(
          product.isFavourite ? Icons.favorite : Icons.favorite_border ,
        ),
        color: Theme.of(context).accentColor,
        onPressed: ()
        {
          product.toggleFavouriteState(authData.token,authData.userId);
        },
      ) ,
    ),
    trailing:IconButton(
    icon: Icon(
    Icons.shopping_cart,
    ),
    color: Theme.of(context).accentColor,
    onPressed: ()
    {
      cart.addItem(product.id, product.title, product.price);
      Scaffold.of(context).hideCurrentSnackBar();
      Scaffold.of(context).showSnackBar(
        SnackBar(
            content: Text('Added item to cart'),
          duration:Duration(seconds: 2),
          action: SnackBarAction(
            label: 'UNDO',
            onPressed: ()
            {
              cart.removeSingleItem(product.id);
            },
          ),
        ),
      );
    },
    ),
    title: Text(
    product.title ,
    textAlign: TextAlign.center,
    ),
    ),
    ),
    );

  }
}