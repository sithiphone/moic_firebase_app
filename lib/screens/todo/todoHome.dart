import 'package:flutter/material.dart';

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TODO APP"),
        centerTitle: true,
        elevation: 5.0,
      ),
      body: Center(
        child: Text("TODO HOME", style: TextStyle(fontSize: 50.0),),
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
      case 0 : print("ONE"); break;
      case 1 : print("TWO"); break;
    }
  }
}
