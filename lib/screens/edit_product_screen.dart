import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/product.dart';
import 'package:shop_app/provider/products.dart';
import 'package:shop_app/screens/user_products_screen.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit_product';
  /*final String? id ;
  EditProductScreen({this.id});*/

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}
/*
* the codes of focusNode is to pass from textForm to another*/
class _EditProductScreenState extends State<EditProductScreen> {
  /*final String id ;
  _EditProductScreenState(this.id);*/
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _editProduct = Product(id: '', title: '', description: '', price: 0, imageUrl: '');
  var _initValues = {
    'title' : '' ,
    'description' : '' ,
    'price' : '' ,
    'imageUrl' : '' ,
 };
  var _isInit = true ;
  var _isLoading = false ;

@override
  void initState() {
    // TODO: implement initState
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
    final productId = ModalRoute.of(context)!.settings.arguments as String ;
    if (productId != '') {
      _editProduct = Provider.of<Products>(context , listen: false).findProductById(productId);
      _initValues = {
        'title' : _editProduct.title ,
        'description' : _editProduct.description ,
        'price' : _editProduct.price.toString() ,
        'imageUlr' : '' ,
      };
      _imageUrlController.text = _editProduct.imageUrl ;
    }
    }
    _isInit = false ;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
  _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl () {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
          !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editProduct.id != '') {
     await Provider.of<Products>(context, listen: false)
          .updateProduct(_editProduct.id, _editProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              TextButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Product'),
      actions:
      [
        IconButton(onPressed: _saveForm, icon: Icon(Icons.save,)),
      ],
      ),
      // :
      body: _isLoading ? Center(child: CircularProgressIndicator(),) : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children:
            [
              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_)
                {
                  // here to move to the next textForm when we done
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value) {
                  _editProduct = Product(
                      id: _editProduct.id,
                      title: value!,
                      description: _editProduct.description,
                      price: _editProduct.price,
                      imageUrl: _editProduct.imageUrl,
                    isFavourite: _editProduct.isFavourite ,
                  );
                },
                validator: (value){
                  if(value!.isEmpty){
                    return 'title must not be empty' ;
                  }
                    return null ;
                },
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_)
                {
                FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (value) {
                  _editProduct = Product(
                      id: _editProduct.id,
                      title: _editProduct.title,
                      description: _editProduct.description,
                      price: double.parse(value!),
                      imageUrl: _editProduct.imageUrl,
                    isFavourite: _editProduct.isFavourite,
                  );
                },
                validator: (value){
                  if(value!.isEmpty){
                    return 'price must not be empty' ;
                  }
                  if (double.tryParse(value) == null) {
                    return 'please enter a valid number' ;
                  }
                  if (double.parse(value) <= 0) {
                    return 'please add a value greater than zero';
                  }
                    return null ;
                },
              ),
              TextFormField(
                initialValue: _initValues['description'],
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                onSaved: (value) {
                  _editProduct = Product(
                      id: _editProduct.id,
                      title: _editProduct.title,
                      description: value!,
                      price: _editProduct.price,
                      imageUrl: _editProduct.imageUrl,
                    isFavourite: _editProduct.isFavourite,
                  );
                },
                validator: (value){
                  if(value!.isEmpty){
                    return 'description must not be empty' ;
                  }
                  if (value.length < 10) {
                    return 'description must be greater than 10' ;
                  }
                    return null ;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children:
                [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsetsDirectional.only(top: 8,end: 10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1,color: Colors.grey),
                    ),
                    child:_imageUrlController.text.isEmpty ? Text('Enter a URL') : FittedBox(
                      child: Image.network(_imageUrlController.text),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image Url'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      onFieldSubmitted: (value){
                        _saveForm();
                      },
                      onSaved: (value) {
                        _editProduct = Product(
                            id: _editProduct.id,
                            title: _editProduct.title,
                            description: _editProduct.description,
                            price: _editProduct.price,
                            imageUrl: value!,
                          isFavourite: _editProduct.isFavourite,
                        );
                      },
                      validator: (value){
                        if (value!.isEmpty) {
                          return 'Please enter an image URL.';
                        }
                        if (!value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return 'Please enter a valid URL.';
                        }
                        if (!value.endsWith('.png') &&
                            !value.endsWith('.jpg') &&
                            !value.endsWith('.jpeg')) {
                          return 'Please enter a valid image URL.';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}