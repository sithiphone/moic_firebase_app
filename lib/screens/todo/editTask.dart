import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moic_firebase_app/models/Task.dart';

class EditTask extends StatefulWidget {
  Task task;
  EditTask({this.task});

  static String id = "edit_task_screen";
  @override
  _EditTaskState createState() => _EditTaskState(this.task);
}

class _EditTaskState extends State<EditTask> {
  Task task;

  _EditTaskState(this.task);

  Firestore firestor = Firestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    _taskController = new TextEditingController(text: task.task_name);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit task"),
        centerTitle: true,
        elevation: 5.0,
      ),
      body:Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                maxLines: 1,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'ໜ້າວຽກແກ້ໄຂ',
                  icon: Icon(Icons.mode_edit),
                ),
                autofocus: true,
                controller: _taskController,
              ),
              SizedBox(height: 20.0,),
              RaisedButton(
                child: Text("Finish", style: TextStyle(fontSize: 20.0, color: Colors.white),),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                color: Colors.blue,
                onPressed: (){
                  editTask();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void editTask() async {
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      String taskEditText = _taskController.text.trim();
      FirebaseUser _user = await _auth.currentUser();
      await firestor.collection('tasks').document(task.docid).updateData({
        'task' : taskEditText,
        'created_at' : FieldValue.serverTimestamp(),
        'userid' : _user.uid,
      });

      Navigator.pop(context);
    }else{
      print("Task is empty!");
    }
  }
}