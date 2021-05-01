import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reuse_app/Rounded_Button.dart';

import 'auth_provider.dart';
import 'constants.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  String email;
  bool emailValid(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Center(
          child: Text(
            'Reuse',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            children: [
              TextFormField(
                decoration: KTextField.copyWith(hintText: 'البريد الإلكتروني'),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                showCursor: true,
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    emailValid(value) ? null : 'الرجاء ادخال بريد صالح',
                onSaved: (value) => email = value,
              ),
              RoundedButton(
                onPressed: () {
                  final formState = _formKey.currentState;
                  if (formState.validate()) {
                    formState.save();
                    _auth.sendPasswordResetEmail(email: email);
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "تم ارسال رابط استعادة كلمة المرور على البريد الإلكتروني"),
                    ));
                    Navigator.of(context).pop();
                  }
                },
                color: Colors.blue,
                text: 'التالي',
              )
            ],
          ),
        ),
      ),
    );
  }
}
