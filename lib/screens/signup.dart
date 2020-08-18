import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moic_firebase_app/models/member.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  var member = Member();
  Member logged = new Member();
  File _image;
  String name;
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
              _buildSelectImage(),
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
      onTap: (){

      },
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

    }
  }
}
