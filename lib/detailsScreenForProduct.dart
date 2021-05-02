import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class DetailsScreenProduct extends StatefulWidget {
  static String id ='DetailsScreenForProduct';
  String details;
  String type;
  String price;
  String nameOfProduct;
  String ownerName;
  String ownerId;
  List<dynamic> imgList;
  Timestamp createdOn;
  DetailsScreenProduct(
      {this.nameOfProduct,
        this.type,
        this.price,
        this.details,
        this.ownerName,
        this.ownerId,
        this.createdOn,
        this.imgList});
  @override
  _DetailsScreenProductState createState() => _DetailsScreenProductState();
}

class _DetailsScreenProductState extends State<DetailsScreenProduct> {
  List image;
  @override
  Widget build(BuildContext context) {
    List<NetworkImage> list = new List<NetworkImage>();
    // docId = itemNotifier.currentItem.documentId;
    image = widget.imgList;
    for (var i = 0; i < image.length; i++) {
      list.add(NetworkImage(image[i]));
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Center(child: Text('تفاصيل المنتج')),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                color: Colors.white,
                child: Center(
                  child: SizedBox(
                    height: 400.0,
                    width: MediaQuery.of(context).size.width,
                    child: Carousel(
                      boxFit: BoxFit.cover,
                      autoplay: false,
                      animationCurve: Curves.fastOutSlowIn,
                      animationDuration: Duration(milliseconds: 1000),
                      dotSize: 6.0,
                      dotIncreasedColor: Color(0xFFFF335C),
                      dotBgColor: Colors.transparent,
                      dotPosition: DotPosition.bottomCenter,
                      dotVerticalPadding: 10.0,
                      showIndicator: true,
                      indicatorBgPadding: 7.0,
                      images: list,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RaisedButton(
                        shape: StadiumBorder(),
                        disabledColor: Color(0xFF027843),
                        child: Text(
                          widget.type,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        )),
                    Text(
                      widget.nameOfProduct,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.type == 'مزاد') ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          color: Color(0xFF027843),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.monetization_on_outlined,
                              color: Colors.white,
                            ),
                            Text(
                              widget.price,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'تفاصيل المنتج',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.blue.shade900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 100.0,
                  child: Text(
                    widget.details,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
