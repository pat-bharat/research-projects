import 'package:flutter/material.dart';

class MyAboutTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AboutListTile(
      applicationIcon: FlutterLogo(
        textColor: Colors.yellow,
      ),
      icon: FlutterLogo(
        textColor: Colors.yellow,
      ),
      aboutBoxChildren: <Widget>[
        SizedBox(
          height: 10.0,
        ),
        Text(
          "TBD",
        ),
        Text(
          "TBD",
        ),
      ],
      applicationName: "Digital Guru",
      applicationVersion: "1.0.1",
      applicationLegalese: "Apache License 2.0",
    );
  }
}
