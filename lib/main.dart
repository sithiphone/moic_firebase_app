import 'package:flutter/material.dart';
import 'package:moic_firebase_app/screens/home.dart';
import 'package:moic_firebase_app/screens/login.dart';

void main() => runApp(MaterialApp(
  initialRoute: "/",
  routes: {
    "/" : (context) => Home(),
    "/login" : (context) => Login(),
  },
));