import 'package:flutter/material.dart';
import 'package:moic_firebase_app/screens/todo/todoHome.dart';

class AppDrawer extends StatelessWidget {

  Widget _createDrawerItem(IconData icon, String text, GestureTapCallback onTap){
    return ListTile(
      title: Row(
        children: [
          Icon(icon),
          Padding(padding: EdgeInsets.only(left: 8.0), child: Text(text),),
        ],
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            margin: EdgeInsets.all(0.0),
            accountName: Text("Sithiphone"),
            accountEmail: Text("sithiphone@fe-nuol.edu.la"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage("assets/person.png"),
            ),
          ),
          _createDrawerItem(Icons.exit_to_app, "TODO App", () => Navigator.pushNamed(context, TodoHome.id)),

        ],
      ),
    );
  }
}
