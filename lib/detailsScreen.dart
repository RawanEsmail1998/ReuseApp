import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reuse_app/item_notifier.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'auth_provider.dart';

class DetailScreen extends StatefulWidget {
  static String id = 'Item';
  String docId;
  DetailScreen({this.docId});
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  List image;
  String price;
  var a, minPrice;
  var pricePar;
  DateTime date;
  final _formKey = GlobalKey<FormState>();
  String email;
  CollectionReference _auctionItems =
      FirebaseFirestore.instance.collection('auctionItems');
  List<String> Emails = [];
  CollectionReference _donatedItems =
      FirebaseFirestore.instance.collection('donatedItems');
  String docId;

  Future<void> createSubCollectionForAucthion() {
    final useId = FirebaseAuth.instance.currentUser.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(useId)
        .get()
        .then((value) {
      _auctionItems.doc(docId).collection('auctioneer').add({
        'price': pricePar,
        'userId': useId,
        'name': value.data()['Full_Name'],
        'city': value.data()['City'],
        'email': value.data()['email'],
      });
    });
  }

  // اضافة ريكويست
  Future<void> createSubCollectionForDonating() async {
    final useId = FirebaseAuth.instance.currentUser.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(useId)
        .get()
        .then((value) {
      print(value.data()['Full_Name']);
      _donatedItems.doc(docId).collection('requests').add({
        'userId': useId,
        'name': value.data()['Full_Name'],
        'city': value.data()['City'],
        'email': value.data()['email'],
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    ItemNotifier itemNotifier =
        Provider.of<ItemNotifier>(context, listen: false);
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    if(itemNotifier.currentItem.type == 'مزاد'){
      date = itemNotifier.currentItem.createdOn.toDate().add(new Duration(days: itemNotifier.currentItem.duration));
    }

    String validatePrice(String value) {
      setState(() {
        minPrice = int.parse(itemNotifier.currentItem.price);
      });

      if (value.isNotEmpty) {
        a = int.parse(value);
        if (a < minPrice) {
          return 'يجب أن لايقل المبلغ عن الحد الادني';
        } else {
          return null;
        }
      } else {
        return 'الرجاء ادخال رقم';
      }
    }

    // String theLastNumberAution() {
    //   if (pricePar == null) {
    //     return itemNotifier.currentItem.price;
    //   } else {
    //     return '$pricePar';
    //   }
    // }

    List<NetworkImage> list = new List<NetworkImage>();
    docId = itemNotifier.currentItem.documentId;
    image = itemNotifier.currentItem.image;
    for (var i = 0; i < image.length; i++) {
      list.add(NetworkImage(itemNotifier.currentItem.image[i]));
    }

    String isAuction() {
      if (itemNotifier.currentItem.type == 'مزاد') {
        return 'شارك بالمزاد';
      } else {
        return 'ارسل طلب';
      }
    }

    _showDialog() async {
      await showDialog<String>(
        builder: (context) => _SystemPadding(
          child: AlertDialog(
            contentPadding: EdgeInsets.all(16.0),
            content: Row(
              children: [
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      textAlign: TextAlign.end,
                      textDirection: TextDirection.rtl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'ادخل المبلغ',
                        labelStyle: TextStyle(),
                      ),
                      validator: (value) => validatePrice(value),
                      onSaved: (value) => pricePar = int.parse(value),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              FlatButton(
                child: Text('تأكيد'),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    if (pricePar != null && pricePar >= minPrice) {
                      createSubCollectionForAucthion();
                      Navigator.pop(context);
                    }
                    showCompleteAuctionDialog(context);
                  }
                },
              ),
            ],
          ),
        ),
        context: context,
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:  Center(child: Text(itemNotifier.currentItem.name)),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                color: Colors.white,
                child: Center(
                  child: SizedBox(
                    height: 400.0,
                    width: MediaQuery.of(context).size.width,
                    child: Carousel(
                      boxFit: BoxFit.cover,
                      autoplay: false,
                      animationCurve: Curves.fastOutSlowIn,
                      animationDuration: Duration(milliseconds: 1000),
                      dotSize: 6.0,
                      dotIncreasedColor: Color(0xFFFF335C),
                      dotBgColor: Colors.transparent,
                      dotPosition: DotPosition.bottomCenter,
                      dotVerticalPadding: 10.0,
                      showIndicator: true,
                      indicatorBgPadding: 7.0,
                      images: list,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RaisedButton(
                        shape: StadiumBorder(),
                        disabledColor: Color(0xFF027843),
                        child: Text(
                          itemNotifier.currentItem.type,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        )),
                    Text(
                      itemNotifier.currentItem.name,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
              ),
              if (itemNotifier.currentItem.type == 'مزاد') ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          color: Color(0xFF027843),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.monetization_on_outlined,
                              color: Colors.white,
                            ),
                            Text(
                              itemNotifier.currentItem.price,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if(itemNotifier.currentItem.type == 'مزاد')...[
                Padding(
                  padding:  EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('ينتهي في${date.day+1}-${date.month}-${date.year}' , style: TextStyle(
                          color: Colors.red,
                          fontSize: 16.0
                      ),)
                    ],
                  ),
                )
              ],
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'تفاصيل المنتج',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.blue.shade900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 40.0,
                  child: Text(
                    itemNotifier.currentItem.details,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      shape: StadiumBorder(),
                      color: Color(0xFF027843),
                      child: Text(
                        isAuction(), // donating or auction
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () {
                        if (authProvider.isAuthenticated) {
                          if (itemNotifier.currentItem.type == 'مزاد') {
                            final useId = FirebaseAuth.instance.currentUser.uid;
                            if (useId != itemNotifier.currentItem.uid) {
                              _showDialog();
                            } else {
                              //
                              showOwnerDialog(context);
                            }
                          }
                          if (itemNotifier.currentItem.type == 'تبرع') {
                            if (FirebaseAuth.instance.currentUser.uid !=
                                itemNotifier.currentItem.uid) {
                              createSubCollectionForDonating();
                              showDonatingDialog(context);
                            } else {
                              showOwnerDialog(context);
                            }
                          }
                        }
                        if (!authProvider.isAuthenticated) {
                          showAlertDialog(context);
                        }
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("موافق"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Directionality(
          child: Text("غير مسجل"), textDirection: TextDirection.rtl),
      content: Directionality(
          child: Text("يجب تسجيل الدخول حتى تتمكن من استخدام الميزة"),
          textDirection: TextDirection.rtl),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  // show dialog for enter the price

// dialog for conformation the donating process
  showDonatingDialog(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("موافق"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Directionality(
          child: Text("تم ارسال الطلب"), textDirection: TextDirection.rtl),
      content: Directionality(
          child: Text(
              "تم ارسال الطلب لصاحب المنتج وسيتم التواصل معكم في حال الموافقة"),
          textDirection: TextDirection.rtl),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

// dialog for the owner
  showOwnerDialog(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("موافق"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Directionality(
          child: Text("غير مسموح"), textDirection: TextDirection.rtl),
      content: Directionality(
          child: Text("لايمكن لصاحب المنتج المشاركة "),
          textDirection: TextDirection.rtl),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

// dialog for complete auction process
  showCompleteAuctionDialog(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("موافق"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Directionality(
          child: Text("تمت عملية المزايدة"), textDirection: TextDirection.rtl),
      content: Directionality(
          child: Text("مشاركنك تمت وسيتم اعلامك في حال كان المنتج من نصيبك"),
          textDirection: TextDirection.rtl),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        padding: mediaQuery.viewInsets,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}

class sendEmailFromLocalHost extends StatefulWidget {
  @override
  _sendEmailFromLocalHostState createState() => _sendEmailFromLocalHostState();
}

class _sendEmailFromLocalHostState extends State<sendEmailFromLocalHost> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
