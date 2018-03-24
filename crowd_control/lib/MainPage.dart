import 'package:flutter/material.dart';
import 'datatypes.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Crowd Control',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => new _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<EventInfo> _events = new List();

@override
  void initState() {
    setState(() {
      _events.add(new EventInfo("Peter und Paul" , "Saufen", "https://www.unesco.de/uploads/tx_unescosearch/images/BRET5_c_Thomas_Rebel_01.jpg"));
      _events.add(new EventInfo("Gamescom", "ZOOOCKEN", "http://mediang.gameswelt.net/public/images/201608/cfad4a1c03e13194d4321f47e5971243.jpg"));
      _events.add(new EventInfo("Open Codes Hackathon", "HACKEN", "https://www.cas.de/uploads/pics/Open_Codes_2018-thumbs.jpg"));
      _events.add(new EventInfo("CES", "Consumer Electronics Show", "http://www.digitaldevotion.com/wp-content/uploads/2017/11/CES-2018.jpg"));
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Crowd Control"),
      ),
      body: new Center(
        child: new ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: _events.length,
          itemBuilder: (context, i) {
            return _events[i].toWidget(context);
          }
        )
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: (){},
        tooltip: 'Increment',
        child: new Icon(Icons.favorite_border),
      ),
    );
  }
}