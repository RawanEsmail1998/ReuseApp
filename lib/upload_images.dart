import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:reuse_app/Home_Screen.dart';
import 'package:reuse_app/Rounded_Button.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_Storage;
import 'package:path/path.dart' as Path;
class UploadImages extends StatefulWidget {
  static String id = 'upload_images' ;
  final String uid ;
  UploadImages({this.uid});
  @override
  _UploadImagesState createState() => _UploadImagesState(this.uid);
}

class _UploadImagesState extends State<UploadImages> {
   _UploadImagesState(this.uid);
  String uid ;
  bool uploading = false ;
  double val = 0 ;
  CollectionReference imgRef ;
  firebase_Storage.Reference ref ;
  List<File> _image = [] ;
  String _uploadFileURL ;
  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('حمل الصور ')),
        backgroundColor: Color(0xff4072AF),
      ),
      body: Container(
        child: Scrollbar(
          thickness: 3.0,
          child: Column(
            children:[
              Expanded(
              child: Stack(
                children:[
                  GridView.builder(
                    itemCount: _image.length + 1,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),itemBuilder: (context,index){
                    return index == 0 ?
                    Center(
                      child: IconButton(
                        icon: Icon(Icons.add_a_photo,
                          color:Color(0xff4072AF),
                        ),
                        iconSize: 50.0,
                        onPressed: (){
                          chooseImage();
                        },
                      ),
                    )
                        : Container(margin: EdgeInsets.all(3.0),
                      decoration: BoxDecoration(image: DecorationImage(image: FileImage(_image[index - 1]), fit: BoxFit.cover)),);

                  },

                  ),
                  uploading?
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              value: val,
                              valueColor:AlwaysStoppedAnimation<Color>(Colors.teal),
                            ),
                          ],
                        ),
                      ):
                      Container(),
                ] ,
              ),
            ),
              Container(
                child: RoundedButton(
                  onPressed: (){
                    setState(() {
                      uploading = true ;
                    });
                    uploadFile().whenComplete(() => Navigator.pushNamed(context, HomeScreen.id));
                  },
                  text: 'التالي',
                  color: Color(0xff4072AF),
                ),
              ),
          ],
          ),
        ),
      ),

      );
  }
  chooseImage() async{

    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image.add(File(pickedFile?.path));
    });
   if(pickedFile.path == null) retrieveLostData() ;
  }
  Future<void> retrieveLostData() async{
   final LostData response = await picker.getLostData() ;
   if(response.isEmpty){
     return ;
   }
   if(response !=null){
    setState(() {
      _image.add(File(response.file.path));

    });
   }else{
     print(response.file);
   }
  }
  Future uploadFile() async{
   int i = 1 ;
    for(var img in _image){
      setState(() {
        val = i / _image.length ;
      });
      ref = firebase_Storage.FirebaseStorage.instance
          .ref()
          .child('images/${Path.basename(img.path)}');
      await ref.putFile(img).whenComplete(() async {
         await ref.getDownloadURL().then((value) {
           _uploadFileURL = value ;
          imgRef.doc(this.uid).set({"url":value}, SetOptions(merge: true));
          i++ ;
        });
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imgRef = FirebaseFirestore.instance.collection('auctionItems')  ;
  }
}
