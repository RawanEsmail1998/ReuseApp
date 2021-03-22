import 'package:flutter/material.dart';
import 'Rounded_Button.dart';

class AddItem1 extends StatefulWidget {
  static String id = 'add_item1';
  @override
  _AddItem1State createState() => _AddItem1State();
}

class _AddItem1State extends State<AddItem1> {
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RoundedButton(
                    onPressed: () {
                      setState(() {});
                    },
                    text: 'التالي',
                    color: Color(0xff4072AF),
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          new DropdownButton<String>(
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
                            onChanged: (_) {},
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
                                leading: Radio(),
                                title: const Text('مزاد',
                                    style: TextStyle(
                                      fontSize: 20,
                                    )),
                              ),
                              ListTile(
                                leading: Radio(),
                                title: const Text('تبرع',
                                    style: TextStyle(
                                      fontSize: 20,
                                    )),
                              ),
                            ],
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
