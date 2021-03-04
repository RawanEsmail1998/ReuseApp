import 'dart:async';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class AuthProvider with ChangeNotifier {
  User user ;
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
    return user != null;
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