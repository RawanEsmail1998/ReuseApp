import 'package:flutter/material.dart';
import 'package:reuse_app/Login_Screen.dart';
import 'package:reuse_app/loggedUser_Screen.dart';
import 'Home_Screen.dart';
import 'RegistrationScreen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ReuseApp());
}

class ReuseApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReuseApp',
      theme: ThemeData(
        // This is       the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      initialRoute: HomeScreen.id,
      routes: {
        HomeScreen.id:(context) => HomeScreen(),
        LoginScreen.id: (context)  => LoginScreen(),
        RegistrationScreen.id:(context)  => RegistrationScreen(),
        LoggedUser.id:(context)  => LoggedUser(),
      },
    );
  }
}

