import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';
class Auth with ChangeNotifier
{
  String? _token ;
  DateTime? _expiryDate ;
  String? _userId ;
  Timer? _authTimer ;

  bool get isAuth {
  return token != null ;
  }

  String? get userId {
    return _userId ;
  }
  String? get token {
  if (_expiryDate !=  null && _expiryDate!.isAfter(DateTime.now())
  && _token != null) {
    return _token ;
  }
  return null ;
  }

  Future<void> _authenticate (String email , String password , String urlSegment) async {
    final url = 'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBAzHmH1sfh354cQr3yz7NuT1Po_7cJ2Kg';
     try {
       final response = await http.post( Uri.parse(url) ,
      body: json.encode({
        'email': email,
        'password':password,
        'returnSecureToken':true ,
      },
      ),
    );
       final responseData = json.decode(response.body);
       if (responseData['error'] != null) {
         throw HttpException(responseData['error']['message']);
       }
       _token = responseData['idToken'];
       _userId = responseData['localId'];
       _expiryDate = DateTime.now().add(Duration(seconds:
       int.parse(responseData['expiresIn']),),);
       _autoLogout();
       notifyListeners();
        }catch(err){
        throw err ;
    }
    //print(json.decode(response.body));
  }

  Future<void> signup (String email , String password) async {
   return _authenticate(email, password, 'signUp');
  }

  Future<void> login (String email , String password) async {
    return _authenticate(email, password,'signInWithPassword');
  }

  void logout () {
    _token = null ;
    _userId = null ;
    _expiryDate = null ;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null ;
    }
    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry),logout);
  }
}