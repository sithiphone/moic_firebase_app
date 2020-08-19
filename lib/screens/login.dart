import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:moic_firebase_app/models/User.dart';
import 'package:moic_firebase_app/screens/home.dart';
class Login extends StatefulWidget{
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var loggedUser = new User();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
        elevation: 5.0,
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Form(
            child: ListView(
              shrinkWrap: true,
              children: [
                _logo(),
                _textFieldEmail(),
                _textFieldPassword(),
                _buttonSignIn(),
                _buildLine("Do you have an account"),
                _register(),
                _buildLine("Other"),
                _forgotPassword(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _logo() {
    return Hero(
      tag: 'Hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.blue,
          radius: 60.0,
          child: Image.asset("assets/indian.png"),
        ),
      ),
    );
  }

  Widget _textFieldEmail() {
    return Padding(
      padding: EdgeInsets.only(top: 30.0),
      child: TextFormField(
        controller: emailController,
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
        controller: passwordController,
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

  Widget _buttonSignIn() {
    return Padding(
      padding: EdgeInsets.only(top: 16.0),
      child: RaisedButton(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        color: Colors.blue,
        child: Text("Login", style: TextStyle(fontSize: 20.0, color: Colors.white),),
        onPressed: (){
          signIn();
        },
      ),
    );
  }

  Widget _buildLine(String s) {
    return Container(
      margin: EdgeInsets.only(top: 16.0),
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.green[800],),),
          Padding(
            padding: EdgeInsets.all(6.0),
            child: Text(s, style: TextStyle(color: Colors.black87),),
          ),
          Expanded(child: Divider(color: Colors.green[800],),),
        ],
      ),
    );
  }

  Widget _register() {
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
          Navigator.pushNamed(context, "/signup");
        },
      ),
    );
  }

  Widget _forgotPassword() {
    return Padding(
      padding: EdgeInsets.only(top: 16.0),
      child: RaisedButton(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        color: Colors.blue,
        child: Text("Forgot password", style: TextStyle(fontSize: 20.0, color: Colors.white),),
        onPressed: (){},
      ),
    );
  }

  void signIn() async {
    setState(() {
      isLoading = true;
    });
    final AuthResult result = await _auth.signInWithEmailAndPassword(
    email: emailController.text.trim(),
    password: passwordController.text.trim()).catchError((err){
      setState(() {
        isLoading = false;
      });
      print(err.message);
      scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(err.message, style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.red,));});

    if(result != null){
      Firestore.instance.collection('users').where('userid', isEqualTo: result.user.uid).snapshots().listen((data) =>
          data.documents.forEach((doc) => {
            loggedUser.id = doc.documentID,
            loggedUser.name = doc['name'],
            loggedUser.email = doc['email'],
            loggedUser.photo = doc['photo'],
      }));
      setState(() {
        isLoading = false;
      });
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));}
  }
}