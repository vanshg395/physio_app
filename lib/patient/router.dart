import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:physio_app/patient/patient_tabs_screen1.dart';
import 'package:physio_app/patient/patient_tabs_screen2.dart';
import 'package:physio_app/patient/patient_tabs_screen3.dart';
import 'package:physio_app/providers/auth.dart';
import 'package:provider/provider.dart';
import 'package:physio_app/patient/patient_tabs_screen.dart';

class PatientRouter extends StatefulWidget {
  @override
  _PatientRouterState createState() => _PatientRouterState();
}

class _PatientRouterState extends State<PatientRouter> {
  int statusCode = 0;

  @override
  void initState() {
    getConsols();
    super.initState();
  }

  Future<void> getConsols() async {
    try {
      print('FUCKK');
      await Provider.of<Auth>(context, listen: false).getConsol();
      statusCode = Provider.of<Auth>(context, listen: false).consulstatusget;
      print(statusCode);
      if (statusCode == 0) {
        //
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => PatientTabsScreen1()),
        );
      } else if (statusCode == 1) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => PatientTabsScreen3()),
        );
      } else if (statusCode == 2) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => PatientTabsScreen2()),
        );
      } else {
        print('doin change');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => PatientTabsScreen()),
        );
      }
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
