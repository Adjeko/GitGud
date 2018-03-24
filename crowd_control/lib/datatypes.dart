import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'EventInfoPage.dart';

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
        Navigator.push(context,new MaterialPageRoute(builder: (context) => new EventInfoPage(name)));
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