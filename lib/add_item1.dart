import 'package:flutter/material.dart';
import 'package:reuse_app/add_item2.dart';
import 'package:reuse_app/donatedItem.dart';
import 'Rounded_Button.dart';

class AddItem1 extends StatefulWidget {
  static String id = 'add_item1';
  @override
  _AddItem1State createState() => _AddItem1State();
}

class _AddItem1State extends State<AddItem1> {
  String itemtype = 'donateditem';
  OnTypeChanged(value) {
    setState(() {
      itemtype = value;
    });
  }

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
                    ],
                  ),
                  RoundedButton(
                    onPressed: () {
                      setState(() {
                        if(itemtype == 'auctionitem'){
                          Navigator.pushNamed(context, AddItem.id);
                        }
                        if(itemtype == 'donateditem'){
                         Navigator.pushNamed(context, DonatedItem.id);
                        }

                      });
                    },
                    text: 'التالي',
                    color: Color(0xff4072AF),
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
