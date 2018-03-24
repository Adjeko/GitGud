import 'package:firebase_database/firebase_database.dart';


class Person {
  String key;
  String Id;
  double longitude;
  double latitude;

  Person(this.Id, this.longitude, this.latitude);

  Person.fromSnapshot(DataSnapshot snapshot)
   : key = snapshot.key,
     Id = snapshot.value["Id"],
     longitude = snapshot.value["longitude"].toDouble(),
     latitude = snapshot.value["latitude"].toDouble();

  toJson()
  {
    return {
      "Id": Id,
      "longitude": longitude,
      "latitude": latitude
    };
  }
  @override
    String toString() {
      return Id + " " + latitude.toString() + " " + longitude.toString();
    }
}

