import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class Items{
  String name ;
  List image ;
  String city ;
  String type ;
  String details ;
  String documentId ;
  String price ;
  int duration ;
  String category;
  String uid ;
  Timestamp createdOn ;
  bool notClosed ;
  Items.fromMap(Map<String , dynamic> data){
    name = data['name'];
    image = data['imageUrl'];
    city = data['city'];
    type = data['type'];
    details = data['details'];
    duration = data['duration'];
    price = data['price'] ;
    category = data['category'];
    documentId = data['documentId'];
    uid = data['uid'] ;
    createdOn = data['createdOn'];
    notClosed = data['notClosed'];

  }
}
