import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryHome extends StatefulWidget {
  static String id = "category_home_id";
  @override
  _CategoryHomeState createState() => _CategoryHomeState();
}

class _CategoryHomeState extends State<CategoryHome> {
  Firestore firestore = Firestore.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categories home"),
        centerTitle: true,
        elevation: 5.0,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: StreamBuilder(
          stream: firestore.collection('categories').snapshots(),
          builder: (context, snapshot){
            List<DocumentSnapshot> categories = snapshot.data.documents;
            if(!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.blue,
                ),
              );
            }else{
              return ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index){
                    int no = index + 1;
                    String docid = categories[index].documentID;
                    return Dismissible(
                      key: Key(docid),
                      onDismissed: (direction) async {
                        await firestore.collection('categories').document(docid).delete();
                      },
                      background: Container(color: Colors.red,),
                      child: Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(no.toString()),
                            radius: 16.0,
                          ),
                          title: Text(categories[index].data['name']),
                        ),
                      ),
                    );
                  }
              );
            }
          },
        ),

      ),
    );
  }
}
