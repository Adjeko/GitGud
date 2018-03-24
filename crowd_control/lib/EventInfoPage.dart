import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:location/location.dart';

import 'MapsWidget.dart';

class EventInfoPage extends StatefulWidget {
  EventInfoPage({Key key, this.name}) : super(key: key);

  final String name;
  @override
  _EventInfoPageState createState() => new _EventInfoPageState();
}

class _EventInfoPageState extends State<EventInfoPage> {
  final String name;
  Location _loc = new Location();
  Map<String, double> _currentLocation;
  StreamSubscription<Map<String, double>> _locationSubscription;

  Map<String, G_LatLng> persons = new Map();

  @override
  initState() {
    super.initState();
    initPlatformState();
    _locationSubscription = _loc.onLocationChanged.listen((Map<String, double> result){
      setState((){
        _currentLocation = result;
        persons["ADjeko"] = new G_LatLng(40.730716, -73.990856);
        persons["Edu"] = new G_LatLng(40.733609, -73.999611);
        persons["Meier"] = new G_LatLng(40.722268, -73.997157);
      });
    }); 
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.name),
      ),
      body: new Center(
        child: new Column(
          children: <Widget>[
            new Text("Coordinates" + _currentLocation.toString()),
            new MapsWidget(persons: persons),
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

  initPlatformState() async {
    Map<String, double> location;
    try {
      location = await _loc.getLocation;
    } on PlatformException {
      location = null;
    }

    if(!mounted)
      return;
    setState(() {
      _currentLocation = location;
    });
  }

}