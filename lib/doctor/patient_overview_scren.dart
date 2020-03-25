import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import '../providers/auth.dart';
import '../videocall/pages/call.dart';
import './excercise_chart_screen.dart';

class PatientOverviewScreen extends StatefulWidget {
  final String name;
  final String patId;
  final String docId;

  PatientOverviewScreen({
    @required this.name,
    @required this.patId,
    @required this.docId,
  });

  @override
  _PatientOverviewScreenState createState() => _PatientOverviewScreenState();
}

class _PatientOverviewScreenState extends State<PatientOverviewScreen> {
  bool _isLoading = false;
  Map<String, dynamic> _userData;

  @override
  void initState() {
    super.initState();
    getPatDetails();
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
      print(responseBody);
      if (responseBody == []) {
        return;
      }
      _userData = responseBody[0];
    } catch (e) {
      print(e);
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> makeVideoCall(docId, patientId) async {
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
      print(responseBody);
      print(response.statusCode);
      final channelName = responseBody[0]['channel'];
      await showDialog(
        context: context,
        child: AlertDialog(
          content: Text(channelName),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      );
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
    } catch (e) {
      print('error:');
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.video_call,
              size: 30,
            ),
            onPressed: () async {
              print('hey');
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
                      height: 100,
                      width: double.infinity,
                      color: Colors.red,
                      child: SafeArea(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: FlatButton.icon(
                                textColor: Colors.white,
                                icon: Icon(Icons.directions_run),
                                label: Text('Excercise Chart'),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (ctx) =>
                                          ExcerciseChartScreen()));
                                },
                              ),
                            ),
                            Expanded(
                              child: FlatButton.icon(
                                textColor: Colors.white,
                                icon: Icon(Icons.rate_review),
                                label: Text('Patient Review'),
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
