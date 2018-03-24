import 'package:flutter/material.dart';
import 'dart:math';

class ImageWidget extends StatefulWidget {
  //ImageWidget({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  //final String title;

  @override
  _ImageState createState() => new _ImageState();
}

class _ImageState extends State<ImageWidget> {

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new Image.network(
                  'http://maps.google.com/maps/api/staticmap?center=40.749825,-73.987963&size=700x700&zoom=13&path=color:0xff0000ff|weight:5|40.737102,-73.990318|40.749825,-73.987963',
                  fit: BoxFit.contain,
        ),

        new Positioned(
            
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            top: 0.0,
            child: new CustomPaint(
              painter: new Sky(),
            )
        ),
      ],
    );
  }
}

class Sky extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    
    canvas.drawLine(
      new Offset(size.height/2, size.width/2), 
      new Offset(size.width, size.height),
      new Paint()..color = Colors.red,
    );

    MercatorProjection p = new MercatorProjection();
    List<G_LatLng> points = p.getCorners(new G_LatLng(40.749825, -73.987963), 13.0, 640.0, 640.0);

    G_point a = p.fromLatLngToPoint(points.elementAt(0));
    G_point b = p.fromLatLngToPoint(points.elementAt(1));

    print('a is ${a.x}, ${a.y}, b is ${b.x}, ${b.y}');

    canvas.drawLine(
      new Offset(a.x - size.width/2, a.y - size.height/2), 
      new Offset(b.x - size.width/2, b.y - size.height/2),
      new Paint()..color = Colors.red,
    );
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
}
