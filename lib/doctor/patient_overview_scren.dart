import 'dart:convert';
import 'dart:io';

import 'package:edge_alert/edge_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:wakelock/wakelock.dart';

import '../providers/auth.dart';
import '../videocall/pages/call.dart';
import './excercise_chart_screen.dart';

class PatientOverviewScreen extends StatefulWidget {
  final String name;
  final String patId;
  final String docId;
  final String medCond;

  PatientOverviewScreen({
    @required this.name,
    @required this.patId,
    @required this.docId,
    @required this.medCond,
  });

  @override
  _PatientOverviewScreenState createState() => _PatientOverviewScreenState();
}

class _PatientOverviewScreenState extends State<PatientOverviewScreen> {
  bool _isLoading = false;
  bool _isLoading2 = false;
  Map<String, dynamic> _userData;

  String _consulID;

  @override
  void initState() {
    super.initState();
    getPatDetails();
  }
  bool consulBool = true;
  Future<void> getConsolID() async {
    String url = 'https://fitknees.herokuapp.com/auth/getconsul/';

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': Provider.of<Auth>(context, listen: false).token,
        },
        body: {
          'doc_id': widget.docId,
          'pat_id': widget.patId,
        },
      );
      final responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        _consulID = responseBody['consol'];
      }
      else{
        setState(() {
          consulBool=false;
        });
      }
    } catch (e) {
    }
  }

  Future<void> getPatDetails() async {
    String url = 'https://fitknees.herokuapp.com/auth/patient/details/';
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.post(url, headers: {
        'Authorization': Provider.of<Auth>(context, listen: false).token,
      }, body: {
        'id': widget.patId,
      });
      final responseBody = json.decode(response.body);
      if (responseBody == []) {
        return;
      }
      _userData = responseBody[0];
    } catch (e) {
    }
    await getConsolID();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> makeVideoCall(docId, patientId) async {
    setState(() {
      _isLoading2 = true;
    });
    await Wakelock.enable();
    try {
      String url = 'https://fitknees.herokuapp.com/auth/patient/vcall/';
      final response = await http.post(
        url,
        headers: {
          'Authorization': Provider.of<Auth>(context, listen: false).token,
        },
        body: {
          'doctor': docId,
          'patient': patientId,
        },
      );
      final responseBody = json.decode(response.body);
      setState(() {
        _isLoading2 = false;
      });
      final channelName = responseBody[0]['channel'];
      await PermissionHandler().requestPermissions(
        [PermissionGroup.camera, PermissionGroup.microphone],
      );
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(
            channelName: channelName,
          ),
        ),
      );
      await Wakelock.disable();
    } catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        actions: <Widget>[
          _isLoading2
              ? Container(
                  padding: EdgeInsets.only(right: 20),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(
                        Colors.grey,
                      ),
                    ),
                  ),
                )
              : IconButton(
                  icon: Icon(
                    Icons.video_call,
                    size: 30,
                  ),
                  onPressed: () async {
                    await makeVideoCall(widget.docId, widget.patId);
                  },
                  color: Colors.green,
                ),
        ],
      ),
      body: _isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : _userData == null
              ? Container(
                  child: Center(
                    child: Text('This User has not registered yet.'),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Name'.toUpperCase(),
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              widget.name,
                              style: TextStyle(fontSize: 34),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'Gender'.toUpperCase(),
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              _userData['gender'],
                              style: TextStyle(fontSize: 34),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'DOB'.toUpperCase(),
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              _userData['date_of_birth'],
                              style: TextStyle(fontSize: 34),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'Height'.toUpperCase(),
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              _userData['height'].toString() + ' cm',
                              style: TextStyle(fontSize: 34),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'Weight'.toUpperCase(),
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              _userData['weight'].toString() + ' Kg',
                              style: TextStyle(fontSize: 34),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'Phone Number'.toUpperCase(),
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              _userData['phone_number'].toString(),
                              style: TextStyle(fontSize: 34),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(),
                    ),
                    Container(
                      height: Platform.isAndroid ? 60 : 80,
                      width: double.infinity,
                      color: Color(0xFF607EEA),
                      child: SafeArea(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Expanded(
                              child: FlatButton.icon(
                                textColor: Colors.white,
                                icon: Icon(Icons.directions_run),
                                label: Text('Excercise Chart'),
                                onPressed: () {
                                  consulBool?
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) => ExcerciseChartScreen(
                                        consolId: _consulID,
                                      ),
                                    ),
                                  ):EdgeAlert.show(
                                  context,
                                  title: 'Consultation Not found',
                                  description: 'Sorry, Can\'t assign exercise chat without a ongoing consultation',
                                  gravity: EdgeAlert.BOTTOM,
                                  backgroundColor: Colors.red,
                                );

                                },
                              ),
                            ),
                            Expanded(
                              child: FlatButton.icon(
                                textColor: Colors.white,
                                icon: Icon(Icons.rate_review),
                                label: Text('Reports'),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
