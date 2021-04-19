import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:international_phone_input/international_phone_input.dart';
import 'package:reuse_app/Rounded_Button.dart';
import 'package:reuse_app/adminDashbord.dart';

import 'auth_provider.dart';
import 'constants.dart';

class AddAdminScreen extends StatefulWidget {
  static String id='AddAdminScreen';
  @override
  _AddAdminScreenState createState() => _AddAdminScreenState();
}

class _AddAdminScreenState extends State<AddAdminScreen> {
  CollectionReference userAccount =
  FirebaseFirestore.instance.collection('users');
  final _formKey = GlobalKey<FormState>();
  AuthProvider _auth = AuthProvider();
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

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('اضافة ادمن جديد')),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              TextFormField(
                decoration: KTextField,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                showCursor: true,
                validator: (value) =>
                    value.isEmpty ? 'الرجاء ادخال الاسم' : null,
                onSaved: (value) => fullName = value,
              ),
              SizedBox(height: 16.0,),
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
              SizedBox(height: 16.0,),
              InternationalPhoneInput(
                decoration: KTextField.copyWith(hintText: '(416) 123-4567'),
                onPhoneNumberChange: onPhoneNumberChange,
                initialPhoneNumber: phoneNumber,
                initialSelection: phoneIsoCode,
                enabledCountries: ['+966'],
                showCountryCodes: true,
              ),
              SizedBox(height: 16.0,),
              TextFormField(
                decoration: KTextField.copyWith(hintText: 'المدينة'),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                showCursor: true,
                validator: (value) =>
                    value.isEmpty ? 'الرجاء ادخال المدينة' : null,
                onSaved: (value) => city = value,
              ),
              SizedBox(height: 16.0,),
              TextFormField(
                decoration: KTextField.copyWith(hintText: 'كلمة المرور'),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                showCursor: true,
                obscureText: true,
                validator: (value) => value.length < 6
                    ? 'يجب ادخال كلمة مرور لايقل طولها عن 6'
                    : null,
                onSaved: (value) => _password = value,
              ),
              SizedBox(height: 16.0,),
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
                    dynamic result = await _auth.registerWithEmailAndPassword(email, _password);
                    if (result == null) {
                      setState(() => error = 'البريد مسجل مسبقاً');
                    } else if (result != null) {
                      Future<void> addAdmin() async {
                        FirebaseAuth auth = FirebaseAuth.instance;
                        String uid = auth.currentUser.uid.toString();
                        await userAccount.doc(uid).set({
                          'Full_Name': fullName,
                          'Phone_Number': phoneNumber,
                          'City': city,
                          'uid': uid,
                          'email': email,
                          'role': 'Admin',
                          'In-active': true,
                        });
                      }

                      addAdmin();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "الرجاء النقر على الرابط المرسل على بريدك الإلكتروني لتتمكن من تسجيل الدخول"),
                      ));
                      Navigator.pushNamed(context, AdminDashboard.id);
                    }
                  }
                },
                color: Colors.blue,
                text: 'تسجيل الادمن',
              )
            ],
          ),
        ),
      )),
    );
  }
}
