import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moic_firebase_app/models/Task.dart';
import 'package:moic_firebase_app/screens/todo/addTask.dart';

class TodoHome extends StatefulWidget {
  static String id = "todo_home_screen";
  @override
  _TodoHomeState createState() => _TodoHomeState();
}

class _TodoHomeState extends State<TodoHome> {
  int _selectIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold);

  static const List<Widget> _widgetOption = <Widget>[
    Text("Index 0: Add", style: optionStyle,),
    Text("Index 1: Edit", style: optionStyle,),
  ];

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;
  Firestore firestore = Firestore.instance;
  List tasks = new List();
  var deleteItems = new List<String>();

  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      getTask();
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TODO APP"),
        centerTitle: true,
        elevation: 5.0,
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('tasks').orderBy('created_at', descending: false).snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue[500],
              ),
            );
          }else{
            List<DocumentSnapshot> docs_tasks = snapshot.data.documents;
            tasks.clear();
            docs_tasks.forEach((v) {
              Task task = new Task();
              task.docid = v.documentID;
              task.task_name = v.data['task'];
              task.userid = v.data['userid'];
              tasks.add(task);
            });
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index){
                return ListTile(
                  leading: deleteItems.contains(tasks[index].docid)? Icon(Icons.check_box) : Icon(Icons.check_box_outline_blank),
                  title: Text(tasks[index].task_name),
                  subtitle: Text(tasks[index].docid),
                  onTap: (){
                    setState(() {
                      if(deleteItems.contains(tasks[index].docid)){
                      deleteItems.remove(tasks[index].docid);
                      }else{
                        deleteItems.add(tasks[index].docid);
                      }
                      deleteItems.forEach((v) => print(v)); }); },  ); }, );
            }
         }

      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 50.0, color: Colors.white,),
            title: Text("Add"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.remove_circle, size: 50.0, color: Colors.white,),
            title: Text("Delete"),
          ),
        ],
        currentIndex: _selectIndex,
        selectedItemColor: Colors.white,
        backgroundColor: Colors.blue,
        onTap: onItemTapped,
      ),
    );
  }

  void onItemTapped(int index) {
    setState(() {
      _selectIndex = index;
    });
    switch(index){
      case 0 :
        Navigator.pushNamed(context, AddTask.id);
        break;
      case 1 :
        deleteItems.forEach((doc) {
          firestore.collection('tasks').document(doc).delete().then((msg) => deleteItems.remove(doc));
        });
        break;
    }
  }

  Future getTask() async {
    user = await _auth.currentUser();
    QuerySnapshot qn = await firestore.collection('tasks')
        .where('userid', isEqualTo: user.uid).getDocuments();
    for(var doc in qn.documents){
      print(doc.documentID);
    }
  }
}
