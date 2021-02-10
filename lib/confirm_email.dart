import 'package:flutter/material.dart';
class ConfirmEmail extends StatelessWidget {
  static String id = 'confirm_email' ;
  @override
  Widget build(BuildContext context) {
    return Container(
      child:Center(
        child: Text('تم ارسال رابط تأكيد التسجيل على البريد الإلكتروني لإتمام عملية التسجيل يرجى النقر على الرابط المرسل.',
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.red ,
        ),),

      ) ,
    );
  }
}
