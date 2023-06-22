
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/product.dart';
import 'package:shop_app/provider/products.dart';
import 'package:shop_app/widgets/product_item.dart';
/*
* we use here stateful because we affect only in this widget*/
class ProductsGrid extends StatelessWidget
{
  final bool showFav ;
 ProductsGrid(this.showFav);
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context) ;
    final products = showFav ? productData.favouriteProducts : productData.products;
    // TODO: implement build
    return  GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 columns
        childAspectRatio: 3/2,//width , height
        crossAxisSpacing: 10,//spacing between the columns
        mainAxisSpacing: 10,//spacing between the rows
      ),
      itemBuilder: (context , index) => ChangeNotifierProvider.value(
        value : products[index],
        child: ProductItem(
          /*  products[index].id,
            products[index].title,
            products[index].imageUrl*/
        ),
      ),
      itemCount: products.length,
    ) ;
  }
}