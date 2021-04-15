import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chatScreen.dart';

class RequestsPage extends StatefulWidget {
  static String id = 'RequestsPage';
  // String docId;
  String uid = FirebaseAuth.instance.currentUser.uid;
  final String docId;
  RequestsPage({Key key, @required this.docId}) : super(key: key);
  @override
  _RequestsPageState createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  AuthProvider authProvider;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User loggedUser;
  String _uid = FirebaseAuth.instance.currentUser.uid;

  void initState() {
    super.initState();
  }

  String documentId(String from, String to) {
    return from.hashCode <= to.hashCode ? from + '_' + to : to + '_' + from;
  }

  bool convExist = false;

  Widget build(BuildContext context) {
    var docId = this.widget.docId;
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Center(child: Text('قائمة الطلبات')),
            backgroundColor: Colors.blue,
          ),
          body: StreamBuilder(
              stream: _firestore
                  .collection('/donatedItems')
                  .doc(widget.docId)
                  .collection('/requests')
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
                      'لا يوجد طلبات.',
                      style: TextStyle(color: Colors.black54, fontSize: 17),
                    ),
                  );
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot document = snapshot.data.docs[index];
                        final receiverId = document.data()['userId'];
                        final userName = document.data()['name'];
                        final userCity = document.data()['city'];

                        return Container(
                            width: 400,
                            height: 120,
                            padding: const EdgeInsets.all(2.0),
                            margin: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0xffD0ECE7),
                                border: Border.all(
                                  width: 0.7,
                                  color: Colors.blueGrey,
                                )),
                            child: Column(children: [
                              Text(
                                '$userName طلب من ',
                                style: TextStyle(
                                    fontSize: 23,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '$userCity',
                                style: TextStyle(
                                    fontSize: 19, color: Colors.black),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  FlatButton(
                                      disabledColor: Color(0xFF0B5345),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(30.0)),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              child: Icon(
                                                  Icons.check_box_outlined,
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              'قبول الطلب',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                          ])),
                                  FlatButton(
                                      color: Color(0xff0B5345),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(30.0)),
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection('messages')
                                            .where('allUsers', arrayContains: [
                                              _uid,
                                              receiverId
                                            ])
                                            .get()
                                            .then((value) {
                                              if (value.docs.length < 1) {
                                                setState(() {
                                                  convExist = false;
                                                  docId = documentId(
                                                      FirebaseAuth.instance
                                                          .currentUser.uid,
                                                      receiverId);
                                                });
                                              } else {
                                                setState(() {
                                                  convExist = true;
                                                  docId = value.docs.first.id;
                                                });
                                              }
                                            });
                                        if (convExist) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChatScreen(
                                                          receiverId:
                                                              receiverId,
                                                          docId: docId)));
                                        } else {
                                          _firestore
                                              .collection('messages')
                                              .doc(docId)
                                              .set({
                                            'lastmessage': '',
                                            'sender': FirebaseAuth
                                                .instance.currentUser.uid,
                                            'receiver': receiverId,
                                            'isRead': false,
                                            'time': DateTime.now(),
                                            'allUsers': [
                                              FirebaseAuth
                                                  .instance.currentUser.uid,
                                              receiverId
                                            ],
                                          }).then((value) => {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ChatScreen(
                                                                    receiverId:
                                                                        receiverId,
                                                                    docId:
                                                                        docId)))
                                                  });
                                        }
                                      },
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              child: Icon(Icons.message,
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              'محادثة خاصة',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                          ])),
                                ],
                              )
                            ]));
                      });
                }
              })),
    );
  }
}
