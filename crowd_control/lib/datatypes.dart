import 'package:flutter/material.dart';
import 'EventInfoPage.dart';

class EventInfo {
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
}