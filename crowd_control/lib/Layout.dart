import 'package:flutter/material.dart';

class EventInfoScreen extends StatelessWidget {
  final String name;
  EventInfoScreen(this.name);
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(name),
      ),
      body: new Center(
        child: new RaisedButton(
          onPressed: () {
            // Navigate back to first screen when tapped!
          },
          child: new Text('Go back!'),
        ),
      ),
    );
  }
}