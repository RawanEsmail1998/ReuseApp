import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'constants2.dart';
import 'package:flutter/gestures.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_Storage;
import 'package:path/path.dart' as Path;
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
  File _image;
  bool isLoading;
  String imageUrl;
  String message;
  final picker = ImagePicker();
  firebase_Storage.Reference ref;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    //file compression
    ref = firebase_Storage.FirebaseStorage.instance
        .ref()
        .child('images/${Path.basename(_image.path)}');
    await ref.putFile(_image).whenComplete(() async {
      await ref.getDownloadURL().then((value) {
        setState(() {
          imageUrl = value;
        });
      });
    });
  }

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
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.camera_alt),
                onPressed: getImage,
              )
            ],
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
                            DocumentSnapshot document =
                                snapshot.data.docs[index];
                            String message = document.data()['content'];
                            String senderid = document.data()['fromId'];
                            String ReciverId = document.data()['toId'];
                            final imageurl = document.data()['image'];
                            final Timestamp timestamp =
                                document.data()['timeStamp'] as Timestamp;
                            final DateTime dateTime = timestamp.toDate();
                            final dateString =
                                DateFormat('K:mm').format(dateTime);
                            bool isMe = _uid != senderid;
                            if (imageurl == null) {
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
                                                    topLeft:
                                                        Radius.circular(30.0),
                                                    bottomLeft:
                                                        Radius.circular(30.0),
                                                    bottomRight:
                                                        Radius.circular(30.0))
                                                : BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(30.0),
                                                    bottomRight:
                                                        Radius.circular(30.0),
                                                    topRight:
                                                        Radius.circular(30.0),
                                                  ),
                                            elevation: 5.0,
                                            color: isMe
                                                ? Colors.lightBlueAccent
                                                : Colors.white,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10.0,
                                                  horizontal: 20.0),

                                              child: Text(
                                                message,
                                                style: TextStyle(
                                                  color: isMe
                                                      ? Colors.white
                                                      : Colors.black54,
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                              // Image.network(imageUrl, width:200.0, height:200.0),
                                            ))
                                      ]));
                            } else {
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
                                                  topLeft:
                                                      Radius.circular(30.0),
                                                  bottomLeft:
                                                      Radius.circular(30.0),
                                                  bottomRight:
                                                      Radius.circular(30.0))
                                              : BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(30.0),
                                                  bottomRight:
                                                      Radius.circular(30.0),
                                                  topRight:
                                                      Radius.circular(30.0),
                                                ),
                                          elevation: 5.0,
                                          color: isMe
                                              ? Colors.lightBlueAccent
                                              : Colors.white,
                                          child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10.0,
                                                  horizontal: 20.0),
                                              child: Image.network(imageurl)),
                                        )
                                      ]));
                            }
                          }),
                    );
                  }),
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
                          'image': imageUrl,
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

// class MessageBubble extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {}
//   MessageBubble({this.sender, this.text, this.isMe, this.image, this.isText});
//
//   final String sender;
//   final String text;
//   final String image;
//   final bool isMe;
//   final bool isText;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(10.0),
//       child: Column(
//         crossAxisAlignment:
//             isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//         children: <Widget>[
//           Text(
//             sender,
//             style: TextStyle(
//               fontSize: 12.0,
//               color: Colors.black54,
//             ),
//           ),
//           Material(
//             borderRadius: isMe
//                 ? BorderRadius.only(
//                     topLeft: Radius.circular(30.0),
//                     bottomLeft: Radius.circular(30.0),
//                     bottomRight: Radius.circular(30.0))
//                 : BorderRadius.only(
//                     bottomLeft: Radius.circular(30.0),
//                     bottomRight: Radius.circular(30.0),
//                     topRight: Radius.circular(30.0),
//                   ),
//             elevation: 5.0,
//             color: isMe ? Colors.lightBlueAccent : Colors.white,
//             child: Padding(
//                 padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//                 child: isText
//                     ? Text(
//                         text,
//                         style: TextStyle(
//                           color: isMe ? Colors.white : Colors.black54,
//                           fontSize: 15.0,
//                         ),
//                       )
//                     : NetworkImage(image)),
//           ),
//           // Material(
//           //   borderRadius: isMe
//           //       ? BorderRadius.only(
//           //           topLeft: Radius.circular(30.0),
//           //           bottomLeft: Radius.circular(30.0),
//           //           bottomRight: Radius.circular(30.0))
//           //       : BorderRadius.only(
//           //           bottomLeft: Radius.circular(30.0),
//           //           bottomRight: Radius.circular(30.0),
//           //           topRight: Radius.circular(30.0),
//           //         ),
//           //   elevation: 5.0,
//           //   color: isMe ? Colors.lightBlueAccent : Colors.white,
//           //   child: Padding(
//           //     padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//           //     child: Image(
//           //       image: NetworkImage(
//           //         image,
//           //       ),
//           //     ),
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }
// }
