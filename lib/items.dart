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
   String uid ;

  Items.fromMap(Map<String , dynamic> data){
    name = data['name'];
    image = data['imageUrl'];
    city = data['city'];
    type = data['type'];
    details = data['details'];
    duration = data['duration'];
    price = data['price'] ;
    documentId = data['documentId'];
    uid = data['uid'] ;
  }
}
