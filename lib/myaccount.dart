import 'package:flutter/material.dart';

class Myaccount extends StatefulWidget {
  static String id = 'Myaccount';
  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<Myaccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF7F7F7),
      appBar: AppBar(
        title: Center(child: Text('حسابي')),
        backgroundColor: Color(0xff4072AF),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Form(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('أهلًا بك',
                                style: TextStyle(
                                  fontSize: 40,
                                  color: Colors.black,
                                )),
                            CircleAvatar(
                              backgroundImage:
                                  AssetImage('images/logo_Reuse.jpeg'),
                              radius: 30,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Color(0xFF027843),
                                  radius: 30,
                                  child: IconButton(
                                    icon: Icon(Icons.shopping_basket),
                                    color: Colors.white,
                                    iconSize: 45,
                                    onPressed: () {},
                                  ),
                                ),
                                Text(
                                  'طلباتي',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Color(0xFF027843),
                                  radius: 30,
                                  child: IconButton(
                                    icon: Icon(Icons.post_add),
                                    color: Colors.white,
                                    iconSize: 45,
                                    onPressed: () {},
                                  ),
                                ),
                                Text(
                                  'منتجاتي',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Color(0xFF027843),
                                  radius: 30,
                                  child: IconButton(
                                    icon: Icon(Icons.favorite),
                                    color: Colors.white,
                                    iconSize: 45,
                                    onPressed: () {},
                                  ),
                                ),
                                Text(
                                  'مفضلاتي',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
