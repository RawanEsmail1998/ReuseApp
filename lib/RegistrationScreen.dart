import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:international_phone_input/international_phone_input.dart';
import 'Rounded_Button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'loggedUser_Screen.dart';

class RegistrationScreen extends StatefulWidget {
static String id = 'RegistrationScreen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();


}

class _RegistrationScreenState extends State<RegistrationScreen>{
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User user = FirebaseAuth.instance.currentUser;
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  CollectionReference _users = FirebaseFirestore.instance.collection('UserAccount');
  String _password , fullName , email , city  ;
  String phoneNumber;
  String phoneIsoCode;
  Future<void> onPhoneNumberChange(String number, String internationalizedPhoneNumber, String isoCode) async {
    setState(() {
      phoneNumber = number;
      phoneIsoCode = isoCode;
    });
  }
  Future<void>signUp() async {
    _formKey.currentState.save();
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: email, password: _password);
      await newUser.user.sendEmailVerification();
       _users.add({
        'Email_Address': email,
        'Full_Name': fullName,
        'Phone_Number':  phoneIsoCode + phoneNumber,
        'city': city,
      });
      if (newUser != null) {
        // if user registed go to the home screen.
        Navigator.pushNamed(context,LoggedUser.id );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fullNameBuild = TextFormField(
      decoration: KTextField  ,
      textDirection: TextDirection.rtl,
      textAlign:TextAlign.right ,
      showCursor: true,
      validator:(value) => value.isEmpty ? 'please Enter your name' : null ,
      onSaved: (value) => fullName = value,
    );
    final emailBuild = TextFormField(
      decoration: KTextField.copyWith(hintText: 'البريد الإلكتروني')  ,
      textDirection: TextDirection.rtl,
      textAlign:TextAlign.right ,
      showCursor: true,
      keyboardType: TextInputType.emailAddress,
      validator:(value) => value.isEmpty ? 'please Enter your email' : null ,
      onSaved: (value) => email = value,
    );

    final cityBuild = TextFormField(
      decoration: KTextField.copyWith(hintText: 'المدينة')  ,
      textDirection: TextDirection.rtl,
      textAlign:TextAlign.right ,
      showCursor: true,
      validator:(value) => value.isEmpty ? 'please Enter your city' : null ,
      onSaved: (value) => city = value,
    );
    final passwordBuild = TextFormField(
      decoration: KTextField.copyWith(hintText:'كلمة المرور')  ,
      textDirection: TextDirection.rtl,
      textAlign:TextAlign.right ,
      showCursor: true,
      obscureText: true,
      validator:(value) => value.isEmpty ? 'please Enter your password' : null ,
      onSaved: (value) => _password = value,
    );


    return Scaffold(
      backgroundColor: Color(0xffF7F7F7),
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
                    enabledCountries: ['+233', '+1', '+973','+20','+964','+965','+971','+963','+968','+974','+962','+966'],
                    showCountryCodes: true,
                ),
                SizedBox(
                  height: 16.0,
                ),
                cityBuild,

                RoundedButton(
                    onPressed: signUp,
                    color: Color(0xff4072AF),
                    text:'انشيء حساب جديد',

                  ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}





