import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moic_firebase_app/models/User.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math' as Math;
import 'package:image/image.dart' as Img;
import 'package:path/path.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  var member = User();
  User logged = new User();
  File _image;
  String name, filename;
  FirebaseAuth _auth = FirebaseAuth.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign up"),
        centerTitle: true,
        elevation: 5.0,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 30.0,),
              _image == null?_buildSelectImage(): InkWell(
                onTap: getImage,
                child: Center(
                  child: CircleAvatar(
                    backgroundImage: FileImage(_image),
                    radius: 60.0,
                  ),
                ),
              ),
              _buildTextFieldName(),
              _buildTextFieldEmail(),
              _textFieldPassword(),
              _textFieldConfirmPassword(),
              SizedBox(height: 50.0,),
              _buttonRegister(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectImage() {
    return InkWell(
      onTap: getImage,
      child: Column(
        children: [
          Container(
            height: 120.0,
            width:  120.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/add.png"),
                fit: BoxFit.fitWidth
              ),
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldName() {
    return Padding(
      padding: EdgeInsets.only(top: 30.0),
      child: TextFormField(
        controller: _nameController,
        maxLength: 80,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Name',
          icon: Icon(Icons.person, color: Colors.grey
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldEmail() {
    return Padding(
      padding: EdgeInsets.only(top: 30.0),
      child: TextFormField(
        controller: _emailController,
        maxLength: 80,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Email',
          icon: Icon(Icons.email, color: Colors.grey
          ),
        ),
      ),
    );
  }

  Widget _textFieldPassword() {
    return Padding(
      padding: EdgeInsets.only(top: 30.0),
      child: TextFormField(
        controller: _passwordController,
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Password',
          icon: Icon(Icons.vpn_key, color: Colors.grey
          ),
        ),
      ),
    );
  }

  Widget _textFieldConfirmPassword() {
    return Padding(
      padding: EdgeInsets.only(top: 30.0),
      child: TextFormField(
        controller: _confirmPassController,
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Confirm Password',
          icon: Icon(Icons.vpn_key, color: Colors.grey
          ),
        ),
      ),
    );
  }

  Widget _buttonRegister() {
    return Padding(
      padding: EdgeInsets.only(top: 16.0),
      child: RaisedButton(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        color: Colors.blue,
        child: Text("Register", style: TextStyle(fontSize: 20.0, color: Colors.white),),
        onPressed: (){
          signUp();
        },
      ),
    );
  }

  void signUp() async {
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      String name = _nameController.text.trim();
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      String confirmPassword = _confirmPassController.text.trim();
      if(password == confirmPassword && password.length >= 6){
        String photoUrl = await resizeAndUploadImageToFirestorage(_image);
        try{
          FirebaseUser user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: email,
              password: password
          )).user;

          await Firestore.instance.collection('users').add(
            {
              'userid' : user.uid,
              'name' : name,
              'email' : email,
              'photo' : photoUrl,
              'photo_name' : filename
            }
          );

          print("Successful: $user");
        }catch(e){
          print("Registration Fail: $e");
        }
      }else{
        print("Password not match or less than 6.");
      }
    }
  }
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      filename = basename(_image.path);
    });
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
