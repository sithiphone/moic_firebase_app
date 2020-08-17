import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
        elevation: 5.0,
      ),
      body: Center(
        child: Text("Home screen",
          style: TextStyle(fontSize: 40.0, color: Colors.blue),),
      ),
    );
  }
}
