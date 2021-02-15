import 'package:flutter/material.dart';
class AddItem extends StatefulWidget {
  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color(0xffF7F7F7),
      appBar: AppBar(
        title: Center(child: Text('أضف منتجك')),
        backgroundColor: Color(0xff4072AF),
      ),
      body: Container(
        child: Row(
          children: [
            Column(
              children: [
                Text('حدد الطريقة'),
              ],
            ),
            Column(
              children: [
                Text('التفاصيل')
              ],
            ),
            Column(),
          ],
        ),
      ),
    );
  }
}
