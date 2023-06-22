import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/provider/product.dart';
import 'package:shop_app/provider/products.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/product_item.dart';
import 'package:shop_app/widgets/products_grid.dart';

enum FilterOption
{
favourite ,
  all ,
}

class ProductOverviewScreen extends StatefulWidget
{
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {

  var isFav = false ;
  var _isInit = true ;
  var _isLoading = false ;

  @override
  void initState() {
    //Provider.of<Products>(context).fetchAndSetData(); no statement have of(context) work in initState never so we go do didChange..
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if(_isInit) {
      setState(() {
        _isLoading = true;
      });
      try {
        await Provider.of<Products>(context).fetchAndSetData();
      } catch (err) {
        print('err');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
    _isInit = false ;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //final productContainer = Provider.of<Products>(context , listen: false );

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop',),
        actions:
        [
          PopupMenuButton(
              itemBuilder: (item) =>
              [
                PopupMenuItem(child: Text('Only Favourite' ,) , value: FilterOption.favourite,),
                PopupMenuItem(child: Text('Show All' ,) , value: FilterOption.all,),
              ] ,
            icon: Icon(
              Icons.more_vert,
            ),
            onSelected: (FilterOption index){
                setState(() {

                });
                if (index == FilterOption.favourite) {
                  // productContainer.showFavouritesOnly() ;
                  isFav = true ;

                } else {
                  // productContainer.showAll();
                  isFav = false ;

                }
            },
          ),
         Consumer<Cart>(builder: (ctx,cart,ch)=>  Badge(//ch is child
             child: IconButton(
               icon: Icon(
                 Icons.shopping_cart,
               ),
               onPressed: ()
               {
                 Navigator.of(context).pushNamed(CartScreen.routeName);
               },
             ),
             value:cart.itemCount.toString() ,
         ),

         ),
        ],
      ),
      drawer: AppDrawer(),
      body:Padding(
        padding: const EdgeInsets.all(10.0),
        child: _isLoading ? Center(child: CircularProgressIndicator(),) : ProductsGrid(isFav),
      ),
    );
  }
}
