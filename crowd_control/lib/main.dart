import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'datatypes.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<Person> personList = new List();
  final mainReference = FirebaseDatabase.instance.reference();

  ScrollController _listViewScrollController = new ScrollController();

  _MyHomePageState() {
    mainReference.onChildAdded.listen(_onPersonAdded);
    mainReference.onChildChanged.listen(_onPersonEdited);
  }

  _onPersonAdded(Event event){
    setState(() {
      personList.add(new Person.fromSnapshot(event.snapshot));
    });
  }

  _onPersonEdited(Event event) {
    var old = personList.singleWhere((person) => person.key == event.snapshot.key);
    setState(() {
      personList[personList.indexOf(old)] = new Person.fromSnapshot(event.snapshot);
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
      Person p = new Person('AdjekoID$_counter', 3.2, 4.2);
      mainReference.push().set(p.toJson());
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new ListView.builder(
              shrinkWrap: true,
              reverse: true,
              controller: _listViewScrollController,
              itemCount: personList.length,
              itemBuilder: (buildContext, index) {
                return new Text(personList[index].toString());
              },
            ),
            new Text(
              'You have pushed the button this many times:',
            ),
            new Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
