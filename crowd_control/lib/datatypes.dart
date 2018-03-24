import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Person {
  String key;
  String id;
  double longitude;
  double latitude;

  Person(this.id, this.longitude, this.latitude);

  Person.fromSnapshot(DataSnapshot snapshot)
   : key = snapshot.key,
     id = snapshot.value["id"],
     longitude = snapshot.value["longitude"].toDouble(),
     latitude = snapshot.value["latitude"].toDouble();

  toJson()
  {
    return {
      "id": id,
      "longitude": longitude,
      "latitude": latitude
    };
  }

  Widget toWidget() {
    return new Text(toString());
  }

  @override
  String toString() {
    return id + " " + latitude.toString() + " " + longitude.toString();
  }

  
}

