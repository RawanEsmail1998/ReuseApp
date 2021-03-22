import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Rounded_Button.dart';
import 'upload_images.dart';
import 'Home_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddItem extends StatefulWidget {
  static String id = 'add_item2';
  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  String nameOfItem, details, price;
  final _text = TextEditingController();
  final _details = TextEditingController();
  final _price = TextEditingController();
  bool _validate = false;
  final _auth = FirebaseAuth.instance;
  User loggedUser;
  String cityName;
  String itemtype = 'donateditem';

  String _uid = FirebaseAuth.instance.currentUser.uid;
  CollectionReference _donatedItems =
      FirebaseFirestore.instance.collection('donatedItems');
  CollectionReference _auctionItems =
      FirebaseFirestore.instance.collection('auctionItems');
  void initState() {
    super.initState();
  }

  OnTypeChanged(value) {
    setState(() {
      itemtype = value;
    });
  }
  // ////////////////this thing always bring errs///////////////////
  // void getCurrentUser() async {
  //   try {
  //     final user = _auth.currentUser;
  //     if (user != null) {
  //       loggedUser = user;
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  // Future<void> doTheUploadToFirebase() async {
  //   await _users.add({
  //     'the_NameOfItem': nameOfItem,
  //     'the_Details': details,
  //     'the_Price': price,
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF7F7F7),
      appBar: AppBar(
        title: Center(child: Text('أضف منتجك')),
        backgroundColor: Color(0xff4072AF),
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
                  SizedBox(
                    height: 16.0,
                  ),
                  //Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //children: [
                  // Flexible(
                  // child: Align(
                  //  alignment: Alignment.topRight,
                  //child: Container(
                  //  width: 150.0,
                  //  child: TextField(
                  //   controller: _price,
                  //    onChanged: (value) {
                  //    setState(() {
                  //   price = value;
                  //    });
                  //   },
                  //  keyboardType: TextInputType.number,
                  //  inputFormatters: [
                  //    FilteringTextInputFormatter.digitsOnly
                  // ],
                  // only number can be entered.
                  //  decoration: InputDecoration(
                  //   enabledBorder: OutlineInputBorder(
                  //     borderSide: BorderSide(width: 1.0)),
                  //    contentPadding:
                  //     EdgeInsets.symmetric(horizontal: 30.0),
                  //    errorText: _validate ? 'هذا الحقل مطلوب' : null,
                  //    ),
                  //  ),
                  // ),
                  //  ),),
                  //Flexible(
                  //  child: Text(
                  //   'ادخل المبلغ المطلوب',
                  //   textAlign: TextAlign.right,
                  //      textDirection: TextDirection.ltr,
                  //    ),
                  //   ),
                  //  ],
                  //  ),
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'نوع العرض',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ListTile(
                            leading: Radio(
                                onChanged: (value) {
                                  OnTypeChanged(value);
                                },
                                groupValue: itemtype,
                                value: 'auctionitem'),
                            title: const Text('مزاد',
                                style: TextStyle(
                                  fontSize: 20,
                                )),
                          ),
                          ListTile(
                            leading: Radio(
                              groupValue: itemtype,
                              value: 'donateditem',
                              onChanged: (value) {
                                OnTypeChanged(value);
                              },
                            ),
                            title: const Text('تبرع',
                                style: TextStyle(
                                  fontSize: 20,
                                )),
                          ),
                          RoundedButton(
                            onPressed: () {
                              setState(() {
                                (_text.text.isEmpty &&
                                        _details.text.isEmpty &&
                                        _price.text.isEmpty)
                                    ? _validate = true
                                    : _validate = false;
                                if (_validate != true) {
                                  // go to tne next activity
                                  if (itemtype == 'donateditem') {
                                    _donatedItems.add({
                                      'type': itemtype,
                                      'uid': _uid,
                                      'city': cityName,
                                    });
                                  }
                                  if (itemtype == 'auctionitem') {
                                    _auctionItems.add({
                                      'type': itemtype,
                                      'uid': _uid,
                                      'city': cityName,
                                      'price': price
                                    });
                                  }
                                  Navigator.pushNamed(context, UploadImages.id);
                                }
                              });
                            },
                            text: 'التالي',
                            color: Color(0xff4072AF),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
