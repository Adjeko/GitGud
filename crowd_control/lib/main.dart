import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'crowd_control',
      theme: new ThemeData(
        primaryColor: Colors.white,
      ),
      home: new Scaffold(
        body: new Center(
          child: new Events(),
        ),
      ),
    );
  }
}

class Events extends StatefulWidget {
  @override
  createState() => new EventsState();
}

class EventsState extends State<Events> {
  final List<String> _events = new List();
  final List<String> _sub = new List();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Fette Events Boi'),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.list), onPressed: _push),
        ],
      ),
      body: _buildEvents(),
    );
  }
  @override
  void initState() {
    setState(() {
      _events.add("Peter und Paul");
      _events.add("Gamescom");
    });
  }

  Widget _buildEvents() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _events.length,
        itemBuilder: (context, i) {
          return _buildRow(_events[i]);
        });
  }

  Widget _buildRow(String event) {
    return new ListTile(
      title: new Text(event,
          style: new TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0)),
      leading: new Icon(
        Icons.favorite,
        color: Colors.red[500],
      ),
      onTap: _push,
    );
  }
  void _push() {

  }
}
