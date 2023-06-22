import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart.dart' show Cart;
import 'package:shop_app/provider/orders.dart';
import 'package:shop_app/widgets/cart_item.dart';

class CartScreen extends StatelessWidget
{
  static const routeName = '\cart' ;
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your cart',),
      ),
      body: Column(
        children:
        [
          Card(
            margin: EdgeInsets.all(20),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:
                [
                  Text('Total' , style: TextStyle(fontSize: 20,),),
                  Spacer(),
                  Chip(label: Text('\$${cart.totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.lightBlue),),
                  backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          Expanded(child:
          ListView.builder(
              itemBuilder: (cts , i) => CartItem(
                cart.items.values.toList()[i].id ,
                cart.items.keys.toList()[i],
                cart.items.values.toList()[i].title ,
                cart.items.values.toList()[i].price,
                cart.items.values.toList()[i].quantity ,
              ),
            itemCount: cart.itemCount,
          ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false ;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading) ? null : () async
      {
        setState(() {
          _isLoading = true ;
        });
        await Provider.of<Orders>(context , listen: false).addOrder(widget.cart.items.values.toList(), widget.cart.totalAmount);
        setState(() {
          _isLoading = false ;
        });
        widget.cart.clear();
      },
      child:_isLoading ? Center(child: CircularProgressIndicator(),) : Text('ORDER NOW',),
      style:ButtonStyle(
        foregroundColor:  MaterialStateProperty.all(Theme.of(context).primaryColor),
      ) ,
    );
  }
}
/*
* now we have a problem they are tow class named CartItem
* and we have two solution
* first import 'package:shop_app/provider/cart.dart' show Cart; ==
* mean i need from this package just Cart class without cartItem class
* second sol import 'package:shop_app/widgets/cart_item.dart' as cs(any name);
* then we use cs.CartItem then the system now any class you mean */