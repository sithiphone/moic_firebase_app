import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:moic_firebase_app/models/food.dart';
import 'package:moic_firebase_app/screens/AppDrawer.dart';
import 'package:moic_firebase_app/screens/food/addFood.dart';
import 'package:moic_firebase_app/screens/food/editFood.dart';
import 'package:moic_firebase_app/screens/food/foodDetail.dart';

class FoodHome extends StatefulWidget {
  static String id = "food_home_screen";
  @override
  _FoodHomeState createState() => _FoodHomeState();
}

enum ConfirmDelete {CANCEL, OK}

class _FoodHomeState extends State<FoodHome> {
  Firestore firestore = Firestore.instance;
  Map<String, String> food = new Map<String, String>();
  List<Map> foods = new List<Map>();

  @override
  void initState() {
    // TODO: implement initState
    getFoods();
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
                String price = foods[index]['price'];
                String name = foods[index]['name'];
                String foodid = foods[index]['docid'];
                String file_name = foods[index]['filename'];
                String photo = foods[index]['photo'];
                String category = foods[index]['category'];
                String old_price = foods[index]['old_price'];
                return Card(
                  child: Hero(
                    tag: foods[index]['docid'],
                    child: Material(
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return FoodDetial(docid: foodid, category: category, name: name, price: price, old_price: old_price, photo: photo, filename: file_name);
                          }));
                        },
                        child: GridTile(
                          header: Container(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              child: Icon(Icons.edit, color: Colors.green,),
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => EditFood(docid: foodid, category: category, name: name, price: price, old_price: old_price, photo: photo, file_name: file_name)));
                              },
                            ),
                          ),
                          footer: Container(
                            color: Colors.black38,
                            child: ListTile(
                              trailing: InkWell(
                                child: Icon(Icons.delete_forever, color: Colors.red,),
                                onTap: (){
                                  _asyncConfirmDeleteDialog(context, foodid, file_name);
                                },
                              ),
                              title: price != null?Text(price + " LAK", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),):null,
                              subtitle: name != null? Text(name, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.green),): null,
                            ),
                          ),
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
              'filename' : doc['filename'],
              'price' : doc['price'],
              'old_price' : doc['oldprice'],
              'category' : doc['category'].toString(),
              'created_at' : doc['crated_at'].toString(),
            };

            setState(() {
              foods.add(food);
            });

          });
//          print("Size of foods: ${foods.length}");
    });
  }

  Future<ConfirmDelete> _asyncConfirmDeleteDialog(BuildContext context, String docid, String file_name) async {
    return showDialog<ConfirmDelete>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)
            ),
            title: Text('ແຈ້ງເຕືອນການລຶບ'),
            content: Text('ເຈົ້າແນ່ໃຈແລ້ວບໍວ່າຈະລຶບອາຫານນີ້ແທ້?'),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: (){
                  Navigator.of(context).pop(ConfirmDelete.CANCEL);
                  setState(() {

                  });
                },
              ),
              FlatButton(
                child: Text("OK"),
                onPressed: (){
                  firestore.collection('foods').document(docid).delete().then((msg) {
                    setState(() {
                      foods.remove(docid);
                    });
                  });
                  FirebaseStorage.instance.ref().child(file_name).delete();
                  Navigator.of(context).pop(ConfirmDelete.OK);
                },
              ),
            ],
          );
        }
    );
  }


}
