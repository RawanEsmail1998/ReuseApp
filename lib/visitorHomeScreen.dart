import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Login_Screen.dart';
import 'RegistrationScreen.dart';
import 'auth_provider.dart';
import 'constants.dart';
import 'detailsScreen.dart';
import 'item_notifier.dart';

class VisitorHomeScreen extends StatefulWidget {
  static String id = 'VisitorHomeScreen';
  @override
  _VisitorHomeScreenState createState() => _VisitorHomeScreenState();
}

class _VisitorHomeScreenState extends State<VisitorHomeScreen> {
  String resultFilter;
  List items = [];
  List filterItems = [];
  String val;
  Timestamp date;
  int length;
  DateTime dateAfterAuction;
  String searshBar = '';
  int duration;
  List<String> countList = ['اثاث منزل', 'ادوات مطبخ', 'اجهزة'];
  List<String> selectedCountList = [];
  void initState() {
    ItemNotifier itemNotifier =
        Provider.of<ItemNotifier>(context, listen: false);
    getItem(itemNotifier);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    ItemNotifier itemNotifier = Provider.of<ItemNotifier>(context);
    void _openFilterDialog() async {
      await FilterListDialog.display(context,
          listData: countList,
          selectedListData: selectedCountList,
          height: 480,
          headlineText: "Select Count",
          searchFieldHintText: "Search Here", choiceChipLabel: (item) {
        return item;
      }, validateSelectedItem: (list, val) {
        return list.contains(val);
      }, onItemSearch: (list, text) {
        // ignore: missing_return
        if (list.any(
            (element) => element.toLowerCase().contains(text.toLowerCase()))) {
          return list
              .where((element) =>
                  element.toLowerCase().contains(text.toLowerCase()))
              .toList();
        }
      }, onApplyButtonClick: (list) {
        if (list != null) {
          setState(() {
            selectedCountList = List.from(list);
          });
        }
        Navigator.pop(context);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Reuse'),
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.filter_alt_outlined),
          onPressed: _openFilterDialog,
        ),
      ),
      backgroundColor: Colors.white,
      endDrawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.white,
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
                ListTile(
                  leading: Icon(
                    Icons.login,
                    color: Colors.blue,
                  ),
                  title: Text(
                    'تسجيل الدخول',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                  onTap: () async {
                    // go to the login screen..
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, LoginScreen.id);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.app_registration,
                    color: Colors.blue,
                  ),
                  title: Text(
                    'انشاء حساب',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                  onTap: () async {
                    // go to the login screen..
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, RegistrationScreen.id);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Scrollbar(
        thickness: 3,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(children: [
              SizedBox(
                height: 10.0,
              ),
              TextField(
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  showCursor: true,
                  decoration: KTextField.copyWith(
                    hintText: 'ابحث عن المنتج',
                    prefixIcon: IconTheme(
                      data: IconThemeData(
                        color: Colors.black45,
                      ),
                      child: Icon(Icons.search),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searshBar = value;
                    });
                  }),
              SizedBox(
                height: 16.0,
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: ListView.builder(
                    shrinkWrap: true,
                    // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //     crossAxisCount: 2,
                    //   childAspectRatio: 1.0
                    // ),
                    physics: BouncingScrollPhysics(),
                    dragStartBehavior: DragStartBehavior.start,
                    clipBehavior: Clip.hardEdge,
                    itemCount:
                        length == null ? itemNotifier.itemList.length : length,
                    itemBuilder: (BuildContext context, int index) {
                      String name = itemNotifier.itemList[index].name;
                      String cat = itemNotifier.itemList[index].category;
                      bool notClose = itemNotifier.itemList[index].notClosed;
                      if (itemNotifier.itemList[index].type == 'مزاد') {
                        duration = itemNotifier.itemList[index].duration;
                        Timestamp date = itemNotifier.itemList[index].createdOn;
                        dateAfterAuction = date.toDate().add(new Duration(
                            days: duration,
                            hours: 0,
                            minutes: 0,
                            milliseconds: 0));
                      }

                      // var dateAfterAuction =  date.add();
                      if (notClose == true) {
                        print(dateAfterAuction);
                        if (name.contains(searshBar)) {
                          if (selectedCountList.contains(cat) ||
                              selectedCountList.isEmpty) {
                            return ListTile(
                              // borderOnForeground: true,
                              // elevation: 0.2,
                              // shape: RoundedRectangleBorder(
                              //   borderRadius: BorderRadius.circular(8.0),
                              // ),
                              // child: InkWell(
                              //   child: Column(
                              //     mainAxisAlignment: MainAxisAlignment
                              //         .center,
                              //     children: [
                              //       Flexible(
                              //         child: Image.network(
                              //           itemNotifier.itemList[index]
                              //               .image[0],
                              //           fit: BoxFit.cover,
                              //         ),
                              //       ),
                              //       SizedBox(
                              //         height: 16.0,
                              //       ),
                              //       Row(
                              //         mainAxisAlignment:
                              //         MainAxisAlignment.spaceBetween,
                              //         children: [
                              //           IconButton(
                              //             icon: Icon(
                              //                 Icons
                              //                     .favorite_border_sharp),
                              //             onPressed: () {},
                              //           ),
                              //           SizedBox(
                              //             width: 10.0,
                              //           ),
                              //           Padding(
                              //             padding:
                              //             EdgeInsets.symmetric(
                              //                 horizontal: 8),
                              //             child: Text(
                              //               itemNotifier.itemList[index]
                              //                   .name,
                              //               style: TextStyle(
                              //                   fontWeight: FontWeight
                              //                       .bold),
                              //               textDirection: TextDirection
                              //                   .rtl,
                              //             ),
                              //           ),
                              //         ],
                              //       ),
                              //       SizedBox(
                              //         height: 10.0,
                              //       ),
                              //       Row(
                              //         mainAxisAlignment:
                              //         MainAxisAlignment.spaceBetween,
                              //         crossAxisAlignment: CrossAxisAlignment
                              //             .end,
                              //         children: [
                              //           Container(
                              //             padding: EdgeInsets.all(5.0),
                              //             decoration: BoxDecoration(
                              //               borderRadius: BorderRadius
                              //                   .all(
                              //                   Radius.circular(20.0)),
                              //               color: Colors.red.shade600,
                              //             ),
                              //             child: Row(
                              //               mainAxisAlignment:
                              //               MainAxisAlignment
                              //                   .spaceEvenly,
                              //               children: [
                              //                 Icon(
                              //                   Icons
                              //                       .location_on_rounded,
                              //                   color: Colors.white,
                              //                 ),
                              //                 Text(
                              //                   itemNotifier
                              //                       .itemList[index]
                              //                       .city,
                              //                   style: TextStyle(
                              //                       color: Colors.white,
                              //                       fontWeight: FontWeight
                              //                           .bold),
                              //                 ),
                              //               ],
                              //             ),
                              //           ),
                              //           Padding(
                              //             padding:
                              //             EdgeInsets.symmetric(
                              //                 horizontal: 8),
                              //             child: Text(
                              //               itemNotifier.itemList[index]
                              //                   .type,
                              //               textDirection: TextDirection
                              //                   .rtl,
                              //             ),
                              //           ),
                              //         ],
                              //       ),
                              //       SizedBox(
                              //         height: 10.0,
                              //       ),
                              //     ],
                              //   ),
                              //   onTap: () {
                              //     itemNotifier.currentItem =
                              //     itemNotifier.itemList[index];
                              //     Navigator.of(context).push(
                              //         MaterialPageRoute(
                              //             builder: (
                              //                 BuildContext context) {
                              //               return DetailScreen();
                              //             }));
                              //   },
                              // ),
                              leading: Image.network(
                                itemNotifier.itemList[index].image[0],
                                width: 120.0,
                                fit: BoxFit.fitWidth,
                              ),
                              title: Text(itemNotifier.itemList[index].name),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(itemNotifier.itemList[index].type),
                                  Container(
                                    padding: EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                      color: Colors.red.shade600,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(
                                          Icons.location_on_rounded,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          itemNotifier.itemList[index].city,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              // trailing: Container(
                              //               padding: EdgeInsets.all(5.0),
                              //               decoration: BoxDecoration(
                              //                 borderRadius: BorderRadius
                              //                     .all(
                              //                     Radius.circular(20.0)),
                              //                 color: Colors.red.shade600,
                              //               ),
                              //               child: Flexible(
                              //                 child: Row(
                              //                   mainAxisAlignment:
                              //                   MainAxisAlignment
                              //                       .spaceEvenly,
                              //                   children: [
                              //                     Icon(
                              //                       Icons
                              //                           .location_on_rounded,
                              //                       color: Colors.white,
                              //                     ),
                              //                     Text(
                              //                       itemNotifier
                              //                           .itemList[index]
                              //                           .city,
                              //                       style: TextStyle(
                              //                           color: Colors.white,
                              //                           fontWeight: FontWeight
                              //                               .bold),
                              //                     ),
                              //                   ],
                              //                 ),
                              //               ),
                              // ),
                              onTap: () {
                                itemNotifier.currentItem =
                                    itemNotifier.itemList[index];
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return DetailScreen();
                                }));
                              },
                            );
                          } else
                            return SizedBox();
                        } else
                          return SizedBox();
                      } else
                        return SizedBox();
                    }),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
