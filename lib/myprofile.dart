import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_Storage;
import 'package:path/path.dart' as Path;
import 'package:reuse_app/Home_Screen.dart';

class MyProfile extends StatefulWidget {
  static String id = 'MyProfile';

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final myControllerName = TextEditingController();
  final myControllerEmail = TextEditingController();
  final myControllerCity = TextEditingController();
  final myControllerPhone = TextEditingController();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController displaycityController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myControllerName.dispose();
    myControllerEmail.dispose();
    myControllerCity.dispose();
    myControllerPhone.dispose();

    super.dispose();
  }

  AuthProvider authProvider;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User loggedUser;
  String _uid = FirebaseAuth.instance.currentUser.uid;
  File _image;
  bool isLoading;
  String imageUrl;
  String message;
  final picker = ImagePicker();
  firebase_Storage.Reference ref;

  Future getImage() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        maxHeight: 400,
        maxWidth: 400,
        imageQuality: 50);

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
      String url = await ref.getDownloadURL();
      setState(() {
        imageUrl = url;
      });
    });
  }

  String usernewname;
  String usernewemail;
  String usernewphone;
  String usernewCity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body:
            profileView() // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  Widget profileView() {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('users')
            .where('uid', isEqualTo: _uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final DocumentSnapshot document = snapshot.data.docs.single;
            final username = document.data()['Full_Name'];
            final useremail = document.data()['email'];
            final userimage = document.data()['imageURL'];
            final userphone = document.data()['Phone_Number'];
            final userCity = document.data()['City'];
            return Column(children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(30, 50, 30, 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      height: 50,
                      width: 50,
                      child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            size: 24,
                            color: Colors.black54,
                          ),
                          onPressed: () {
                            Navigator.pop(context, HomeScreen.id);
                          }),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    Text(
                      'أهلًا $username',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Container(height: 24, width: 24)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
                child: Stack(
                  children: <Widget>[
                    CircleAvatar(
                        radius: 70,
                        child:_image==null? ClipOval(
                          child: Image(
                            image: AssetImage('images/personimage.png'),
                            height: 150,
                            width: 150,
                            color: Colors.white,
                            fit: BoxFit.cover,
                          ),
                        ):ClipOval(
                          child: Flexible(
                            child: Container(
                              margin: EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: FileImage(_image),
                                      fit: BoxFit.cover)),
                            ),
                          ),
                        ),
                    ),
                    Positioned(
                        bottom: 1,
                        left: 1,
                        child: Container(
                          height: 40,
                          width: 40,
                          child: IconButton(
                            icon: Icon(
                              Icons.add_a_photo,
                              color: Colors.white,
                            ),
                            onPressed: getImage,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                        ))
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.tealAccent,
                          Color.fromRGBO(0, 45, 102, 1)
                        ])),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 25, 20, 4),
                      child: Container(
                        height: 70,
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                  textAlign: TextAlign.right,
                                  controller: myControllerName,
                                  decoration: InputDecoration(
                                      hintText: username,
                                      hintStyle: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 20,
                                      )),
                                  onChanged: (String value) async {
                                    setState(() {
                                      usernewname = value;
                                    });
                                    return usernewname;
                                  }),
                            )),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            border:
                                Border.all(width: 1.0, color: Colors.white70)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 4),
                      child: Container(
                        height: 60,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                  textAlign: TextAlign.right,
                                  controller: myControllerCity,
                                  decoration: InputDecoration(
                                      hintText: userCity,
                                      hintStyle: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 20,
                                      )),
                                  onChanged: (String value) async {
                                    setState(() {
                                      usernewCity = value;
                                    });
                                    return usernewCity;
                                  })),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            border:
                                Border.all(width: 1.0, color: Colors.white70)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 4),
                      child: Container(
                        height: 70,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                  textAlign: TextAlign.right,
                                  controller: myControllerEmail,
                                  decoration: InputDecoration(
                                      hintText: useremail,
                                      hintStyle: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 20,
                                      )),
                                  onChanged: (String value) async {
                                    setState(() {
                                      usernewemail = value;
                                    });
                                    return usernewemail;
                                  })),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            border:
                                Border.all(width: 1.0, color: Colors.white70)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 4),
                      child: Container(
                        height: 70,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                  textAlign: TextAlign.right,
                                  controller: myControllerPhone,
                                  decoration: InputDecoration(
                                      hintText: userphone,
                                      hintStyle: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 20,
                                      )),
                                  onChanged: (String value) async {
                                    setState(() {
                                      usernewphone = value;
                                    });
                                    return usernewphone;
                                  })),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            border:
                                Border.all(width: 1.0, color: Colors.white70)),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          height: 70,
                          width: 200,
                          child: Align(
                            child: TextButton(
                              child: Text(
                                'حفظ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () async {
                                _firestore
                                    .collection('users')
                                    .doc(this._uid)
                                    .update(({
                                      'Full_Name': usernewname != null? this.usernewname:username,
                                      'City':usernewCity != null? this.usernewCity:userCity,
                                      'Phone_Number': usernewphone !=null? this.usernewphone:userphone,
                                      'email':usernewemail !=null? this.usernewemail:useremail
                                    })).whenComplete(() =>
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text('تم تحديث البيانات'),
                                    ))
                                );
                                if(imageUrl != null){
                                  _firestore.collection('users').doc(this._uid).set({
                                    'imageUrl': imageUrl
                                  },SetOptions(merge: true));
                                }

                                // await _firestore
                                //     .collection('users')
                                //     .doc(this._uid)
                                //     .set({'displaypicture': imageUrl});
                                // SetOptions(merge: true);
                              },
                            ),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30),
                              )),
                        ),
                      ),
                    )
                  ],
                ),
              ))
            ]);
          } else {
            return SizedBox();
          }
        });
  }
}
