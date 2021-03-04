import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reuse_app/Home_Screen.dart';
import 'RegistrationScreen.dart';
import 'auth_provider.dart';


class LoginScreen extends StatefulWidget {
  static String id = 'Login_Screen' ;
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String  _password ;
  String email ;
  String error = '';
  final _formKey = GlobalKey<FormState>();
  AuthProvider _auth = AuthProvider();
  User user = FirebaseAuth.instance.currentUser ;
  bool emailValid (String email){
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }





  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: Colors.white,
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
        body: Container(
          child: LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints:
                  BoxConstraints(minHeight: viewportConstraints.maxHeight),
                  child: Container(
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            color: Colors.white,
                            height: MediaQuery.of(context).size.height * 0.30,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundImage:
                                    AssetImage('images/logo_Reuse.jpeg'),
                                    radius: 70,
                                  ),
                                  Text(
                                    'مرحبًا بك، قم بتسجيل الدخول',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 27,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                  topRight: Radius.circular(50),
                                ),
                              ),
                              child: Column(
                                children: <Widget>[
                                  Form(
                                    key: _formKey ,
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          textAlign: TextAlign.right,
                                          onSaved: (value){
                                            email = value ;
                                          },
                                          validator:(value) => emailValid(value) ? null : 'الرجاء كتابة بريد صالح' ,
                                          decoration: InputDecoration(
                                            hintText: 'example@gmail.com',
                                            hintStyle: TextStyle(
                                              color: Colors.black,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(20),
                                              borderSide: BorderSide(
                                                color: Theme.of(context).primaryColor,
                                                width: 3,
                                              ),
                                            ),
                                            prefixIcon: IconTheme(
                                              data: IconThemeData(
                                                color: Theme.of(context).primaryColor,
                                              ),
                                              child: Icon(Icons.email),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        TextFormField(
                                          onSaved: (value){
                                            _password = value ;
                                          },
                                          validator:(value) => value.length < 6 ? " يجب ادخال كلمة مرور لايقل طولها عن 6" : null ,
                                          obscureText: true,
                                          textAlign: TextAlign.right,
                                          decoration: InputDecoration(
                                            hintText: '***********',
                                            hintStyle: TextStyle(
                                              color: Colors.black,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(20),
                                              borderSide: BorderSide(
                                                color: Theme.of(context).primaryColor,
                                                width: 3,
                                              ),
                                            ),
                                            prefixIcon: IconTheme(
                                              data: IconThemeData(
                                                color: Theme.of(context).primaryColor,
                                              ),
                                              child: Icon(Icons.lock),
                                            ),
                                          ),

                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          child: TextButton(
                                            child:Text('ليس لديك حساب؟',
                                              style: TextStyle(
                                                color:Color(0xff4072AF) ,
                                                fontSize: 16.0,
                                              ),) ,
                                            onPressed: (){
                                              Navigator.pushNamed(context,RegistrationScreen.id);
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          child: Center(
                                            child: Text(
                                              error,
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 14.0
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Center(
                                            child: FlatButton(
                                              onPressed: () async {
                                                final formState = _formKey.currentState ;
                                                if(formState.validate()){
                                                  formState.save();
                                                  dynamic result = await _auth.signInWithEmailAndPassword(email, _password);
                                                  if(!_auth.isAuthenticated){
                                                    setState(() => error = 'كلمة المرور أو البريد الإلكتروني غير صحيحة');
                                                  }
                                                  else if(result != null){
                                                    Navigator.pushNamed(context, HomeScreen.id);
                                                  }
                                                }
                                              },
                                              padding: EdgeInsets.all(16),
                                              color: Theme.of(context).primaryColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(20),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.arrow_back,
                                                    size: 25,
                                                    color: Colors.white,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 12.0,),

                                      ]

                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
  }
}