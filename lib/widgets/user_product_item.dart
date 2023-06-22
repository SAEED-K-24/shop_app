import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id ;
  final String title;
  final String imageUrl;

  UserProductItem(this.id,this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: ()
              {
                Navigator.of(context).pushNamed(EditProductScreen.routeName , arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: ()
              {
                showDialog(context: context, builder: (ctx) => AlertDialog(
                  title: Text('Are tou sure ?'),
                  content: Text('Do you want to remove the item from the cart'),
                  actions:
                  [
                    TextButton(onPressed: (){Navigator.of(context).pop(false);}, child: Text('NO'),),
                    TextButton(onPressed: () async
                    {
                      try {
                        await Provider.of<Products>(context, listen: false)
                            .deleteProduct(id);
                      }catch(err){
                        scaffold.showSnackBar(SnackBar(
                            content: Text('${err.toString()}', textAlign: TextAlign.center,)
                        ),);
                      }finally{
                        Navigator.of(ctx).pop(true);
                      }

                      }
                      , child: Text('YES'),),
                  ],
                ));

              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
