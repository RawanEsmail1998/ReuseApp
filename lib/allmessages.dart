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
  var users = FirebaseFirestore.instance.collection('users');
  String senderName = '';
  String receiverName = '';

  getSenderName(String id) async {
    await users.doc(id).get().then((value) {
      setState(() {
        senderName = value.data()['Full_Name'];
      });
    });
  }

  getReceiverName(String id) async {
    await users.doc(id).get().then((value) {
      setState(() {
        receiverName = value.data()['Full_Name'];
      });
    });
  }

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
                  .where('allUsers', arrayContains: _uid)
                  .snapshots(),
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
                        // String senderName = getName(theSender);
                        // String receiverName = getName(theReceiver);
                        // is the sender me ?
                        getReceiverName(theReceiver);
                        getSenderName(theSender);
                        bool isMe = _uid == theSender ? true : false;

                        return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                            docId: docId,
                                            receiverId: theReceiver,
                                          )));
                            },
                            child: Container(
                              width: 400,
                              height: 70,
                              padding: const EdgeInsets.all(3),
                              margin: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.transparent,
                                  border: Border.all(
                                    width: 0.6,
                                    color: Colors.blueGrey,
                                  )),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  children: [
                                    Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            isMe
                                                ? ';$receiverName'
                                                : ';$senderName',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.indigo),
                                          ),
                                          Text(
                                            '$lastMessage:',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ]),
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      backgroundImage:
                                          AssetImage('images/personimage.png'),
                                      radius: 28,
                                    ),
                                  ]),
                            ));
                      });
                } else
                  return SizedBox(
                    child: Text('لا يوجد رسائل '),
                  );
              })),
    );
  }
}
