import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moic_firebase_app/models/food.dart';
import 'package:moic_firebase_app/screens/AppDrawer.dart';
import 'package:moic_firebase_app/screens/food/addFood.dart';

class FoodHome extends StatefulWidget {
  static String id = "food_home_screen";
  @override
  _FoodHomeState createState() => _FoodHomeState();
}

class _FoodHomeState extends State<FoodHome> {
  Firestore firestore = Firestore.instance;
  Map<String, String> food = new Map<String, String>();
  List<Map> foods = new List<Map>();

  @override
  void initState() {
    // TODO: implement initState
//    getFoods();
    Future.delayed(Duration(milliseconds: 500), (){
      getFoods();
    });
  }

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
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2
              ),
              itemCount: foods.length,
              itemBuilder: (context, int index){
                return Card(
                  child: Hero(
                    tag: foods[index]['docid'],
                    child: Material(
                      child: InkWell(
                        onTap: (){},
                        child: GridTile(
                          child: Image.network(foods[index]['photo'], fit: BoxFit.cover,),
                        ),
                      ),
                    ),
                  ),
                );
              }
          ),
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

  Future getFoods() async {
    await firestore.collection('foods').orderBy('crated_at', descending: false)
        .snapshots().forEach((data) {
          foods.clear();
          data.documents.forEach((doc) {
            food = {
              'docid' : doc.documentID,
              'name' : doc['name'],
              'photo' : doc['photo'],
              'file_name' : doc['file_name'],
              'price' : doc['price'],
              'old_price' : doc['oldprice'],
              'category' : doc['category'],
              'created_at' : doc['crated_at'].toString(),
            };

            setState(() {
              foods.add(food);
            });

          });
//          print("Size of foods: ${foods.length}");
    });
  }

}
