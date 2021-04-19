import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reuse_app/Home_Screen.dart';
import 'package:reuse_app/item_notifier.dart';
import 'items.dart';

import 'detailsScreen.dart';
class AuthProvider with ChangeNotifier {
  User user ;
  var path ;
  List adminUsers = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription userAuthSub ;

  AuthProvider(){
    userAuthSub = FirebaseAuth.instance.userChanges().listen((newUser) {
      print('AuthProvider - firebaseAuth - $newUser');
      user = newUser ;
      notifyListeners();

    }, onError: (e){
      print('AuthProvider - firebaseAuth - $e');
    });
  }
  @override
  void dispose(){
   if(userAuthSub !=null){
     userAuthSub.cancel();
     userAuthSub = null ;
   }
    super.dispose() ;
  }

  bool get isAuthenticated {

    return user != null  ;
  }
   _userFromFirebaseUser(User user){
    return user != null ? (user.uid) : null ;
  }
  Stream<User> get users{
    return _auth.authStateChanges()
        .map(_userFromFirebaseUser);
  }
  // register user with email and password
  Future registerWithEmailAndPassword(String Email , String Password ) async{
    try{
    UserCredential result = await _auth.createUserWithEmailAndPassword(email: Email, password: Password);
    User user = result.user ;
    await result.user.sendEmailVerification();
    return _userFromFirebaseUser(user) ;
    }catch(e){
       print(e.toString());
    }
  }
  // sign in with email and password
  Future signInWithEmailAndPassword(String Email , String Password ) async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: Email, password: Password) ;
      User user = result.user ;
      if(user.emailVerified){
        return _userFromFirebaseUser(user) ;
      }
    }catch(e){
      print(e.toString());
    }
  }
  void signOut() {
    FirebaseAuth.instance.signOut();
  }


}
getItem(ItemNotifier itemNotifier) async{
 QuerySnapshot snapshot =  await FirebaseFirestore.instance.collection('auctionItems').get();
 QuerySnapshot snapshot2 =  await FirebaseFirestore.instance.collection('donatedItems').get();
List<Items> _itemList = [];
snapshot.docs.forEach((document) {

Items item = Items.fromMap(document.data());
_itemList.add(item);
itemNotifier.itemList = _itemList ;

});
snapshot2.docs.forEach((document) {

  Items item = Items.fromMap(document.data());
 // _itemList.insert(path, item);
  _itemList.add(item);
  itemNotifier.itemList = _itemList ;


});


}
