import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class AddFood extends StatefulWidget {
  static String id = "add_food_screen";
  @override
  _AddFoodState createState() => _AddFoodState();
}


class _AddFoodState extends State<AddFood> {
  File _image;
  String filename, name, price, old_price;
  Firestore firestore = Firestore.instance;
  Map<String, String> category = new Map<String, String>();
  List<Map> categories = List<Map>();
  String _selectedCategory;

  @override
  void initState() {
    // TODO: implement initState
    getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add food"),
        centerTitle: true,
        elevation: 5.0,
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle, color: Colors.white, size: 40.0,),
            onPressed: () async {
              String photoUrl = await resizeAndUploadImageToFirestorage(_image);
              firestore.collection('foods').add({
                'category' : _selectedCategory,
                'name' : name,
                'price' : price,
                'oldprice' : old_price,
                'photo' : photoUrl,
                'filename' : filename,
                'crated_at' : Timestamp.now()
              }).then((value) => Navigator.pop(context));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _image != null? Container(
                  height: 300.0,
                  child: Image.file(_image),
                ) :_imageFood(),
                _categoryDropdown(),
                _textFieldName(),
                _textFieldPice(),
                _textFieldOldPice(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageFood() {
    return InkWell(
      onTap: getImage,
      child: Container(
        alignment: Alignment.center,
        height: 300.0,
        child: Image.asset("assets/addfood.png"),
      ),
    );
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      filename = basename(_image.path);
    });
  }

  Future getCategory() async {
    Future<QuerySnapshot> querySnapshot = firestore.collection('categories').getDocuments();
    querySnapshot.then((data) =>
      data.documents.forEach((val) {
        category = { 'display': val['name'], 'value': val.documentID,};
        print(category);
        setState(() {
          categories.add(category);
        });
      })
    );
  }

  Widget _categoryDropdown() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: DropDownFormField(
        titleText: 'Food category',
        hintText: 'Please choose one',
        value: _selectedCategory,
        onChanged: (value){
          setState(() {
            _selectedCategory = value;
          });
        },
        onSaved: (value){
          setState(() {
            _selectedCategory = value;
          });
        },
        dataSource: categories,
        textField: 'display',
        valueField: 'value',
      ),
    );
  }

  Widget _textFieldName() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: TextField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: 'Food name'
        ),
        onChanged: (value){
          name = value;
        },
      ),
    );
  }

  Widget _textFieldPice() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: TextField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            hintText: 'Price'
        ),
        onChanged: (value){
          price = value;
        },
      ),
    );
  }

  Widget _textFieldOldPice() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: TextField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            hintText: 'Old price'
        ),
        onChanged: (value){
          old_price = value;
        },
      ),
    );
  }

  resizeAndUploadImageToFirestorage(File file) async{
    final StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(filename);
//    final tempDir = await getTemporaryDirectory();
//    final path = tempDir.path;
//    int rand = new Math.Random().nextInt(100000);
//    Img.Image image = Img.decodeImage(file.readAsBytesSync());
//    Img.Image smallerImage = Img.copyResize(image);
//    var compressedImage = new File('$path/img_$rand.jpg')..writeAsBytesSync(Img.encodeJpg(smallerImage, quality: 85));
    final StorageUploadTask task = firebaseStorageRef.putFile(file);
    var url = await(await task.onComplete).ref.getDownloadURL();
    String photoUrl = url.toString();
    return photoUrl;
  }
}
