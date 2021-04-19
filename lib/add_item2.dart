import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Rounded_Button.dart';
import 'items.dart';
import 'Home_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_Storage;
import 'package:uuid/uuid.dart' ;
import 'package:uuid/uuid_util.dart';
class AddItem extends StatefulWidget {
  static String id = 'add_item2';
  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  bool uploading = false;
  List<String> _imageUrls = List();
  Items id ;
  double val = 0;
  CollectionReference imgRef;
  firebase_Storage.Reference ref;
  List<File> _image = [];

  final picker = ImagePicker();
  String nameOfItem, details, price;
  final _text = TextEditingController();
  final _details = TextEditingController();
  final _price = TextEditingController();
  bool _validate = false;
  User loggedUser;
  String cityName = "الرياض" ;
  String category = "اثاث منزل" ;
  int duration = 10;
  String itemtype = 'مزاد';
  String _uid = FirebaseAuth.instance.currentUser.uid;
  CollectionReference _auctionItems = FirebaseFirestore.instance.collection('auctionItems');
  var uuid = Uuid();
  void initState() {
    super.initState();
  }

  OnTypeChanged(value) {
    setState(() {
      itemtype = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    var v4 = uuid.v4 ;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(child: Text('أضف منتجك')),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 30.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    new DropdownButton<String>(
                      value: cityName,
                      items: <String>[
                        'جدة',
                        'الرياض',
                        'المدينة',
                        'مكة',
                        'الطائف',
                        'أبها',
                        'الدمام',
                      ].map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          cityName = value;
                        });
                      },
                    ),
                    Text(
                      'تحديد المدينة',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                TextField(
                  controller: _text,
                  onChanged: (value) {
                    setState(() {
                      nameOfItem = value;
                    });
                  },
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    hintText: 'اسم المنتج - العنوان',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    enabledBorder:
                        OutlineInputBorder(borderSide: BorderSide(width: 1.0)),
                    errorText: _validate ? 'هذا الحقل مطلوب' : null,
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.blueAccent, width: 1.0)),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _details,
                  onChanged: (value) {
                    setState(() {
                      details = value;
                    });
                  },
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    hintText: 'تفاصيل المنتج',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    enabledBorder:
                        OutlineInputBorder(borderSide: BorderSide(width: 1.0)),
                    contentPadding: EdgeInsets.symmetric(vertical: 80.0),
                    errorText: _validate ? 'هذا الحقل مطلوب' : null,
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          width: 150.0,
                          child: TextField(
                            controller: _price,
                            onChanged: (value) {
                              setState(() {
                                price = value;
                              });
                            },
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            // only number can be entered.
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1.0)),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 30.0),
                              errorText: _validate ? 'هذا الحقل مطلوب' : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        'ادخل المبلغ المطلوب',
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.ltr,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    new DropdownButton(
                      value: duration,
                      elevation: 16,
                      items: <DropdownMenuItem<int>>[
                        new DropdownMenuItem(child: Text('10'), value: 10),
                        new DropdownMenuItem(child: Text('15'), value: 15),
                        new DropdownMenuItem(child: Text('30'), value: 30),
                      ],
                      onChanged: (int value) {
                        setState(() {
                          duration = value;
                        });
                      },

                    ),
                    Text(
                      'حدد المدة الزمنية',
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    new DropdownButton(
                      value: category,
                      elevation: 16,
                      items:<DropdownMenuItem<String>> [
                        new DropdownMenuItem(child:Text('اثاث منزل') , value: 'اثاث منزل',),
                        new DropdownMenuItem(child:Text('اجهزة') , value: 'اجهزة',),
                        new DropdownMenuItem(child:Text('اغراض مطبخ') , value: 'اغراض مطبخ',)
                      ],
                      onChanged: (String value){
                        setState(() {
                          category = value;
                        });
                      },
                    ),
                    Text(
                      'حدد فئة المنتج',
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
                Stack(
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      itemCount: _image.length + 1,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      itemBuilder: (context, index) {
                        return index == 0
                            ? Center(
                                child: IconButton(
                                  icon: Icon(
                                    Icons.add_a_photo,
                                    color: Color(0xff4072AF),
                                  ),
                                  iconSize: 50.0,
                                  onPressed: () {
                                    chooseImage();
                                  },
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.all(3.0),
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: FileImage(_image[index - 1]),
                                        fit: BoxFit.cover)),
                              );
                      },
                    ),
                    uploading
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(
                                  value: val,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.teal),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                  ],
                ),
                RoundedButton(
                  onPressed: () {
                    setState(() {
                      uploading = true;
                      (_text.text.isEmpty &&
                              _price.text.isEmpty &&
                              _details.text.isEmpty)
                          ? _validate = true
                          : _validate = false;
                      if(_image.isNotEmpty){
                        uploadFile().whenComplete(() => Navigator.pushNamed(context, HomeScreen.id));
                      }
                    });



                  },
                  text: 'التالي',
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image.add(File(pickedFile?.path));
    });
    if (pickedFile.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response != null) {
      setState(() {
        _image.add(File(response.file.path));
      });
    } else {
      print(response.file);
    }
  }

  Future uploadFile() async {
    int i = 1;
    for (var img in _image) {
      setState(() {
        val = i / _image.length;
      });
      ref = firebase_Storage.FirebaseStorage.instance
          .ref()
          .child('images/${Path.basename(img.path)}');
      await ref.putFile(img).whenComplete(() async {
        String imageUrl =   await ref.getDownloadURL();
        setState(() {
          _imageUrls.add(imageUrl);
        });



          i++;
        });

    }
    if (_validate != true && _image.isNotEmpty) {
      var v4 = uuid.v4() ;
      FirebaseFirestore.instance
          .collection('users')
          .doc(_uid)
          .get().then((value) =>
          _auctionItems.doc(v4).set({
            'type': itemtype,
            'uid': _uid,
            'city': cityName,
            'price': price,
            'duration': duration,
            'name': nameOfItem,
            'details': details,
            'category':category,
            'imageUrl': _imageUrls ,
            'createdOn' : Timestamp.now(),
            'documentId' : v4,
            'Full_Name':value.data()['Full_Name'],
            'notClosed':true,
          }),
      );


    }
  }
}
