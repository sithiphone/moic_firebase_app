import 'package:flutter/material.dart';

class Login extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
        elevation: 5.0,
      ),
      body: Center(
        child: Text("Login screen",
        style: TextStyle(fontSize: 40.0, color: Colors.blue),),
      ),
    );
  }
}