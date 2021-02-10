import "package:flutter/material.dart" ;
import 'Data_Search.dart';
import 'Login_Screen.dart';
class HomeScreen extends StatefulWidget {
  static String id = 'Home_Screen' ;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
               ListTile(
                 leading: Icon(Icons.login,
                   color: Color(0xff4072AF),
                 ),
                 title: Text('تسجيل الدخول',
                   style: TextStyle(color: Color(0xff4072AF),
                       fontWeight: FontWeight.bold),
                 ),
                 onTap: () async {
                   // go to the login screen..
                   Navigator.of(context).pop();
                   Navigator.pushNamed(context,LoginScreen.id);

                 },
               ),
             ],
           ),
         ),

       ),
     ),
      drawerEnableOpenDragGesture: false,

    );

  }
}


