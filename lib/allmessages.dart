import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chatScreen.dart';

class Allmessages extends StatefulWidget {
  var senderId;
  static String id = 'Allmessages';
  @override
  _AllmessagesState createState() => _AllmessagesState();
}

class _AllmessagesState extends State<Allmessages> {
  AuthProvider authProvider;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User loggedUser;
  String _uid = FirebaseAuth.instance.currentUser.uid;
  Stream users = FirebaseFirestore.instance.collection('users').snapshots();

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Center(child: Text('الرسائل الخاصة')),
            backgroundColor: Colors.blue,
          ),
          body: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('messages')
                  .where('allUsers', arrayContains: [
                _uid,
              ]).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot document = snapshot.data.docs[index];
                        String theSender = document.data()['sender'];
                        String theReceiver = document.data()['receiver'];
                        String lastMessage = document.data()['lastmessage'];
                        String docId = document.id;

                        return ListTile(
                          title: Text(theSender),
                          trailing: Text(lastMessage),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                          docId: docId,
                                          receiverId: theReceiver,
                                        )));
                          },
                        );
                      });
                } else
                  return SizedBox();
              })),
    );
  }
}
