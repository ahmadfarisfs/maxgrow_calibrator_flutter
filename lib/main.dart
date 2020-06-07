import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'widget/calibrate.dart';
import 'widget/apn.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.orange,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
   final myController = TextEditingController();
   final myControllerScale = TextEditingController();
     void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert Dialog title"),
          content: new Text("Alert Dialog body"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future postCalibrationData() async{
    print(myController.text);
    print(myControllerScale.text);
    print(loadCellID);
    
    final response = await http.get('https://jsonplaceholder.typicode.com/albums/1?lcid='+loadCellID.toString()+"&offset="+myController.text+"&scale="+myControllerScale.text);
    print(response);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(response.body);
      _showDialog();
      return Text(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<Text> fetchAlbum() async {
    final response = await http.get('https://jsonplaceholder.typicode.com/albums/1');
    print(response);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(response.body);
      return Text(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  String display;
  Future<Text> futureAlbum;
  Widget result = Text("");
  bool apiCall = false;
  String resultApi;

  int loadCellID;
  int deviceID;
  double offset;
  double scale;
  
  Widget futureWidgetOnButtonPress() {
    return new FutureBuilder<String>(builder: (context, snapshot) {
      // if(snapshot.hasData){return new Text(display);}    //does not display updated text
      if (display != null) {
        return Card(
                  child: Container(
                    height: 200,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
            
            children:<Widget>[
Text(display),

            ],),
                    ),
                  ),
        );
      }
      return new CircularProgressIndicator();
    });
  }
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }
  Future<Null> getData() async {
    setState(() {
      display = null;
      //   display = data[2]['title'].toString();
    });
    http.Response response = await http.get(
        Uri.encodeFull("https://jsonplaceholder.typicode.com/posts"),
        headers: {"Accept": "application/json"});
    // List data = JSON.decode(response.body);
    //  print(data[2]['title'].toString());
    setState(() {
      display = response.body;
      //   display = data[2]['title'].toString();
    });
  }

  bool isLoading;
  setLoading(bool state) => setState(() => isLoading = state);

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return MaterialApp(

       theme: ThemeData(
         buttonColor: Colors.white,
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.linear_scale),
                  text: "Load Cell",
                ),
                Tab(
                  icon: Icon(Icons.settings_input_antenna),
                  text: "APN",
                ),
                //  Tab(icon: Icon(Icons.directions_bike)),
              ],
            ),
            title: Text('MaxGrow Calibrator'),
          ),
          body: TabBarView(
            children: [
              Calibrator(),
APN(),
              //  //  Icon(Icons.directions_bike),
            ],
          ),
        ),
      ),
    );
  }
}

