import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:firebase_database/firebase_database.dart';
import 'MapsWidget.dart';
import 'datatypes.dart';

class EventInfoPage extends StatefulWidget {
  EventInfoPage({Key key, this.name}) : super(key: key);

  final String name;
  @override
  _EventInfoPageState createState() => new _EventInfoPageState(name);
}

class _EventInfoPageState extends State<EventInfoPage> {
  final String MYNAME = "Adjeko";

  final String name;
  Location _loc = new Location();
  Map<String, double> _currentLocation;
  StreamSubscription<Map<String, double>> _locationSubscription;
  EventMap map;
  final mainReference = FirebaseDatabase.instance.reference();

  _EventInfoPageState(String name) {
    mainReference.child("eventinfo").once().then((DataSnapshot snapshot){
      snapshot.value.keys.forEach((k){
        if(snapshot.value[k]["name"] == name)
        {
          snapshot.value[k]["map"].keys.forEach((j){
            setState((){
              map = new EventMap(snapshot.value[k]["map"][j]["url"], new G_LatLng(snapshot.value[k]["map"][j]["lat"], snapshot.value[k]["map"][j]["lng"]), snapshot.value[k]["map"][j]["zoom"], snapshot.value[k]["map"][j]["width"], snapshot.value[k]["map"][j]["height"]);
            });   
          }); 
        }
      });
    });
  }

  @override
  initState() {
    super.initState();
    initPlatformState();
    _locationSubscription = _loc.onLocationChanged.listen((Map<String, double> result){
      setState((){
        _currentLocation = result;
      });
      mainReference.child("events/${widget.name}").once().then((DataSnapshot snapshot) {
        if(snapshot.value != null){
          bool hit = false;
          snapshot.value.forEach((k, v) {
            if(v["id"] != null && v["id"] == MYNAME && k != null && k != "null") {
              mainReference.child("events/${widget.name}/${k}").set({"id" : MYNAME, "lat" : result["latitude"],"lng" : result["longitude"]});
              hit = true;
            }
          });
          if(!hit){
            mainReference.child("events/${widget.name}").push().set({"id" : MYNAME, "lat" : result["latitude"],"lng" : result["longitude"]});
          }
        } else {
          mainReference.child("events/${widget.name}").push().set({"id" : MYNAME, "lat" : result["latitude"],"lng" : result["longitude"]});
        }
      });      
    }); 

  }

  @override
  dispose() {
    _locationSubscription.cancel();
    super.dispose();
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
            new MapsWidget(name: widget.name, map: map)
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