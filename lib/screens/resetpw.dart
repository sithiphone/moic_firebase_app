import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPw extends StatefulWidget {
  @override
  _ResetPwState createState() => _ResetPwState();
}

class _ResetPwState extends State<ResetPw> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  TextEditingController _emailController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reset password"),
        centerTitle: true,
        elevation: 5.0,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            shrinkWrap: true,
            children: [
              _showKeyImage(),
              _textFieldEmail(),
              _btnSend(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showKeyImage() {
    return Container(
      child: Icon(Icons.vpn_key, size: 100.0, color: Colors.grey[600],),
    );
  }

  Widget _textFieldEmail() {
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

  Widget _btnSend() {
    return Padding(
      padding: EdgeInsets.only(top: 16.0),
      child: RaisedButton(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        color: Colors.blue,
        child: Text("Send", style: TextStyle(fontSize: 20.0, color: Colors.white),),
        onPressed: (){
          resetPassword();
          Navigator.pushNamed(context, "/login");
        },
      ),
    );
  }

  void resetPassword(){
    String email = _emailController.text.trim();
    _auth.sendPasswordResetEmail(email: email).catchError((err){
      print(err.message);
      scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Error: " + err.message, style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.red,));
    });
    scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("We send the detail to email $email Please check your email.",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,));
    Navigator.pop(context);
  }
}
