import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class APN extends StatefulWidget {
  @override
  _APNState createState() => _APNState();
}

class _APNState extends State<APN> {

  final apnTextController = TextEditingController();
  final userTextController = TextEditingController();
  final passTextController = TextEditingController();
  bool loading = false;

  showAlertDialog(BuildContext context, String title, message) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  //make it immutable
  setAPN(String apn, String user,String pass) async {
    if (loading == true){
    showAlertDialog(
            context, "Error", "Device busy");
    }
    setState(() {
      loading = true;
    });
    Map<String,String> queryParameters = {
  };
   
        if(apn != null){
  queryParameters['apn']= apn;

    }
        if(user != null){
  queryParameters['user']= user;

    }        if(pass != null){
  queryParameters['pass']= pass;

    }


    var uri = Uri.http('192.168.1.1', '/set_apn', queryParameters);
    dynamic response;
    try {
  dynamic    unfinishedResponse = http.get(uri).timeout(Duration(seconds: 5));
      response = await unfinishedResponse;
    } on TimeoutException catch (e) {
      print('Timeout');
    } on Error catch (e) {
      print('Error: $e');
    } on SocketException catch (e) {
      print("socket except");
    } catch (e) {
      print("other except");
    }

    setState(() {
      loading = false;
    });

    if (response != null) {
      if (response.statusCode == 200) {
        showAlertDialog(
            context, "Success", "APN set");
      } else {
        showAlertDialog(context, "Error", "Fail to set APN");
      }
    } else {
      showAlertDialog(context, "Error Timeout", "Fail to set APN");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(children: <Widget>[
    
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                width: 170.0,
                child: TextFormField(
                  controller: apnTextController,
                // keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.insert_chart,
                      color: Colors.blueAccent,
                    ),
                    border: OutlineInputBorder(),
                    hintText: "Enter APN",
                    labelText: 'APN',
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                width: 170.0,
                child: TextFormField(
                  controller: userTextController,
                 // keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.settings_applications,
                      color: Colors.blueAccent,
                    ),
                    border: OutlineInputBorder(),
                    hintText: "Enter username APN",
                    labelText: 'Username',
                  ),
                ),
              ),
                 SizedBox(
                height: 8,
              ),
              Container(
                width: 170.0,
                child: TextFormField(
                  controller: userTextController,
                 // keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.security,
                      color: Colors.blueAccent,
                    ),
                    border: OutlineInputBorder(),
                    hintText: "Enter password APN",
                    labelText: 'Password',
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  elevation: 20,
                  //   color: Colors.white,
                  // textColor: Colors.green,
                  padding: EdgeInsets.all(8.0),
                  onPressed: loading? null: () {
                    setAPN(apnTextController.text, userTextController.text, passTextController.text);
                    //do http stuff
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                   
                            Text("Set"),
              
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
     
     
    ]),
        ),
      );
  }
}
