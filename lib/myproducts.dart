import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'item_notifier.dart';
import 'requests_page.dart';
import 'detailsScreen.dart';
import 'bids_page.dart';

class MyProducts extends StatefulWidget {
  static String id = 'MyProducts';
  @override
  _MyProductstState createState() => _MyProductstState();
}

class _MyProductstState extends State<MyProducts>with TickerProviderStateMixin {
  AuthProvider authProvider;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User loggedUser;
  String _uid = FirebaseAuth.instance.currentUser.uid;
  TabController tabController;

  @override
  void dispose() {
    super.dispose();
  }

  void initState() {
    ItemNotifier itemNotifier =
        Provider.of<ItemNotifier>(context, listen: false);
    getItem(itemNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (tabController == null) {
      tabController = TabController(length: 2, vsync: this);
    }
    var docId;
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    ItemNotifier itemNotifier = Provider.of<ItemNotifier>(context);
    int index;

    return DefaultTabController(
        initialIndex: 1,
        length: 2,
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                centerTitle: true,
                title: Text('منتجاتي'),
                backgroundColor: Colors.blue,
                bottom: TabBar(
                    controller: tabController,
                    indicatorWeight: 2,
                    tabs: <Widget>[
                      Tab(
                        text: 'تبرع',
                      ),
                      Tab(
                        text: 'مزايدة',
                      )
                    ])),
            body: TabBarView(controller: tabController, children: <Widget>[
              StreamBuilder(
                  stream: _firestore
                      .collection('donatedItems')
                      .where('uid', isEqualTo: _uid)
                      .snapshots(),
                  builder: (BuildContext context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.data.docs.length == 0) {
                      return Center(
                        child: Text(
                          'لم تقم بأضافة منتج حتى الآن',
                          style: TextStyle(color: Colors.black54, fontSize: 17),
                        ),
                      );
                    } else {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot document =
                                snapshot.data.docs[index];
                            final itemname = document.data()['name'];
                            final itemdocid = document.data()['documentId'];
                            final status = document.data()['notClosed'];

                            return Container(
                                width: 400,
                                height: 120,
                                padding: const EdgeInsets.all(3),
                                margin: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(13),
                                    color: Color(0xffD0ECE7),
                                    border: Border.all(
                                      width: 0.6,
                                      color: Colors.teal,
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
                                            color: Colors.blue[900],
                                            fontSize: 16),
                                      ),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            FlatButton(
                                                color: Colors.teal,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(30.0)),
                                                onPressed: () {
                                                  itemNotifier.currentItem =
                                                      itemNotifier
                                                          .itemList[index];
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(builder:
                                                          (BuildContext
                                                              context) {
                                                    return DetailScreen();
                                                  }));
                                                },
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
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
                                                        new BorderRadius
                                                            .circular(30.0)),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              RequestsPage(
                                                                docId:
                                                                    itemdocid,
                                                                nameOfProduct:
                                                                    itemname,
                                                                notClosed:
                                                                    status,
                                                              )));
                                                },
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
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
                          });
                    }
                  }),
              StreamBuilder(
                  stream: _firestore
                      .collection('auctionItems')
                      .where('uid', isEqualTo: _uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.data.docs.length == 0) {
                      return Center(
                        child: Text(
                          'لم تقم بأضافة منتج حتى الآن',
                          style: TextStyle(color: Colors.black54, fontSize: 17),
                        ),
                      );
                    } else {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot document =
                                snapshot.data.docs[index];
                            final itemname = document.data()['name'];
                            final itemid = document.data()['uid'];
                            final itemdocid = document.data()['documentId'];
                            final duration = document.data()['duration'];
                            final createdOn = document.data()['createdOn'];
                            final status = document.data()['notClosed'];
                            if (itemid == _uid) {
                              return Container(
                                  width: 400,
                                  height: 120,
                                  padding: const EdgeInsets.all(3),
                                  margin: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(13),
                                      color: Color(0xffD0ECE7),
                                      border: Border.all(
                                        width: 0.6,
                                        color: Colors.teal,
                                      )),
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          'اسم المنتج:$itemname',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue[900],
                                              fontSize: 20),
                                        ),
                                        Text(
                                          'نوع المنتج: مزايدة',
                                          style: TextStyle(
                                              color: Colors.blue[900],
                                              fontSize: 16),
                                        ),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              FlatButton(
                                                  color: Colors.teal,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          new BorderRadius
                                                              .circular(30.0)),
                                                  onPressed: () {
                                                    itemNotifier.currentItem =
                                                        itemNotifier
                                                            .itemList[index];
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                      return DetailScreen();
                                                    }));
                                                  },
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                            Icons
                                                                .inbox_outlined,
                                                            color:
                                                                Colors.white),
                                                        Text(
                                                          'خذني للمنتج',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 20),
                                                        ),
                                                      ])),
                                              FlatButton(
                                                  color: Colors.teal,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          new BorderRadius
                                                              .circular(30.0)),
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    BidsPage(
                                                                      docId:
                                                                          itemdocid,
                                                                      nameOfProduct: itemname,
                                                                      duration: duration,
                                                                      createdOn: createdOn,
                                                                      notClosed: status,
                                                                    )));
                                                  },
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(Icons.attach_money,
                                                            color:
                                                                Colors.white),
                                                        Text(
                                                          'المزايدات',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 20),
                                                        ),
                                                      ])),
                                            ]),
                                      ]));
                            } else
                              return Text('');
                          });
                    }
                  }),
            ])));
  }
}

// class Goods extends StatelessWidget {
//   const Goods({
//     @required this.firestore,
//     @required this.type,
//     @required this.uid,
//     @required this.itemNotifier,
//   });
//
//   final FirebaseFirestore firestore;
//   final String uid;
//   final ItemNotifier itemNotifier;
//   final String type;
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//         stream: firestore.collection('donatedItems').snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           if (snapshot.data.docs.length == 0) {
//             return Center(
//               child: Text(
//                 'لم تقم بأضافة منتج حتى الآن',
//                 style: TextStyle(color: Colors.black54, fontSize: 17),
//               ),
//             );
//           } else {
//             return ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: snapshot.data.docs.length,
//                 itemBuilder: (context, index) {
//                   DocumentSnapshot document = snapshot.data.docs[index];
//                   final itemname = document.data()['name'];
//                   final itemid = document.data()['uid'];
//                   final itemdocid = document.data()['documentId'];
//                   final status = document.data()['notClosed'];
//                   // docId = document.id;
//                   if (itemid == uid) {
//                     return Container(
//                         width: 400,
//                         height: 120,
//                         padding: const EdgeInsets.all(3),
//                         margin: const EdgeInsets.all(6),
//                         decoration: BoxDecoration(
//                             shape: BoxShape.rectangle,
//                             borderRadius: BorderRadius.circular(13),
//                             color: Color(0xffD0ECE7),
//                             border: Border.all(
//                               width: 0.6,
//                               color: Colors.teal,
//                             )),
//                         child: Column(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               Text(
//                                 'اسم المنتج: $itemname',
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.blue[900],
//                                     fontSize: 20),
//                               ),
//                               Text(
//                                 'نوع المنتج: تبرع',
//                                 style: TextStyle(
//                                     color: Colors.blue[900], fontSize: 16),
//                               ),
//                               Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceEvenly,
//                                   children: [
//                                     FlatButton(
//                                         color: Colors.teal,
//                                         shape: RoundedRectangleBorder(
//                                             borderRadius:
//                                                 new BorderRadius.circular(
//                                                     30.0)),
//                                         onPressed: () {
//                                           itemNotifier.currentItem =
//                                               itemNotifier.itemList[index];
//                                           Navigator.of(context).push(
//                                               MaterialPageRoute(builder:
//                                                   (BuildContext context) {
//                                             return DetailScreen();
//                                           }));
//                                         },
//                                         child: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             children: [
//                                               Icon(Icons.inbox_outlined,
//                                                   color: Colors.white),
//                                               Text(
//                                                 'خذني للمنتج',
//                                                 style: TextStyle(
//                                                     color: Colors.white,
//                                                     fontSize: 20),
//                                               ),
//                                             ])),
//                                     FlatButton(
//                                         color: Colors.teal,
//                                         shape: RoundedRectangleBorder(
//                                             borderRadius:
//                                                 new BorderRadius.circular(
//                                                     30.0)),
//                                         onPressed: () {
//                                           Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                   builder: (context) =>
//                                                       RequestsPage(
//                                                         docId: itemdocid,
//                                                         nameOfProduct: itemname,
//                                                         notClosed: status,
//                                                       )));
//                                         },
//                                         child: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             children: [
//                                               Icon(
//                                                   Icons
//                                                       .insert_drive_file_outlined,
//                                                   color: Colors.white),
//                                               Text(
//                                                 'الطلبات',
//                                                 style: TextStyle(
//                                                     color: Colors.white,
//                                                     fontSize: 20),
//                                               ),
//                                             ])),
//                                   ]),
//                             ]));
//                   } else
//                     return Text('');
//                 });
//           }
//         });
//   }
// }
//
