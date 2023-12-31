import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/products.dart';

class ProductDetailsScreen extends StatelessWidget
{
/*  final String title ;
  final double price ;

  ProductDetailsScreen(this.title,this.price);*/
  static const routeName = '_product_details';
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String ;
   final loadedProduct = Provider.of<Products>(
       context,
     listen : false //  - if i need to get data without rebuild the widget
   ).findProductById(productId);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title,),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                loadedProduct.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '\$${loadedProduct.price}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                loadedProduct.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}