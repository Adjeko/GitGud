import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'EventInfoPage.dart';
import 'MapsWidget.dart';

class EventInfo {
  String key;
  String name;
  String description;
  String imageUrl;

  EventInfo(this.name, this.description, this.imageUrl);

  Widget toWidget(BuildContext context){
    return new FlatButton(
      child: new Card(
        child: new Column( 
          children: <Widget>[
            new Image.network(imageUrl),
            new Text(name),
            new Text(description),
          ]
        )
      ),
      onPressed:(){
        Navigator.push(context,new MaterialPageRoute(builder: (context) => new EventInfoPage(name: name)));
      }
    );
  }

  EventInfo.fromSnapshot(DataSnapshot snapshot)
  : key = snapshot.key,
    name = snapshot.value["name"],
    description = snapshot.value["description"],
    imageUrl = snapshot.value["imageUrl"];

  toJson(){
    return {
      "name" : name,
      "description" : description,
      "imageUrl" : imageUrl
    };
  } 
}

class EventMap {
  String key;
  String url;
  G_LatLng center;
  int zoomLevel;
  int mapWidth;
  int mapHeight;

  EventMap(this.url, this.center, this.zoomLevel, this.mapWidth, this.mapHeight);

  EventMap.fromSnapshot(dynamic snapshot)
  : key = snapshot.key,
    url = snapshot.value["url"],
    center = new G_LatLng(snapshot.value["lat"], snapshot.value["lng"]),
    zoomLevel = snapshot.value["zoom"],
    mapWidth = snapshot.value["width"],
    mapHeight = snapshot.value["height"];

  toJson() {
    return {
    "url" : url,
    "lat" : center.lat,
    "lng" : center.lng,
    "zoom": zoomLevel,
    "width" : mapWidth,
    "height": mapHeight
    };
  }  
}