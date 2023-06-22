import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http ;
import 'package:shop_app/models/http_exception.dart';

class Product with ChangeNotifier
{
  final String id ;
  final String title ;
  final String description ;
  final double price ;
  final String imageUrl ;
  bool isFavourite ;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavourite = false ,
  });
  void _setFavValue(bool newValue) {
    isFavourite = newValue;
    notifyListeners();
  }
  Future<void> toggleFavouriteState (String? token , String? userId) async
  {
    final oldState = isFavourite ;
    isFavourite = !isFavourite ;
    notifyListeners();
    final url = Uri.parse('https://shop-app-6894d-default-rtdb.firebaseio.com/userFavourites/$userId/$id.json?auth=$token');
    try {
      final response = await http.put(url , body: json.encode(
      isFavourite,
      ),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldState);
      }
    }catch(err)
    {
      _setFavValue(oldState);
     /* notifyListeners();
      Fluttertoast.showToast(
          msg: "${err.toString()}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );*/
    }
  }
}