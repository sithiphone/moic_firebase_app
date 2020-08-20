import 'package:flutter/material.dart';
import 'package:moic_firebase_app/screens/AppDrawer.dart';
import 'package:moic_firebase_app/screens/food/addFood.dart';

class FoodHome extends StatefulWidget {
  static String id = "food_home_screen";
  @override
  _FoodHomeState createState() => _FoodHomeState();
}

class _FoodHomeState extends State<FoodHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Food"),
        centerTitle: true,
        elevation: 5.0,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16.0),
        ),
      ),
      drawer: AppDrawer(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_circle, size: 50.0, color: Colors.white,),
        onPressed: (){
          Navigator.pushNamed(context, AddFood.id);
        },
      ),
    );
  }
}
