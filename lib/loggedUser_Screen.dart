import 'Menu.dart';
import 'Data_Search.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class LoggedUser extends StatefulWidget {
static String id = 'loggedUser_Screen' ;
  @override
  _LoggedUserState createState() => _LoggedUserState();
}

class _LoggedUserState extends State<LoggedUser> {
  final _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void initState(){
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Center(
          child: Text('Reuse'),
        ),
        backgroundColor: Color(0xff4072AF),
        leading: IconButton(icon:Icon(Icons.search) , onPressed: (){
          showSearch(
            context: context,
            delegate: DataSearch(),
          );
        },),
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
                    image:DecorationImage(
                      image: AssetImage('images/logo_Reuse.jpeg') ,
                    ),
                  ),
                  child: Center(child: Text('Reuse App' ,style: TextStyle(color: Color(0xff4072AF)),)),
                ),
                ListWidget(icon:Icons.account_circle_sharp,text: 'ملفي الشخصي',onPressed: (){
                  Navigator.of(context).pop();
                },),
                ListWidget(icon:Icons.mail_sharp,text: 'الرسائل',onPressed: (){
                  Navigator.of(context).pop();
                },),
                ListWidget(icon:Icons.receipt_long_sharp,text: 'الطلبات',onPressed: (){  Navigator.of(context).pop();
                },),
                ListWidget(icon:Icons.close,text: 'تسجيل الخروج',onPressed: (){
                  Navigator.of(context).pop();
                  _auth.signOut();
                },),

              ],
            ),
          ),

        ),
      ),
      drawerEnableOpenDragGesture: false,
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton(
          child:Icon(
            Icons.add,
            color:Colors.white ,
          ),
          onPressed: (){
            // add item.
            // go to the next screen.
          },
          backgroundColor: Color(0xff4072AF),

        ),
      ),
    );
  }
}




