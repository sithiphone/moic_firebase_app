import 'package:flutter/material.dart';

class TodoHome extends StatefulWidget {
  @override
  _TodoHomeState createState() => _TodoHomeState();
}

class _TodoHomeState extends State<TodoHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TODO APP"),
        centerTitle: true,
        elevation: 5.0,
      ),
      body: Center(
        child: Text("TODO HOME", style: TextStyle(fontSize: 50.0),),
      ),
    );
  }
}
