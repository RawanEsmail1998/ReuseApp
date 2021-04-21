import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mailer2/mailer.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chatScreen.dart';

class BidsPage extends StatefulWidget {
  static String id = 'RequestsPage';
  String nameOfProduct;
  int duration;
  Timestamp createdOn;
  bool notClosed;
  // String docId;
  String uid = FirebaseAuth.instance.currentUser.uid;
  final String docId;
  BidsPage(
      {Key key,
      @required this.docId,
      this.nameOfProduct,
      this.duration,
      this.createdOn,
      this.notClosed})
      : super(key: key);
  @override
  _BidsPageState createState() => _BidsPageState();
}

class _BidsPageState extends State<BidsPage> {
  bool disabledButt = false;
  DateTime dateAfterAuction;
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
  sendEmail(String userEmail) async {
    var options = new GmailSmtpOptions()
      ..username = 'reuseapp0@gmail.com'
      ..password = 'r0w21E5Nfoiy';
    var emailTransport = new SmtpTransport(options);
    final message = Envelope()
      ..from = 'reuseapp0@gmail.com'
      ..recipients.add(userEmail)
      ..subject = 'نتيجة التبرع ب ${widget.nameOfProduct}'
      ..text = 'تم قبول طلبكم وسيتم التواصل معكم من قبل صاحب المنتج';
    // Email it.
    emailTransport
        .send(message)
        .then((envelope) => print('message sent'))
        .catchError((e) => print('Error occurred: $e'));
  }

  Widget build(BuildContext context) {
    var docId = this.widget.docId;
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Center(child: Text('قائمة المزايدات')),
            backgroundColor: Colors.blue,
          ),
          body: StreamBuilder(
              stream: _firestore
                  .collection('/auctionItems')
                  .doc(widget.docId)
                  .collection('/auctioneer')
                  .orderBy('price', descending: true)
                  .limit(1)
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
                      'لا توجد مزايدات حتى الآن.',
                      style: TextStyle(color: Colors.black54, fontSize: 17),
                    ),
                  );
                } else {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot document = snapshot.data.docs[index];
                        final receiverId = document.data()['userId'];
                        final userName = document.data()['name'];
                        final userCity = document.data()['city'];
                        final userbid = document.data()['price'];
                        final userEmail = document.data()['email'];
                        dateAfterAuction = widget.createdOn
                            .toDate()
                            .add(new Duration(days: widget.duration));
                        if (dateAfterAuction.isBefore(DateTime.now())) {
                          return Container(
                              width: 400,
                              height: 160,
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
                              child: Column(children: [
                                Text(
                                  '$userName',
                                  style: TextStyle(
                                    fontSize: 25,
                                  ),
                                ),
                                Text('بمبلغ:$userbid',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                Text('$userCity'),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    FlatButton(
                                      onPressed: disabledButt
                                          ? null
                                          : () {
                                              setState(() {
                                                disabledButt == true;
                                              });
                                              sendEmail(userEmail);
                                              Scaffold.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                    'تم ارسال الرسالة لصاحب الطلب'),
                                              ));
                                              if (widget.notClosed == true) {
                                                FirebaseFirestore.instance
                                                    .collection('auctionItems')
                                                    .doc(docId)
                                                    .update({
                                                  'notClosed': false
                                                }).catchError((e) => print(e));
                                              }
                                            },
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
                                              'بيع المنتج',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                          ]),
                                    ),
                                    FlatButton(
                                        color: Color(0xFF0B5345),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(
                                                    30.0)),
                                        onPressed: () async {
                                          await FirebaseFirestore.instance
                                              .collection('messages')
                                              .where('allUsers',
                                                  arrayContains: [
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
                                              Icon(Icons.message,
                                                  color: Colors.white),
                                              Text(
                                                'محادثة خاصة',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              ),
                                            ])),
                                  ],
                                ),
                              ]));
                        } else
                          return Text('بالانتظار....');
                      });
                  //   for (var item in myitem) {
                  //
                  //     Widget requestWidget = Container(
                  //         width: 400,
                  //         height: 120,
                  //         padding: const EdgeInsets.all(5.0),
                  //         margin: const EdgeInsets.all(6),
                  //         decoration: BoxDecoration(
                  //             shape: BoxShape.rectangle,
                  //             borderRadius: BorderRadius.circular(7),
                  //             color: Colors.teal[100],
                  //             border: Border.all(
                  //               width: 0.5,
                  //               color: Colors.blueGrey,
                  //             )),
                  //         child: Column(
                  //           children: [
                  //             Text(
                  //               '$userCity',
                  //               style: TextStyle(
                  //                 fontSize: 30,
                  //               ),
                  //             ),
                  //             Text('$userName')
                  //           ],
                  //         ));
                  //     requestsitemWidgets.add(requestWidget);
                  //   }
                  // }
                  // return Column(
                  //   children: requestWidget,
                  // );
                }
              })),
    );
  }
}
