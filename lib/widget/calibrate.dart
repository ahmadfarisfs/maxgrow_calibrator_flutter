import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Calibrator extends StatefulWidget {
  @override
  _CalibratorState createState() => _CalibratorState();
}

class _CalibratorState extends State<Calibrator> {
  int loadCellID = 0;
  int previousloadCellID = 0;
  List<dynamic> scales = [null, null, null, null];
  List<dynamic> offsets = [null, null, null, null];
  final offsetTextController = TextEditingController();
  final scaleTextController = TextEditingController();
  final totalOffsetTextController = TextEditingController();
  final samplingTextController = TextEditingController();
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


  getData() async {
    if (loading == true) {
      showAlertDialog(context, "Error", "Device busy");
    }
    setState(() {
      loading = true;
    });

    var uri = Uri.http('192.168.1.1', '/get');
    dynamic response;
    try {
      dynamic unfinishedResponse = http.get(uri).timeout(Duration(seconds: 5));
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
        showAlertDialog(context, "Success", response.body);
      } else {
        showAlertDialog(context, "Error", "Fail to get");
      }
    } else {
      showAlertDialog(context, "Error Timeout", "Fail to get");
    }
  }

  //make it immutable
  calibrateLoadCell(int loadCellID,
      [String offset,
      String scale,
      String totalOffset,
      String samplingPeriod]) async {
    if (loading == true) {
      showAlertDialog(context, "Error", "Device busy");
    }
    setState(() {
      loading = true;
    });
    Map<String, String> queryParameters = {};
    if (offset != null) {
      queryParameters['lcoff' + loadCellID.toString()] = offset;
    }
    if (scale != null) {
      queryParameters['lcscale' + loadCellID.toString()] = scale;
    }
    if (totalOffset != null) {
      queryParameters['totaloff'] = totalOffset;
    }
    if (samplingPeriod != null) {
      queryParameters['sampp'] = samplingPeriod;
    }

    var uri = Uri.http('192.168.1.1', '/calibrate', queryParameters);
    print(uri.toString());
    dynamic response;
    try {
      dynamic unfinishedResponse = http.get(uri).timeout(Duration(seconds: 5));
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
      print(response.body);
      if (response.statusCode == 200) {
        showAlertDialog(
            context, "Success", "LC Calibrated");
      } else {
        showAlertDialog(context, "Error", "Fail to calibrate LC");
      }
    } else {
      showAlertDialog(context, "Error Timeout", "Fail to calibrate LC");
    }
  }

  setActiveLoadCell(int id) {
    return setState(() {
      previousloadCellID = loadCellID;
      loadCellID = id;
      scales[previousloadCellID] = scaleTextController.text;
      offsets[previousloadCellID] = offsetTextController.text;
      scaleTextController.text = scales[loadCellID];
      offsetTextController.text = offsets[loadCellID];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Load Cell ID"),
              new Radio(
                value: 0,
                groupValue: loadCellID,
                onChanged: loading
                    ? null
                    : (int value) {
                        setActiveLoadCell(value);
                      },
              ),
              new Text(
                '0',
                style: new TextStyle(fontSize: 16.0),
              ),
              new Radio(
                value: 1,
                groupValue: loadCellID,
                onChanged: loading
                    ? null
                    : (int value) {
                        setState(() {
                          setActiveLoadCell(value);
                        });
                      },
              ),
              new Text(
                '1',
              ),
              new Radio(
                value: 2,
                groupValue: loadCellID,
                onChanged: loading
                    ? null
                    : (int value) {
                        setState(() {
                          setActiveLoadCell(value);
                        });
                      },
              ),
              new Text(
                '2',
                //   style: new TextStyle(fontSize: 16.0),
              ),
              new Radio(
                value: 3,
                groupValue: loadCellID,
                onChanged: loading
                    ? null
                    : (int value) {
                        setState(() {
                          setActiveLoadCell(value);
                        });
                      },
              ),
              new Text(
                '3',
                //   style: new TextStyle(fontSize: 16.0),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,

            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    width: 170.0,
                    child: TextFormField(
                      controller: offsetTextController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.insert_chart,
                          color: Colors.blueAccent,
                        ),
                        border: OutlineInputBorder(),
                        hintText: "Enter calculated offset",
                        labelText: 'Offset',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    width: 170.0,
                    child: TextFormField(
                      controller: scaleTextController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.show_chart,
                          color: Colors.blueAccent,
                        ),
                        border: OutlineInputBorder(),
                        hintText: "Enter calculated scale",
                        labelText: 'Scale',
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
                      onPressed: loading
                          ? null
                          : () {
                              calibrateLoadCell(
                                  loadCellID,
                                  offsetTextController.text,
                                  scaleTextController.text,
                                  null,
                                  null);
                              //do http stuff
                            },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Text("Calibrate"),
                            Text(
                              "LC" + loadCellID.toString().toUpperCase(),
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: <Widget>[
              Expanded(child: Divider()),
              Expanded(child: Divider()),
            ]),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                width: 170.0,
                child: TextFormField(
                  controller: totalOffsetTextController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.vertical_align_top,
                      color: Colors.blueAccent,
                    ),
                    border: OutlineInputBorder(),
                    hintText: "Enter total offset",
                    labelText: 'Total Offset',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  elevation: 20,
                  //   color: Colors.white,
                  // textColor: Colors.green,
                  padding: EdgeInsets.all(8.0),
                  onPressed: loading
                      ? null
                      : () {
                          calibrateLoadCell(loadCellID, null, null,
                              totalOffsetTextController.text, null);
                          //do http stuff
                        },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Text("Set Offset"),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                width: 170.0,
                child: TextFormField(
                  controller: samplingTextController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.timelapse,
                      color: Colors.blueAccent,
                    ),
                    border: OutlineInputBorder(),
                    hintText: "Enter sampling period (second)",
                    labelText: 'Sampling Period (s)',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  elevation: 20,
                  //   color: Colors.white,
                  // textColor: Colors.green,
                  padding: EdgeInsets.all(8.0),
                  onPressed: loading
                      ? null
                      : () {
                          calibrateLoadCell(loadCellID, null, null, null,
                              samplingTextController.text);
                          //do http stuff
                        },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Text("Set Period"),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: loading
                    ? null
                    : () {
                        getData();
                      },
                child: Text("Get Device Realtime Data"),
              ),
            ],
          ),
          Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                color: Colors.yellow,
              ))
        ]),
      ),
    );
  }
}
