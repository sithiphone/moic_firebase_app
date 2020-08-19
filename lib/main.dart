import 'package:flutter/material.dart';
import 'package:moic_firebase_app/screens/dashboard.dart';
import 'package:moic_firebase_app/screens/home.dart';
import 'package:moic_firebase_app/screens/login.dart';
import 'package:moic_firebase_app/screens/resetpw.dart';
import 'package:moic_firebase_app/screens/signup.dart';
import 'package:moic_firebase_app/screens/todo/todoHome.dart';

void main() => runApp(MaterialApp(
  initialRoute: "/login",
  routes: {
    "/" : (context) => Home(),
    "/login" : (context) => Login(),
    "/signup" : (context) => Signup(),
    "/dashboard" : (context) => Dashboard(),
    "/resetPW" : (context) => ResetPw(),
    "/todo_home" : (context) => TodoHome(),
  },
));