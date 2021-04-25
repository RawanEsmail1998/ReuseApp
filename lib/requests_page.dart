import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mailer2/mailer.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chatScreen.dart';

class RequestsPage extends StatefulWidget {
  static String id = 'RequestsPage';
  String nameOfProduct ;
  bool notClosed ;
  // String docId;
  String uid = FirebaseAuth.instance.currentUser.uid;
  final String docId;
  RequestsPage({Key key, @required this.docId , this.nameOfProduct,this.notClosed}) : super(key: key);
  @override
  _RequestsPageState createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  AuthProvider authProvider;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User loggedUser;
  String _uid = FirebaseAuth.instance.currentUser.uid;
  bool disabledButt = false ;
  void initState() {
    super.initState();

  }

  String documentId(String from, String to) {
    return from.hashCode <= to.hashCode ? from + '_' + to : to + '_' + from;
  }

  bool convExist = false;
  sendEmail(String userEmail) async{
    var options = new GmailSmtpOptions()
      ..username = 'reuseapp0@gmail.com'
      ..password = 'r0w21E5Nfoiy';
    var emailTransport = new SmtpTransport(options);
    final message = Envelope()
      ..from =  'reuseapp0@gmail.com'
      ..recipients.add(userEmail)
      ..subject = 'نتيجة التبرع ${widget.nameOfProduct}'
      ..text = 'تم قبول طلبكم وسيتم التواصل معكم من قبل صاحب المنتج';
    // Email it.
    emailTransport.send(message)
        .then((envelope) => print('message sent'))
        .catchError((e) => print('Error occurred: $e'));
  }
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
                     shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot document = snapshot.data.docs[index];
                        final receiverId = document.data()['userId'];
                        final userName = document.data()['name'];
                        final userCity = document.data()['city'];
                        final userEmail = document.data()['email'];
                        return Container(
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
                                  ' طلب من $userName ',
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
                                          color: Color(0xFF0B5345),
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
                                              ]),
                                        onPressed:disabledButt? null: (){
                                            setState(() {
                                              disabledButt = true;
                                            });

                                          sendEmail(userEmail);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text('تم ارسال الرسالة لصاحب الطلب'),
                                          ));
                                          if(widget.notClosed == true){
                                            FirebaseFirestore.instance.collection('donatedItems').doc(docId).update({'notClosed':false}).catchError((e) => print(e));
                                          }
                                        },
                                      ),
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
                              ]),
                            );
                      });
                }
              })),
    );
  }
}
