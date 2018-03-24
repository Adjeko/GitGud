import 'package:flutter/material.dart';
import 'Point.dart';

class  CardImage {

  String _url = 'http://maps.google.com/maps/api/staticmap?size=600x600&';
  //String _url = 'http://maps.googleapis.com/maps/api/staticmap?zoom=2&size=600x300&maptype=roadmap%20&markers=color:blue%7C40.7687605058,-73.9982199669&markers=color:blue%7C44.655916705,-63.577837944&markers=color:blue%7C50.9046160427,-1.42889857292&path=color:0x0000ff|weight:5|40.7687605058,-73.9982199669|44.655916705,-63.577837944|50.9046160427,-1.42889857292';
  //String _url = 'http://maps.google.com/maps/api/staticmap?size=700x700&zoom=13&path=color:0xff0000ff|weight:5|40.737102,-73.990318|40.749825,-73.987963';

  Map<String, String> _parameters;

  List<Point> _points;

  Image getImageFromApi() {
    String finalUrl = _url;
    //finalUrl += "size=700x700&zoom=13&";
    finalUrl += "markers=color:blue|label:S|40.737102,-73.990318";
    finalUrl += "&markers=color:red|label:S|40.737102,-73.98796&";
    finalUrl += drawPath();

    return new Image.network(finalUrl, fit: BoxFit.contain,);
  }

  void addParameters(String key, String value) {
    _parameters[key] = value;
  }

  void addMarker(Point point) {
    _points.add(point);
  }

  String drawPath() {
    String sep = "|";
    String path = "path=";
    path += "color:0ff0000ff";
    path += sep;
    path += "weight:5";
    path += sep;
    path += "40.737102,-73.990318";
    path += sep;
    path += "40.749825,-73.98796";
    path += sep;
    path += "40.753825,-73.95796";
    path += sep;
    path += "40.755825,-73.96796";
    path += sep;
    path += "40.737102,-73.990318";
    return path;

  }

}