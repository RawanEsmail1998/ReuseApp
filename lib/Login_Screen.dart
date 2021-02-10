import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'RegistrationScreen.dart';
import 'loggedUser_Screen.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'Login_Screen' ;
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email , _password ;
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance ;
  User user = FirebaseAuth.instance.currentUser ;
  Future signIn() async{
    _formKey.currentState.save();
    try{
      final currentUser = await _auth.signInWithEmailAndPassword(email: email, password: _password);
      if(currentUser.user.emailVerified){
        Navigator.pushNamed(context, LoggedUser.id);
      }
    }catch(e){
      print(e);
    }
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
                                key: _formKey ,
                                children: <Widget>[
                                  TextField(
                                    autocorrect: true,
                                    textAlign: TextAlign.right,
                                    onChanged: (value){
                                      email = value ;
                                    },
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
                                  TextField(
                                    onChanged: (value){
                                      _password = value ;
                                    },
                                    autocorrect: true,
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
                                      child: FlatButton(
                                        onPressed: signIn,
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
