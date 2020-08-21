import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path/path.dart';


class EditFood extends StatefulWidget {
  static String id = "edit_food_screen";
  String docid, category, name, price, old_price, photo, file_name;
  EditFood({this.docid, this.category, this.name, this.price, this.old_price, this.photo, this.file_name});

  @override
  _EditFoodState createState() => _EditFoodState(docid, category, name, price, old_price, photo, file_name);
}

class _EditFoodState extends State<EditFood> {
  String docid, _category, name, price, old_price, photo, file_name;
  _EditFoodState(this.docid, this._category, this.name, this.price, this.old_price, this.photo, this.file_name);
  bool _isLoading = false;
  File _image;
  Map<String, String> category = new Map<String, String>();
  String _selectedCategory, filename;
  List<Map> categories = List<Map>();
  Firestore firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit food"),
        centerTitle: true,
        elevation: 5.0,
      ),
      body: SafeArea(
        child: ModalProgressHUD(
        inAsyncCall: _isLoading,
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
    final StorageUploadTask task = firebaseStorageRef.putFile(file);
    var url = await(await task.onComplete).ref.getDownloadURL();
    String photoUrl = url.toString();
    return photoUrl;
  }
}
