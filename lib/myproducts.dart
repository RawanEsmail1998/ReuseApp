import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'item_notifier.dart';
import 'requests_page.dart';
import 'detailsScreen.dart';

class MyProducts extends StatefulWidget {
  static String id = 'MyProducts';
  @override
  _MyProductstState createState() => _MyProductstState();
}

class _MyProductstState extends State<MyProducts> {
  AuthProvider authProvider;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User loggedUser;
  String _uid = FirebaseAuth.instance.currentUser.uid;

  void initState() {
    ItemNotifier itemNotifier =
        Provider.of<ItemNotifier>(context, listen: false);
    getItem(itemNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var docId = '';
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    ItemNotifier itemNotifier = Provider.of<ItemNotifier>(context);
    int index;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Center(child: Text('منتجاتي')),
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('donatedItems').snapshots(),
              builder: (context, snapshot) {
                List<Widget> donateditemWidgets = [];
                if (snapshot.hasData) {
                  final myitem = snapshot.data.docs;

                  for (var item in myitem) {
                    final itemname = item.data()['name'];
                    final itemid = item.data()['uid'];
                    docId = item.id;
                    if (itemid == _uid) {
                      final itemWidget1 = Container(
                          width: 400,
                          height: 120,
                          padding: const EdgeInsets.all(5.0),
                          margin: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(7),
                              color: Colors.blueGrey[100],
                              border: Border.all(
                                width: 0.5,
                                color: Colors.blueGrey,
                              )),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'اسم المنتج: $itemname',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[900],
                                      fontSize: 20),
                                ),
                                Text(
                                  'نوع المنتج: تبرع',
                                  style: TextStyle(
                                      color: Colors.blue[900], fontSize: 16),
                                ),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      FlatButton(
                                          color: Colors.teal,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      30.0)),
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, item.id);
                                          },
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.inbox_outlined,
                                                    color: Colors.white),
                                                Text(
                                                  'خذني للمنتج',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                ),
                                              ])),
                                      FlatButton(
                                          color: Colors.teal,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      30.0)),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        RequestsPage(
                                                          docId: docId,
                                                        )));
                                          },
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                    Icons
                                                        .insert_drive_file_outlined,
                                                    color: Colors.white),
                                                Text(
                                                  'الطلبات',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                ),
                                              ])),
                                    ]),
                              ]));
                      donateditemWidgets.add(itemWidget1);
                    } else {
                      final itemWidget1 = Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('you have no items',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 36,
                                ))
                          ]);
                      donateditemWidgets.add(itemWidget1);
                    }
                  }
                }
                return Column(
                  children: donateditemWidgets,
                );
              },
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('auctionItems').snapshots(),
              builder: (context, snapshot) {
                List<Widget> auctionitemWidgets = [];
                if (snapshot.hasData) {
                  final myitem = snapshot.data.docs;

                  for (var item in myitem) {
                    final itemname = item.data()['name'];
                    final itemid = item.data()['uid'];
                    if (itemid == _uid) {
                      final itemWidget2 = Container(
                          width: 400,
                          height: 120,
                          padding: const EdgeInsets.all(5.0),
                          margin: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(7),
                              color: Colors.blueGrey[100],
                              border: Border.all(
                                width: 0.5,
                                color: Colors.blueGrey,
                              )),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'اسم المنتج: $itemname',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[900],
                                      fontSize: 20),
                                ),
                                Text(
                                  'نوع المنتج: مزايدة',
                                  style: TextStyle(
                                      color: Colors.blue[900], fontSize: 16),
                                ),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      FlatButton(
                                          color: Colors.teal,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      30.0)),
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, item.id);
                                          },
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.inbox_outlined,
                                                    color: Colors.white),
                                                Text(
                                                  'خذني للمنتج',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                ),
                                              ])),
                                      FlatButton(
                                          color: Colors.teal,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      30.0)),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.attach_money,
                                                    color: Colors.white),
                                                Text(
                                                  'المزايدات',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                ),
                                              ])),
                                    ]),
                              ]));
                      auctionitemWidgets.add(itemWidget2);
                    }
                  }
                }
                return Column(
                  children: auctionitemWidgets,
                );
              },
            ),
            Container()
          ],
        )));
  }
}
