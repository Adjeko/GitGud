import 'package:flutter/material.dart';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'datatypes.dart';

class MapsWidget extends StatefulWidget {
  MapsWidget({Key key, this.name, this.map}) : super(key: key);

  final String name;
  final EventMap map;

  @override
  _MapsState createState() => new _MapsState(name);
}

class _MapsState extends State<MapsWidget> {

  final mainReference = FirebaseDatabase.instance.reference();

  Map<String, G_LatLng> _persons = new Map();

  _MapsState(String name) {
    mainReference.child("events/${name}").onChildAdded.listen(_onPersonAdded);
    mainReference.child("events/${name}").onChildChanged.listen(_onPersonEdited);
  }

  @override
  initState() {
    super.initState();
    // _persons["ADjeko"] = new G_LatLng(40.730716, -73.990856);
    // _persons["Edu"] = new G_LatLng(40.733609, -73.999611);
    // _persons["Meier"] = new G_LatLng(40.722268, -73.997157);
  }

  _onPersonAdded(Event event) {
    if(event.snapshot.value["id"] != null && event.snapshot.value["lat"] != null && event.snapshot.value["lng"] != null){
      setState(() {
        _persons[event.snapshot.value["id"]] = new G_LatLng(event.snapshot.value["lat"], event.snapshot.value["lng"]);
      });
    }
  }

  _onPersonEdited(Event event) {
    if(event.snapshot.value["id"] != null && event.snapshot.value["lat"] != null && event.snapshot.value["lng"] != null){
      setState(() {
        _persons[event.snapshot.value["id"]] = new G_LatLng(event.snapshot.value["lat"], event.snapshot.value["lng"]);
      });
    }
    print(_persons.toString());
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new RaisedButton(
          onPressed: () {
            // mainReference.child("eventinfo/-L8OdkqVib682-FGXOe3/map").push().set(new EventMap("http://mediang.gameswelt.net/public/images/201608/cfad4a1c03e13194d4321f47e5971243.jpg", new G_LatLng(40.722268, -73.997157), 13, 640, 640).toJson()); 
          },
          child: new Text("new Person")
        ),
      new Stack(
      children: <Widget>[
        new Image.network(widget.map.url,
                  // 'http://maps.google.com/maps/api/staticmap?center=40.749825,-73.987963&size=700x700&zoom=13&path=color:0xff0000ff|weight:5|40.737102,-73.990318|40.749825,-73.987963',
                  fit: BoxFit.contain,
        ),
        new Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            top: 0.0,
            child: new CustomPaint(
              painter: new Sky(_persons, widget.map),
            )
        ),
      ],
    )
      ]
    );
  }
}

class Sky extends CustomPainter {

  Map<String,G_LatLng> persons; 
  EventMap map;

  Sky(this.persons, this.map);

  @override
  void paint(Canvas canvas, Size size) {
    
    // canvas.drawLine(
    //   new Offset(size.height/2, size.width/2), 
    //   new Offset(size.width, size.height),
    //   new Paint()..color = Colors.red,
    // );
    MercatorProjection p = new MercatorProjection();
    // List<G_LatLng> points = p.getCorners(new G_LatLng(40.749825, -73.987963), 13.0, 640.0, 640.0);
    List<G_LatLng> points = p.getCorners(map.center, map.zoomLevel.toDouble(), map.mapHeight.toDouble(), map.mapWidth.toDouble());

    G_LatLng a1 = points.elementAt(0);
    G_LatLng a2 = points.elementAt(1);

    persons.forEach((k,v) {
      double xFactor = (a2.lng - v.lng) / (a2.lng - a1.lng);
      double yFactor = (a2.lat - v.lat) / (a2.lat - a1.lat);
      yFactor = 1 - yFactor;

        canvas.drawCircle(new Offset(size.width * xFactor, size.height * yFactor),
          5.0, new Paint()..color = Colors.red);
    });

    

    // print('a is ${xFactor}, ${yFactor}, b is ${a2.lat}, ${a2.lng}');


    //print('a is ${a.x}, ${a.y}, b is ${b.x}, ${b.y}');

    // canvas.drawLine(
    //   new Offset(size.width * xFactor, size.height * yFactor), 
    //   new Offset(0.0, 0.0),
    //   new Paint()..color = Colors.red,
    // );
  }

  @override
  bool shouldRepaint(Sky oldDelegate) {
    return false;
  }
}

class MercatorProjection {

  static int MERCATOR_RANGE = 256;

  G_point _pixelOrigin;
  double _pixelsPerLonDegree;
  double _pixelsPerLonRadian;

  MercatorProjection() {
    this._pixelOrigin = new G_point( MERCATOR_RANGE / 2, MERCATOR_RANGE / 2);
    this._pixelsPerLonDegree = MERCATOR_RANGE / 360;
    this._pixelsPerLonRadian = MERCATOR_RANGE / (2 * pi);

  }

  G_point fromLatLngToPoint(G_LatLng latlng) {
    G_point point = new G_point(0.0, 0.0);
    point.x = _pixelOrigin.x + latlng.lng * _pixelsPerLonDegree;
    double siny = bounding(sin(degreesToRadians(latlng.lat)),-0.9999, 0.9999);
    point.y = _pixelOrigin.y + 0.5 * log((1+siny)/(1-siny)) * -_pixelsPerLonRadian;
    return point;
  }

  List<G_LatLng> getCorners(G_LatLng center, double zoom, double mapHeight, double mapWidth) {
    double scale = pow(2, zoom);
    MercatorProjection proj = new MercatorProjection();
    G_point centerPx = proj.fromLatLngToPoint(center);
    G_point swPoint = new G_point(centerPx.x - (mapWidth/2)/scale, centerPx.y + (mapHeight/2)/scale);
    G_LatLng swLatlon = proj.fromPointToLatLng(swPoint);
    G_point nePoint = new G_point(centerPx.x+(mapWidth/2)/scale, centerPx.y-(mapHeight/2)/scale);
    G_LatLng neLatLon = proj.fromPointToLatLng(nePoint);

    List<G_LatLng> list = new List<G_LatLng>();

    list.add(neLatLon);
    list.add(swLatlon);
    return list;
  }

  G_LatLng fromPointToLatLng(G_point point) {
    double lng = (point.x - this._pixelOrigin.x) / this._pixelsPerLonDegree;
    double latRadius = (point.y - this._pixelOrigin.y) / - this._pixelsPerLonRadian;
    double lat = radiansToDegree(2*atan(exp(latRadius)) - pi /2);
    return new G_LatLng(lat, lng);

  }

  double degreesToRadians(double deg) {
    return deg * (pi / 180);

  }

  double radiansToDegree(double rad) {
    return rad / (pi / 180);
  }

  double bounding(double value, double minN, double maxN) {
    double tmp;
    if (minN != null) {
      tmp = max(value, minN);
    }

    if (maxN != null) {
      tmp = min(value, maxN);
    }

    return value;

  }

}

class G_point {

  double x;
  double y;

  G_point(double x, double y) {
    this.x = x;
    this.y = y;
  }
}

class G_LatLng  {
  double lat;
  double lng;

  G_LatLng(double lat, double lng) {
    this.lat = lat;
    this.lng = lng;
  }
  
  toString()
  {
    return "(" + lat.toString() + "|" + lng.toString() + ")";
  }
}