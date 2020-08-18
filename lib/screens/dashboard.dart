import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: Text("Menu"),
      ),
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: <Widget>[
          FlatButton(
            onPressed: (){
              print("Clicked!");
            },
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Icon(Icons.person, size: 90.0, color: Colors.blue[500],),
//                color: Colors.white60,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue[500],
                      ),
                      borderRadius: BorderRadius.circular(20) // use instead of BorderRadius.all(Radius.circular(20))
                  ),
                ),
                SizedBox(height: 10.0,),
                Text("Profile", style: TextStyle(fontSize: 20.0, color: Colors.blue[500]),),
              ],
            ),
          ),
          FlatButton(
            onPressed: (){
              print("Clicked!");
            },
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Icon(Icons.map, size: 90.0, color: Colors.blue[500],),
//                color: Colors.white60,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue[500],
                      ),
                      borderRadius: BorderRadius.circular(20) // use instead of BorderRadius.all(Radius.circular(20))
                  ),
                ),
                SizedBox(height: 10.0,),
                Text("Map", style: TextStyle(fontSize: 20.0, color: Colors.blue[500]),),
              ],
            ),
          ),
          FlatButton(
            onPressed: (){
              print("Clicked!");
            },
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Icon(Icons.business, size: 90.0, color: Colors.blue[500],),
//                color: Colors.white60,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue[500],
                      ),
                      borderRadius: BorderRadius.circular(20) // use instead of BorderRadius.all(Radius.circular(20))
                  ),
                ),
                SizedBox(height: 10.0,),
                Text("Office", style: TextStyle(fontSize: 20.0, color: Colors.blue[500]),),
              ],
            ),
          ),
          FlatButton(
            onPressed: (){
              print("Clicked!");
            },
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Icon(Icons.settings, size: 90.0, color: Colors.blue[500],),
//                color: Colors.white60,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue[500],
                      ),
                      borderRadius: BorderRadius.circular(20) // use instead of BorderRadius.all(Radius.circular(20))
                  ),
                ),
                SizedBox(height: 10.0,),
                Text("Setting", style: TextStyle(fontSize: 20.0, color: Colors.blue[500]),),
              ],
            ),
          ),
          FlatButton(
            onPressed: (){
              print("Clicked!");
            },
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Icon(Icons.info, size: 90.0, color: Colors.blue[500],),
//                color: Colors.white60,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue[500],
                      ),
                      borderRadius: BorderRadius.circular(20) // use instead of BorderRadius.all(Radius.circular(20))
                  ),
                ),
                SizedBox(height: 10.0,),
                Text("About us", style: TextStyle(fontSize: 20.0, color: Colors.blue[500]),),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
