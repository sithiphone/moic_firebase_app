import 'package:cloud_firestore/cloud_firestore.dart';

class Task{
  var docid, userid, task_name;

  static Task fromDocument(DocumentSnapshot doc){
    Task task = Task();
    task.docid = doc.documentID;
    task.userid = doc.data['userid'];
    task.task_name = doc.data['task_name'];
  }

  String toString(){
    return
        "DocId: $docid " +
        "User id: $userid " +
        "Task: $task_name ";
  }
}