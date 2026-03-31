import 'package:flutter/material.dart';

buildBusiessDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      children: <Widget>[
        ListTile(
          title: Text("Settinga"),
          trailing: Icon(Icons.arrow_forward),
        ),
        ListTile(
          title: Text("About Us"),
          trailing: Icon(Icons.arrow_forward),
        ),
        ListTile(
          title: Text("Log Out"),
          trailing: Icon(Icons.arrow_forward),
        ),
      ],
    ),
  );
}
