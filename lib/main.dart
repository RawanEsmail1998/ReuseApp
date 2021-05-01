import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reuse_app/Login_Screen.dart';
import 'myprofile.dart';
import 'package:reuse_app/addAdminScreen.dart';
import 'package:reuse_app/add_item1.dart';
import 'package:reuse_app/add_item2.dart';
import 'package:reuse_app/adminDashbord.dart';
import 'package:reuse_app/archItemsScreen.dart';
import 'package:reuse_app/detailsScreenForAdmin.dart';
import 'package:reuse_app/item_notifier.dart';
import 'package:reuse_app/visitorHomeScreen.dart';
import 'Home_Screen.dart';
import 'package:reuse_app/requests_page.dart';
import 'bids_page.dart';
import 'requests_page.dart';
import 'RegistrationScreen.dart';
import 'donatedItem.dart';
import 'detailsScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'myproducts.dart';
import 'chatScreen.dart';
import 'auth_provider.dart';
import 'allmessages.dart';

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
        ),
        ChangeNotifierProvider<ItemNotifier>(
          create: (_) {
            return ItemNotifier();
          },
        )
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: VisitorHomeScreen.id,
          routes: {
            VisitorHomeScreen.id: (context) => VisitorHomeScreen(),
            LoginScreen.id: (context) => LoginScreen(),
            AdminDashboard.id: (context) => AdminDashboard(),
            DetailsScreenForAdmin.id: (context) => DetailsScreenForAdmin(),
            AddAdminScreen.id: (context) => AddAdminScreen(),
            ArchItemsScreen.id: (context) => ArchItemsScreen(),
            RegistrationScreen.id: (context) => RegistrationScreen(),
            AddItem1.id: (context) => AddItem1(),
            AddItem.id: (context) => AddItem(),
            DonatedItem.id: (context) => DonatedItem(),
            HomeScreen.id: (context) => HomeScreen(),
            MyProducts.id: (context) => MyProducts(),
            RequestsPage.id: (context) => RequestsPage(),
            DetailScreen.id: (context) => DetailScreen(),
            ChatScreen.id: (context) => ChatScreen(),
            Allmessages.id: (context) => Allmessages(),
            BidsPage.id: (context) => BidsPage(),
            MyProfile.id: (context) => MyProfile(),
          }),
    );
  }
}
