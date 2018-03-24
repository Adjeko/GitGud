import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';

// import 'package:location/location.dart';

class EventInfoPage extends StatelessWidget {
  final String name;

  EventInfoPage(this.name);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(name),
      ),
      body: new Center(
        child: new Column(
          children: <Widget>[
            new Text("Coordinates"),
            new RaisedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: new Text('Go back!'),
            ),
          ]
        ),
      )
    );
  }
}