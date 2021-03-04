import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:reuse_app/add_item2.dart';
import 'Data_Search.dart';
import 'auth_provider.dart';
import 'Login_Screen.dart';
import 'Menu.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'Home_Screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _auth = FirebaseAuth.instance;
  AuthProvider authProvider;
  User loggedUser;
  void initState() {
    super.initState();
    getCurrentUser();
  }

  getCurrentUser() {
    try {
      final user = _auth.currentUser;
      loggedUser = user;
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Center(
          child: Text('Reuse'),
        ),
        backgroundColor: Color(0xff4072AF),
        leading: IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            showSearch(
              context: context,
              delegate: DataSearch(),
            );
          },
        ),
      ),
      endDrawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Color(0xffF7F7F7),
        ),
        child: Drawer(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Color(0xffF7F7F7),
                    image: DecorationImage(
                      image: AssetImage('images/logo_Reuse.jpeg'),
                    ),
                  ),
                  child: Center(
                      child: Text(
                    'Reuse App',
                    style: TextStyle(color: Color(0xff4072AF)),
                  )),
                ),
                if (authProvider.isAuthenticated) ...[
                  ListWidget(
                    icon: Icons.account_circle_sharp,
                    text: 'ملفي الشخصي',
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  ListWidget(
                    icon: Icons.mail_sharp,
                    text: 'الرسائل',
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  ListWidget(
                    icon: Icons.receipt_long_sharp,
                    text: 'الطلبات',
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  ListWidget(
                    icon: Icons.close,
                    text: 'تسجيل الخروج',
                    onPressed: () {
                      Navigator.of(context).pop();
                      authProvider.signOut();
                    },
                  ),
                ],
                if (!authProvider.isAuthenticated) ...[
                  ListTile(
                    leading: Icon(
                      Icons.login,
                      color: Color(0xff4072AF),
                    ),
                    title: Text(
                      'تسجيل الدخول',
                      style: TextStyle(
                          color: Color(0xff4072AF),
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: () async {
                      // go to the login screen..
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, LoginScreen.id);
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      drawerEnableOpenDragGesture: false,
      floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (authProvider.isAuthenticated) ...[
                 Center(
                   child: FloatingActionButton(
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      // add item.
                      // go to the next screen.
                      Navigator.pushNamed(context, AddItem.id);
                    },
                    backgroundColor: Color(0xff4072AF),
                ),
                 ),
            ],
          ],
        ),
      );
  }
}
