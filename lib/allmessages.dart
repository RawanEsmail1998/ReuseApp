import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chatScreen.dart';

class Allmessages extends StatefulWidget {
  var senderId;
  String makeitwork;
  static String id = 'Allmessages';
  @override
  _AllmessagesState createState() => _AllmessagesState();
}

class _AllmessagesState extends State<Allmessages> {
  AuthProvider authProvider;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User loggedUser;
  String _uid = FirebaseAuth.instance.currentUser.uid;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Center(child: Text('الرسائل الخاصة')),
            backgroundColor: Colors.blue,
          ),
          body: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('messages').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot document = snapshot.data.docs[index];
                        final thesender = document.data()['sender'];
                        final thereceiver = document.data()['receiver'];
                        if (thereceiver == _uid) {
                          return Container(
                              width: 400,
                              height: 120,
                              padding: const EdgeInsets.all(5.0),
                              margin: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(7),
                                  color: Colors.teal[100],
                                  border: Border.all(
                                    width: 0.5,
                                    color: Colors.blueGrey,
                                  )),
                              child: Column(children: [Text('')]));
                        }
                        return SizedBox();
                      });
                } else
                  return SizedBox();
              })),
    );
  }
}
