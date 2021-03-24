import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:reuse_app/add_item2.dart';
import 'package:reuse_app/item_notifier.dart';
import 'Data_Search.dart';
import 'add_item1.dart';
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
  AuthProvider authProvider;
  List<String> collection = ['auctionItems','donatedItems'];
  User loggedUser;
  void initState() {
    ItemNotifier itemNotifier = Provider.of<ItemNotifier>(context, listen:false);
    getItem(itemNotifier);
    super.initState();


  }


  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    ItemNotifier itemNotifier = Provider.of<ItemNotifier>(context);
    return Scaffold(
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
      body: Scrollbar(
        thickness: 3,
        child: SingleChildScrollView(
                 child: Padding(
                   padding:  EdgeInsets.symmetric(horizontal: 10.0),
                   child: Column(
                     children: [
                       GridView.builder(
                         shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                        physics: BouncingScrollPhysics(),
                        itemCount: itemNotifier.itemList.length,
                        itemBuilder: (BuildContext context , int index){
                          return Card(
                            elevation: 0.2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: InkWell(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Image.network(itemNotifier.itemList[index].image[0], fit: BoxFit.cover,),
                                  ),

                                  SizedBox(height: 16.0,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.favorite_border_sharp),
                                        onPressed: (){

                                        },
                                      ),
                                      SizedBox(width: 10.0,),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8),
                                        child: Text(itemNotifier.itemList[index].name,style: TextStyle(fontWeight: FontWeight.bold), textDirection: TextDirection.rtl,),
                                      ),



                                    ],
                                  ),
                                  SizedBox(height: 10.0,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(5.0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                          color: Colors.red.shade600 ,
                                        ),

                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(Icons.location_on_rounded,color: Colors.white,),

                                            Text(
                                              itemNotifier.itemList[index].city,
                                              style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                            ),
                                          ],

                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8),
                                        child: Text(itemNotifier.itemList[index].type, textDirection: TextDirection.rtl,),
                                      ),

                                    ],
                                  ),
                                  SizedBox(height: 10.0,),
                                ],
                              ),
                              onTap: (){

                              },
                            ),
                          );
                        },
                ),
                     ],
                   ),
                 ),
        ),
      ),

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
                      Navigator.pushNamed(context, AddItem1.id);
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
