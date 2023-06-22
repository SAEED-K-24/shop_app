import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart.dart';

class CartItem extends StatelessWidget
{
  final String id ;
  final String productId ;
  final String title ;
  final double price ;
  final int quantity ;

  CartItem(this.id,this.productId , this.title, this.price, this.quantity);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Dismissible( // to remove widget
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(Icons.delete ,size: 40,),
        alignment: Alignment.centerRight,
        padding: EdgeInsetsDirectional.only(end: 20),
        margin: EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 15,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction)
      {
      Provider.of<Cart>(context , listen: false).removeItem(productId);
      },
      confirmDismiss: (direction)
      {
        return showDialog(context: context, builder: (ctx) => AlertDialog(
          title: Text('Are tou sure ?'),
          content: Text('Do you want to remove the item from the cart'),
          actions:
          [
          TextButton(onPressed: (){Navigator.of(context).pop(false);}, child: Text('NO'),),
          TextButton(onPressed: (){Navigator.of(context).pop(true);}, child: Text('YES'),),
          ],
        ));
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 15,
        ),
        child: Padding(
          padding:EdgeInsets.all(8) ,
          child: ListTile(
            leading: CircleAvatar(child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: FittedBox(child: Text('$price',)),
            ),),
            subtitle: Text('Total : \$${(price * quantity)}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
