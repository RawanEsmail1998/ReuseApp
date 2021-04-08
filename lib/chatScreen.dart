import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'constants2.dart';
import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
AuthProvider authProvider;
User loggedUser;
String _uid = FirebaseAuth.instance.currentUser.uid;

class ChatScreen extends StatefulWidget {
  static String id = 'ChatScreen';
  String receiverId;
  String docId;
  ChatScreen({this.receiverId, this.docId});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();

  void initState() {
    super.initState();
  }

  String documentId(String from, String to) {
    return from.hashCode <= to.hashCode ? from + '_' + to : to + '_' + from;
  }

  String Textmessage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: Center(child: Text('الرسائل الخاصة')),
            backgroundColor: Colors.blue),
        body: SafeArea(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
              StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('messages')
                    .doc(widget.docId)
                    .collection(widget.docId)
                    .orderBy('timeStamp')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.lightBlueAccent,
                      ),
                    );
                  }
                  final messages = snapshot.data.docs.reversed;
                  return Expanded(
                      child: ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    // reverse: true,
                    dragStartBehavior: DragStartBehavior.down,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = snapshot.data.docs[index];
                      String message = document.data()['content'];
                      String senderid = document.data()['fromId'];
                      final Timestamp timestamp =
                          document.data()['timeStamp'] as Timestamp;
                      final DateTime dateTime = timestamp.toDate();
                      final dateString = DateFormat('K:mm').format(dateTime);
                      bool isMe = _uid == senderid ? true : false;
                      return Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Column(
                          crossAxisAlignment: isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              dateString,
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.black54,
                              ),
                            ),
                            Material(
                              borderRadius: isMe
                                  ? BorderRadius.only(
                                      topLeft: Radius.circular(30.0),
                                      bottomLeft: Radius.circular(30.0),
                                      bottomRight: Radius.circular(30.0))
                                  : BorderRadius.only(
                                      bottomLeft: Radius.circular(30.0),
                                      bottomRight: Radius.circular(30.0),
                                      topRight: Radius.circular(30.0),
                                    ),
                              elevation: 5.0,
                              color:
                                  isMe ? Colors.lightBlueAccent : Colors.white,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                child: Text(
                                  message,
                                  style: TextStyle(
                                    color: isMe ? Colors.white : Colors.black54,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ));
                },
              ),
              Container(
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        _firestore
                            .collection('messages')
                            .doc(widget.docId)
                            .collection(widget.docId)
                            .add({
                          'content': messageTextController.text,
                          'fromId': FirebaseAuth.instance.currentUser.uid,
                          'toId': widget.receiverId,
                          'timeStamp': DateTime.now()
                        });
                        messageTextController.clear();
                      },
                      child: Text(
                        'ارسال',
                        style: kSendButtonTextStyle,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        textAlign: TextAlign.end,
                        controller: messageTextController,
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                  ])),
            ])));
  }
}

class MessageBubble extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {}
  MessageBubble({this.sender, this.text, this.isMe});

  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
            elevation: 5.0,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black54,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
