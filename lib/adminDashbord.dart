import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reuse_app/Home_Screen.dart';
import 'package:reuse_app/Login_Screen.dart';
import 'package:reuse_app/Menu.dart';
import 'package:reuse_app/addAdminScreen.dart';
import 'package:reuse_app/archItemsScreen.dart';
import 'package:reuse_app/visitorHomeScreen.dart';

import 'auth_provider.dart';
import 'detailsScreenForAdmin.dart';

class AdminDashboard extends StatefulWidget {
  static String id = 'AdminDashboard';
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  bool inActive = true;
  String owner;
  AuthProvider authProvider;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference _archItems =
      FirebaseFirestore.instance.collection('archItems');
  List<NetworkImage> img;
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Center(
          child: Text('شاشة الادارة'),
        ),
      ),
      endDrawer: Drawer(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xffF7F7F7),
                  image: DecorationImage(
                    image: AssetImage('images/logo_Reuse.jpeg'),
                  ),
                ),
                child: Center(
                    child: Text(
                  'Reuse App',
                  style: TextStyle(color: Color(0xff4072AF)),
                )),
              ),
              ListWidget(
                text: 'اضافة ادمن جديد',
                icon: Icons.admin_panel_settings,
                onPressed: () {
                  Navigator.pushNamed(context, AddAdminScreen.id);
                },
              ),
              ListWidget(
                text: 'الأرشيف',
                icon: Icons.archive_rounded,
                onPressed: () {
                  Navigator.pushNamed(context, ArchItemsScreen.id);
                },
              ),
              ListWidget(
                onPressed: () {
                  Navigator.pushNamed(context, VisitorHomeScreen.id);
                  _auth.signOut();
                },
                icon: Icons.close,
                text: 'تسجيل الخروج',
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('auctionItems').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data.docs.length == 0) {
                  return Center(
                    child: Text(
                      'لاتوجد منتجات حتى الآن',
                      style: TextStyle(color: Colors.black54, fontSize: 17),
                    ),
                  );
                } else {
                  return Directionality(
                    textDirection: TextDirection.rtl,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot document = snapshot.data.docs[index];
                          final image = document.data()['imageUrl'];
                          final owner = document.data()['uid'];
                          final nameOfProduct = document.data()['name'];
                          final city = document.data()['city'];
                          final details = document.data()['details'];
                          final createdOn = document.data()['createdOn'];
                          final type = document.data()['type'];
                          final category = document.data()['category'];
                          final duration = document.data()['duration'];
                          final price = document.data()['price'];
                          final docId = document.data()['documentId'];
                          final name = document.data()['Full_Name'];
                          return ListTile(
                            leading: Image.network(
                              image[0],
                              fit: BoxFit.cover,
                            ),
                            title: Text(nameOfProduct),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(type),
                                FlatButton(
                                  child: Text(
                                    name,
                                    style: TextStyle(
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (inActive == true) {
                                        // this will lead to block user and prevent him from login
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(owner)
                                            .update({
                                          'In-active': false
                                        }).catchError((e) => print(e));
                                        Scaffold.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text('تم حظر المستخدم'),
                                        ));

                                        inActive = false;
                                      } else {
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(owner)
                                            .update({
                                          'In-active': true
                                        }).catchError((e) => print(e));
                                        Scaffold.of(context)
                                            .showSnackBar(SnackBar(
                                          content:
                                              Text('تم رفع الحظر المستخدم'),
                                        ));

                                        inActive = true;
                                      }
                                    });
                                  },
                                ),
                                Expanded(
                                  child: IconButton(
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection('auctionItems')
                                          .doc(docId)
                                          .collection('auctioneer')
                                          .doc()
                                          .delete();
                                      FirebaseFirestore.instance
                                          .collection('auctionItems')
                                          .doc(docId)
                                          .delete();
                                      _archItems.doc(docId).set({
                                        'type': type,
                                        'uid': owner,
                                        'city': city,
                                        'price': price,
                                        'duration': duration,
                                        'name': nameOfProduct,
                                        'details': details,
                                        'category': category,
                                        'imageUrl': image,
                                        'createdOn': createdOn,
                                        'documentId': docId,
                                        'Full_Name': name,
                                      });
                                    },
                                    icon: Icon(Icons.archive_rounded),
                                    color: Colors.blue,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    color: Colors.red.shade600,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.location_on_rounded,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        city,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DetailsScreenForAdmin(
                                            nameOfProduct: nameOfProduct,
                                            ownerId: owner,
                                            ownerName: name,
                                            createdOn: createdOn,
                                            details: details,
                                            type: type,
                                            price: price,
                                            imgList: image,
                                          )));
                            },
                          );
                        },
                      ),
                    ),
                  );
                }
              }),
          StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('donatedItems').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data.docs.length == 0) {
                  return Center(
                    child: Text(
                      'لاتوجد منتجات حتى الآن',
                      style: TextStyle(color: Colors.black54, fontSize: 17),
                    ),
                  );
                } else {
                  return Directionality(
                    textDirection: TextDirection.rtl,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot document = snapshot.data.docs[index];

                          final image = document.data()['imageUrl'];
                          final owner = document.data()['uid'];
                          final nameOfProduct = document.data()['name'];
                          final city = document.data()['city'];
                          final details = document.data()['details'];
                          final createdOn = document.data()['createdOn'];
                          final type = document.data()['type'];
                          final category = document.data()['category'];
                          final docId = document.data()['documentId'];
                          final name = document.data()['Full_Name'];
                          return ListTile(
                            leading: Expanded(
                              child: Image.network(
                                image[0],
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(nameOfProduct),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(type),
                                FlatButton(
                                  child: Text(
                                    name,
                                    style: TextStyle(
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (inActive == true) {
                                        // this will lead to block user and prevent him from login
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(owner)
                                            .update({
                                          'In-active': false
                                        }).catchError((e) => print(e));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text('تم حظر المستخدم'),
                                        ));

                                        inActive = false;
                                      } else {
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(owner)
                                            .update({
                                          'In-active': true
                                        }).catchError((e) => print(e));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content:
                                              Text('تم رفع الحظر المستخدم'),
                                        ));

                                        inActive = true;
                                      }
                                    });
                                  },
                                ),
                                Expanded(
                                  child: IconButton(
                                    onPressed: () async {
                                      FirebaseFirestore.instance
                                          .collection('donatedItems')
                                          .doc(docId)
                                          .collection('requests')
                                          .doc()
                                          .delete();
                                      FirebaseFirestore.instance
                                          .collection('donatedItems')
                                          .doc(docId)
                                          .delete();
                                      _archItems.doc(docId).set({
                                        'type': type,
                                        'uid': owner,
                                        'city': city,
                                        'name': nameOfProduct,
                                        'details': details,
                                        'category': category,
                                        'imageUrl': image,
                                        'createdOn': createdOn,
                                        'documentId': docId,
                                        'Full_Name': name,
                                      });
                                    },
                                    icon: Icon(Icons.archive_rounded),
                                    color: Colors.blue,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    color: Colors.red.shade600,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(
                                        Icons.location_on_rounded,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        city,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DetailsScreenForAdmin(
                                            nameOfProduct: nameOfProduct,
                                            ownerId: owner,
                                            ownerName: name,
                                            createdOn: createdOn,
                                            details: details,
                                            type: type,
                                            imgList: image,
                                          )));
                            },
                          );
                        },
                      ),
                    ),
                  );
                }
              }),
        ]),
      ),
    );
  }
}
