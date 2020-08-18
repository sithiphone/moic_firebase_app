import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseUser user;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLoggedUser();
  }

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

  void getLoggedUser() async {
    user = await _auth.currentUser();
    print("User id: ${user.uid}");
    print("Email: ${user.email}");
  }
}
