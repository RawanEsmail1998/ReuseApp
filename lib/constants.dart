import 'package:flutter/material.dart';

const KTextField = InputDecoration(
  hintText: 'الاسم الكامل',
  contentPadding:
  EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderSide: BorderSide(
      width:3.0,
      color: Colors.black,

    ),
    borderRadius:BorderRadius.all(Radius.circular(10)),

  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),

  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent,width:1.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
) ;
