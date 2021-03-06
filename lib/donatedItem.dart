
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reuse_app/Home_Screen.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_Storage;
import 'package:path/path.dart' as Path;
import 'package:uuid/uuid.dart';
import 'Rounded_Button.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
class DonatedItem extends StatefulWidget {
  static String id = 'donatedItem';
  @override
  _DonatedItemState createState() => _DonatedItemState();
}

class _DonatedItemState extends State<DonatedItem> {
  String nameOfItem, details;
  final _text = TextEditingController();
  final _details = TextEditingController();
  bool _validate = false;
  List<String> _imageUrls = List();
  String cityName = "الرياض" ;
  String category = "اثاث منزل" ;
  String _uid = FirebaseAuth.instance.currentUser.uid;
  CollectionReference _donatedItems =
      FirebaseFirestore.instance.collection('donatedItems');
  bool uploading = false ;
  double val = 0 ;
  CollectionReference imgRef ;
  firebase_Storage.Reference ref ;
  List<File> _image = [] ;
  final picker = ImagePicker();
  var uuid = Uuid();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(child: Text('أضف منتجك')),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Form(
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
                          'جده',
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
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1.0)),
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
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1.0)),
                      contentPadding: EdgeInsets.symmetric(vertical: 80.0),
                      errorText: _validate ? 'هذا الحقل مطلوب' : null,
                    ),
                  ),
                  SizedBox(height: 16.0,),
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
                    onPressed: ()  {
                      setState(() {
                        uploading = true;
                        (_text.text.isEmpty &&
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
      ),
    );
  }
  chooseImage() async{

    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image.add(File(pickedFile?.path));
    });
    if(pickedFile.path == null) retrieveLostData() ;
  }
  Future<void> retrieveLostData() async{
    final LostData response = await picker.getLostData() ;
    if(response.isEmpty){
      return ;
    }
    if(response !=null){
      setState(() {
        _image.add(File(response.file.path));

      });
    }else{
      print(response.file);
    }
  }
  Future uploadFile() async{
    int i = 1 ;
    for(var img in _image){
      setState(() {
        val = i / _image.length ;
      });
      ref = firebase_Storage.FirebaseStorage.instance
          .ref()
          .child('images/${Path.basename(img.path)}');
      await ref.putFile(img).whenComplete(() async {
        String imageUrl =   await ref.getDownloadURL();
        setState(() {
          _imageUrls.add(imageUrl);
        });


          i++ ;
        });


    }
    if (_validate != true) {
      var v4 = uuid.v4() ;
      FirebaseFirestore.instance
          .collection('users')
          .doc(_uid)
          .get().then((value) =>
      _donatedItems.doc(v4).set({
        'type': 'تبرع',
        'uid': _uid,
        'city': cityName,
        'name' : nameOfItem,
        'details': details,
        'imageUrl': _imageUrls ,
        'category':category,
        'createdOn' : Timestamp.now(),
        'documentId' : v4,
        'Full_Name':value.data()['Full_Name'],
        'notClosed':true,
      }),
      );
    }
  }
}
