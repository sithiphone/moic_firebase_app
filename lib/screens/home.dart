import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moic_firebase_app/models/User.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseUser user;
  FirebaseAuth _auth = FirebaseAuth.instance;
  var loggedUser = new User();

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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            color: Colors.white,
            onPressed: (){
              signOut(context);
            },
          ),
        ],
        centerTitle: true,
        elevation: 5.0,
      ),
      body: Center(
        child: Column(
          children: [
            Text("Home screen",
              style: TextStyle(fontSize: 40.0, color: Colors.blue),),
            RaisedButton(
              child: Text("SHOW"),
              onPressed: (){
                print(loggedUser);
              },
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              margin: EdgeInsets.all(0.0),
              accountName: Text("Sithiphone"),
              accountEmail: Text("sithiphone@fe-nuol.edu.la"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("assets/person.png"),
              ),
            ),
            ListTile(
              leading: Icon(Icons.thumbs_up_down),
              title: Text("Todo app"),
              onTap: (){
                Navigator.pushNamed(context, "/todo_home");
              },
            ),
            ListTile(
              title: Text("Menu 1"),
              onTap: (){},
            ),
            ListTile(
              title: Text("Menu 1"),
              onTap: (){},
            ),

          ],
        ),
      ),
    );
  }

  void getLoggedUser() async {
    user = await _auth.currentUser();
    
    Firestore.instance.collection('users').where('userid', isEqualTo: user.uid).snapshots().listen((data) {
      data.documents.forEach((doc) {
        loggedUser.docid = doc['userid'];
        loggedUser.name = doc['name'];
        loggedUser.email = doc['email'];
        loggedUser.photo = doc['photo'];
      });
    });
//    print("User id: ${user.uid}");
//    print("Email: ${user.email}");
  }

  void signOut(BuildContext context) {
    _auth.signOut();
    Navigator.pushReplacementNamed(context, "/login");
  }
}
