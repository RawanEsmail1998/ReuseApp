import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reuse_app/Login_Screen.dart';
import 'package:reuse_app/auth_provider.dart';
import 'package:reuse_app/database.dart';
import 'constants.dart';
import 'package:international_phone_input/international_phone_input.dart';
import 'Rounded_Button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'RegistrationScreen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  AuthProvider _auth = AuthProvider();
  final _formKey = GlobalKey<FormState>();
  User user = FirebaseAuth.instance.currentUser;
  Database db = Database();

  String _password;
  String fullName;
  String email;
  String city;
  String phoneNumber;
  String phoneIsoCode;
  String error = ' ';
  Future<void> onPhoneNumberChange(String number,
      String internationalizedPhoneNumber, String isoCode) async {
    setState(() {
      phoneNumber = number;
      phoneIsoCode = isoCode;
    });
  }

  bool emailValid(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final fullNameBuild = TextFormField(
      decoration: KTextField,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
      showCursor: true,
      validator: (value) => value.isEmpty ? 'الرجاء ادخال الاسم' : null,
      onSaved: (value) => fullName = value,
    );
    final emailBuild = TextFormField(
      decoration: KTextField.copyWith(hintText: 'البريد الإلكتروني'),
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
      showCursor: true,
      keyboardType: TextInputType.emailAddress,
      validator:(value) => emailValid(value)?  null : 'الرجاء ادخال بريد صالح',
      onSaved: (value) => email = value,
    );

    final cityBuild = TextFormField(
      decoration: KTextField.copyWith(hintText: 'المدينة'),
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
      showCursor: true,
      validator: (value) => value.isEmpty ? 'الرجاء ادخال المدينة' : null,
      onSaved: (value) => city = value,
    );
    final passwordBuild = TextFormField(
      decoration: KTextField.copyWith(hintText: 'كلمة المرور'),
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
      showCursor: true,
      obscureText: true,
      validator: (value) =>
          value.length < 6 ? 'يجب ادخال كلمة مرور لايقل طولها عن 6' : null,
      onSaved: (value) => _password = value,
    );

    return StreamProvider<QuerySnapshot>.value(
      value: Database().account,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Center(
            child: Text('Reuse'),
          ),
          backgroundColor: Color(0xff4072AF),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 40.0,
                  ),
                  fullNameBuild,
                  SizedBox(
                    height: 16.0,
                  ),
                  emailBuild,
                  SizedBox(
                    height: 16.0,
                  ),
                  passwordBuild,
                  SizedBox(
                    height: 16.0,
                  ),
                  InternationalPhoneInput(
                    decoration: KTextField.copyWith(hintText: '(416) 123-4567'),
                    onPhoneNumberChange: onPhoneNumberChange,
                    initialPhoneNumber: phoneNumber,
                    initialSelection: phoneIsoCode,
                    enabledCountries: ['+966'],
                    showCountryCodes: true,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  cityBuild,
                  Center(
                    child: Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                  ),
                  RoundedButton(
                    onPressed: () async {
                      final formState = _formKey.currentState;
                      if (formState.validate()) {
                        formState.save();
                        dynamic result = await _auth
                            .registerWithEmailAndPassword(email, _password);

                        if (result == null) {
                          setState(() => error = 'البريد مسجل مسبقاً');
                        } else if (result != null) {
                          db.userSetup(fullName, phoneNumber, city, email);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("الرجاء النقر على الرابط المرسل على بريدك الإلكتروني لتتمكن من تسجيل الدخول"),
                              ));
                          Navigator.pushNamed(context, LoginScreen.id);
                        }
                      }
                    },
                    color: Colors.blue,
                    text: 'انشيء حساب جديد',
                  ),
                  SizedBox(
                    height: 12.0,
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





