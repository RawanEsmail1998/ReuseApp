import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'items.dart';
class ItemNotifier with ChangeNotifier {
  List<Items> _itemList = [];
  Items _currentItem ;
  // UnmodifiableListView<Items> get itemList => UnmodifiableListView(_itemList) ;
  List<Items> get itemList => _itemList;

      Items get currentItem => _currentItem ;
  set itemList(List<Items> itemList){
    _itemList = itemList;
    notifyListeners();
  }

  set currentItem(Items item ){
    _currentItem = item;
    notifyListeners();
  }

}