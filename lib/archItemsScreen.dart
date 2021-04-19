import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'detailsScreenForAdmin.dart';
class ArchItemsScreen extends StatefulWidget {
  static String id = 'ArchItemsScreen';
  @override
  _ArchItemsScreenState createState() => _ArchItemsScreenState();
}

class _ArchItemsScreenState extends State<ArchItemsScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool inActive = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Center(child: Text('العناصر المحذوفة')),

      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('archItems').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data.docs.length == 0) {
                    return Center(
                      child: Text(
                        'لاتوجد منتجات مؤرشفة حتى الآن',
                        style: TextStyle(color: Colors.black54, fontSize: 17),
                      ),
                    );
                  } else {
                    return Directionality(
                      textDirection: TextDirection.rtl,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot document = snapshot.data.docs[index];

                            final image =  document.data()['imageUrl'];
                            final owner = document.data()['uid'];
                            final nameOfProduct = document.data()['name'];
                            final city = document.data()['city'];
                            final details = document.data()['details'];
                            final createdOn = document.data()['createdOn'];
                            final type = document.data()['type'];
                            final category = document.data()['category'];
                            final price = document.data()['price'];
                            final docId = document.data()['documentId'];
                            final name = document.data()['Full_Name'];
                            return ListTile(
                              leading: Image.network(
                                image[0],
                                width: 120.0,
                                fit: BoxFit.fitWidth,
                              ),
                              title: Text(nameOfProduct),
                              subtitle: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(type),
                                  FlatButton(
                                    child: Text(
                                      name,
                                      style: TextStyle(
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (inActive == true) {
                                          // this will lead to block user and prevent him from login
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(owner)
                                              .update({
                                            'In-active': false
                                          }).catchError((e) => print(e));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text('تم حظر المستخدم'),
                                          ));

                                          inActive = false;
                                        } else {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(owner)
                                              .update({
                                            'In-active': true
                                          }).catchError((e) => print(e));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content:
                                            Text('تم رفع الحظر المستخدم'),
                                          ));

                                          inActive = true;
                                        }
                                      });
                                    },
                                  ),

                                  Container(
                                    padding: EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                      color: Colors.red.shade600,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(
                                          Icons.location_on_rounded,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          city,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              onTap: (){
                                if(type == 'تبرع'){
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => DetailsScreenForAdmin(
                                        nameOfProduct: nameOfProduct,
                                        ownerId: owner,
                                        ownerName: name,
                                        createdOn: createdOn,
                                        details: details,
                                        type: type,
                                        imgList: image,
                                      )
                                  ));
                                }else{
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => DetailsScreenForAdmin(
                                        nameOfProduct: nameOfProduct,
                                        ownerId: owner,
                                        ownerName: name,
                                        createdOn: createdOn,
                                        details: details,
                                        type: type,
                                        price: price,
                                        imgList: image,
                                      )
                                  ));
                                }

                              },
                            );
                          },
                        ),
                      ),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
