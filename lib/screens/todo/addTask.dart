import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddTask extends StatefulWidget {
  static String id = "addtask_screen";
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final formKey = GlobalKey<FormState>();
  TextEditingController _taskController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore firestore = Firestore.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add task"),
        centerTitle: true,
        elevation: 5.0,
      ),
      body: Form(
        key: formKey,
        child: Container(
          child: Column(
            children: [
              _TextFieldTask(),
              _buttonAddTask(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _TextFieldTask() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: TextFormField(
        controller: _taskController,
        maxLength: 80,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Task to do',
          icon: Icon(Icons.access_alarms, color: Colors.grey
          ),
        ),
      ),
    );
  }

  Widget _buttonAddTask() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: RaisedButton(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        color: Colors.blue,
        child: Text("Add task", style: TextStyle(fontSize: 20.0, color: Colors.white),),
        onPressed: (){
          addTask();
        },
      ),
    );
  }


  Future addTask() async{
    if(formKey.currentState.validate()){
      formKey.currentState.save();
      String task = _taskController.text.trim();
      FirebaseUser _user = await _auth.currentUser();
      await firestore.collection('tasks').add(<String, dynamic>{
        'task' : task,
        'created_at' : FieldValue.serverTimestamp(),
        'userid' : _user.uid});
      Navigator.pop(context);
    }else{
      print("Task is empty!");
    }
  }

}
