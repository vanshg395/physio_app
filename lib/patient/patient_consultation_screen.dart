import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:physio_app/patient/router.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class PatientConsultationScreen extends StatefulWidget {
  @override
  _PatientConsultationScreenState createState() =>
      _PatientConsultationScreenState();
}

class _PatientConsultationScreenState extends State<PatientConsultationScreen> {
  bool _isLoading = false;
  String _fullname = '';
  String _depart = '';
  String _designation = '';
  String _hospital = '';
  String _image = '';
  String _docID = '';

  @override
  void initState() {
    super.initState();
    getDoctor();
  }

  Future<void> _startConsultation() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false).startConsult();
    } catch (error) {
      print(error);
      String errorMessage;
      errorMessage = error.toString();

      showDialog(
        context: context,
        builder: (context) => Platform.isIOS
            ? CupertinoAlertDialog(
                title: Text(errorMessage),
                content: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(errorMessage),
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              )
            : AlertDialog(
                backgroundColor: Colors.grey,
                title: Text(errorMessage),
                content: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(errorMessage),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> getDoctor() async {
    setState(() {
      _isLoading = true;
    });
    try {
      String url = 'https://fitknees.herokuapp.com/auth/doctor/details/';

      final response = await http.get(
        url,
        headers: {
          'Authorization': Provider.of<Auth>(context, listen: false).token,
        },
      );
      print(response.body);
      final resBody = json.decode(response.body);

      _fullname = resBody['name'];
      _depart = resBody['department'];
      _designation = resBody['designation'];
      _hospital = resBody['hospital'];
      _image = resBody['image'];
      _docID = resBody['docId'];
      print(resBody);

      await Provider.of<Auth>(context, listen: false).addDocID(_docID);
    } catch (error) {
      print(error);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image.asset(
                    //   'logo/doctor.jpeg',
                    //   fit: BoxFit.fitHeight,
                    // ),

                    Card(
                      color: Colors.grey[200],
                      elevation: 3,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 30,
                          horizontal: 20,
                        ),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Name : $_fullname",
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Designation : $_designation",
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Department : $_depart",
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Hospital : $_hospital",
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),


                    SizedBox(
                      height: 20,
                    ),

                    _isLoading
                        ? Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : RaisedButton(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (context) => Platform.isIOS
                                    ? CupertinoAlertDialog(
                                  title: Text("Please contact doctor to approve your request"),
                                  content: Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text("Please contact doctor to approve your request"),
                                  ),
                                  actions: <Widget>[
                                    CupertinoDialogAction(
                                      child: Text('OK'),
                                      onPressed: () => Navigator.of(context).pop(),
                                    ),
                                  ],
                                )
                                    : AlertDialog(
                                  backgroundColor: Colors.grey,
                                  title: Text("Please contact doctor to approve your request"),
                                  content: Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text("Please contact doctor to approve your request"),
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('OK'),
                                      onPressed: () => Navigator.of(context).pop(),
                                    ),
                                  ],
                                ),
                              );
                              await _startConsultation();
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (ctx) => PatientRouter()),
                              );
                            },
                            child: Text("Start Consultation"),
                          ),
                  ],
                ),
              ),
      ),
    );
  }
}
