import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:moic_firebase_app/models/food.dart';
import 'package:moic_firebase_app/screens/food/foodHome.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math' as Math;
import 'package:image/image.dart' as Img;


class EditFood extends StatefulWidget {
  static String id = "edit_food_screen";
  String docid, category, name, price, old_price, photo, file_name;
  EditFood({this.docid, this.category, this.name, this.price, this.old_price, this.photo, this.file_name});

  @override
  _EditFoodState createState() => _EditFoodState(docid, category, name, price, old_price, photo, file_name);
}

class _EditFoodState extends State<EditFood> {
  String docid, category, name, price, old_price, photo, file_name, _selectedCategory, new_photo;
  _EditFoodState(this.docid, this.category, this.name, this.price, this.old_price, this.photo, this.file_name);
  bool _isLoading = false;
  File _image;
  Map<String, String> cat = new Map<String, String>();
  List<Map> categories = List<Map>();
  Firestore firestore = Firestore.instance;
  TextEditingController nameController, priceController, oldPriceController;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController(text: name);
    priceController = TextEditingController(text: price);
    oldPriceController = TextEditingController(text: old_price);

    _selectedCategory = category;
    getCategory();
//    print("Categories: $categories");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Edit food"),
        centerTitle: true,
        elevation: 5.0,
        actions: [
          IconButton(
            icon: Icon(Icons.check_circle, color: Colors.white, size: 30.0,),
            onPressed: () async {
              _updateFood(context);
            },
          ),
        ],
      ),
      body: Container(
        child: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _image != null? _selectedImage() : _imageFood(),
                categoryDropdown(),
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



  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      new_photo = basename(_image.path);
    });
  }

  Future getCategory() async {
    Future<QuerySnapshot> querySnapshot = firestore.collection('categories').getDocuments();
    querySnapshot.then((data) =>
        data.documents.forEach((val) {
          cat = { 'display': val['name'], 'value': val.documentID,};
//          print(cat);
          setState(() {
            categories.add(cat);
          });
        })
    );
  }

  Widget categoryDropdown() {
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
        controller: nameController,
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
        controller: priceController,
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
        controller: oldPriceController,
      ),
    );
  }

  resizeAndUploadImageToFirestorage(File file, String new_photo) async{
    final StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(file_name);
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = new Math.Random().nextInt(100000);
    Img.Image image = Img.decodeImage(file.readAsBytesSync());
    Img.Image smallerImage = Img.copyResize(image, height: 300);
    var compressedImage = new File('$path/img_$rand.jpg')..writeAsBytesSync(Img.encodeJpg(smallerImage, quality: 85));
    new_photo != file_name ? FirebaseStorage.instance.ref().child(new_photo).delete() : null;
    final StorageUploadTask task = firebaseStorageRef.putFile(compressedImage);
    var url = await(await task.onComplete).ref.getDownloadURL();
    String photoUrl = url.toString();
    return photoUrl;
  }

  Widget _imageFood() {
    return Stack(
      children: [
        Container(
          alignment: Alignment.center,
          height: 300.0,
          child: Image.network(photo),
        ),
        InkWell(
          onTap: getImage,
          child: Container(
            margin: EdgeInsets.fromLTRB(310.0, 90.0, 0.0, 0.0),
            height: 300.0,
            child: Icon(Icons.add_circle, color: Colors.green, size: 60.0,),
          ),
        ),
      ],
    );
  }

  Widget _selectedImage() {
    return Stack(
      children: [
        Container(
          alignment: Alignment.center,
          height: 300.0,
          child: Image.file(_image),
        ),
        InkWell(
          onTap: getImage,
          child: Container(
            margin: EdgeInsets.fromLTRB(310.0, 90.0, 0.0, 0.0),
            height: 300.0,
            child: Icon(Icons.add_circle, color: Colors.red, size: 60.0,),
          ),
        ),
      ],
    );
  }

  void _updateFood(BuildContext context) async {
    print(_selectedCategory);
    setState(() {
      _isLoading = true;
    });

    if(_image != null){
      String photoUrl = await resizeAndUploadImageToFirestorage(_image, new_photo);
      print("Photo URL: $photoUrl");
      await firestore.collection('foods').document(docid).updateData({
        'name' : name,
        'price' : price,
        'oldprice' : old_price,
        'category' : _selectedCategory,
        'photo' : photoUrl,
        'filename' : file_name,
      }).then((value){
        setState(() {
          _isLoading = false;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) => FoodHome()));
      });
    }else{
      firestore.collection('foods').document(docid).updateData({
        'name' : name,
        'price' : price,
        'oldprice' : old_price,
        'category' : _selectedCategory,
      }).then((value){
        setState(() {
          _isLoading = false;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) => FoodHome()));
      });
    }
    setState(() {
      _isLoading = false;
    });
  }
}
