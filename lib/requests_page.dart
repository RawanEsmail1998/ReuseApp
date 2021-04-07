import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chatScreen.dart';

class RequestsPage extends StatefulWidget {
  static String id = 'RequestsPage';
  var docId;
  RequestsPage({this.docId});
  @override
  _RequestsPageState createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  AuthProvider authProvider;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User loggedUser;
  String _uid = FirebaseAuth.instance.currentUser.uid;
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Center(child: Text('قائمة الطلبات')),
            backgroundColor: Colors.blue,
          ),
          body: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('donatedItems')
                  .doc(widget.docId)
                  .collection('requests')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = snapshot.data.docs[index];
                      final itemId = document.data()['userId'];
                      final userName = document.data()['name'];
                      final userCity = document.data()['city'];

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
                          child: Column(
                            children: [
                              Text(
                                '$userCity',
                                style: TextStyle(
                                  fontSize: 30,
                                ),
                              ),
                              Text('$userName'),
                              FlatButton(
                                  color: Colors.teal,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0)),
                                  onPressed: () {
                                    // Navigator.pushNamed(context, ChatScreen.id);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatScreen(
                                                  senderId: itemId,
                                                )));
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
                          ));
                    },
                  );
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
                } else
                  return SizedBox();
              })),
    );
  }
}
