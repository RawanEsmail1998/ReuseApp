import 'package:flutter/material.dart';
class Items{
  String name ;
  List image ;
  String city ;
  String type ;


  Items.fromMap(Map<String , dynamic> data){
    name = data['name'];
    image = data['imageUrl'];
    city = data['city'];
    type = data['type'];

  }
}
