import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reuse_app/Login_Screen.dart';
import 'package:reuse_app/add_item2.dart';
import 'package:reuse_app/upload_images.dart';
import 'Home_Screen.dart';
import 'RegistrationScreen.dart';
import 'package:firebase_core/firebase_core.dart';

import 'auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(ReuseApp());
}

class ReuseApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>(
            create: (_) {
              return AuthProvider();
            },
          )
        ],
        child: MaterialApp(initialRoute: HomeScreen.id, routes: {
          HomeScreen.id: (context) => HomeScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
          AddItem.id: (context) => AddItem(),
          UploadImages.id: (context) => UploadImages(),
        }));
  }
}
