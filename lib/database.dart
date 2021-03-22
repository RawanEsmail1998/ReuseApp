import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  CollectionReference userAccount =
      FirebaseFirestore.instance.collection('users');
  Future<void> userSetup(
      String name, String Phone, String city, String email) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser.uid.toString();
    await userAccount.doc(uid).set({
      'Full_Name': name,
      'Phone_Number': Phone,
      'City': city,
      'uid': uid,
      'email': email,
    });
  }

// get account stream
  Stream<QuerySnapshot> get account{
    return userAccount.snapshots();
  }
}
