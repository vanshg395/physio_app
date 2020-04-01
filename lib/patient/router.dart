import 'dart:io';

import 'package:edge_alert/edge_alert.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:physio_app/patient/Patient_waiting.dart';
import 'package:physio_app/patient/patient_consultation_screen.dart';
import 'package:physio_app/providers/auth.dart';
import 'package:provider/provider.dart';
import 'package:physio_app/patient/patient_tabs_screen.dart';

class PatientRouter extends StatefulWidget {
  @override
  _PatientRouterState createState() => _PatientRouterState();
}

class _PatientRouterState extends State<PatientRouter> {
  int statusCode = 0;
final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    getConsols();
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        if (message['data']['title']=="Doc-con-apr"){
          EdgeAlert.show(
            context,
            title: message['notification']['title'],
            description: message['notification']['body'],
            gravity: EdgeAlert.TOP,
            backgroundColor: Colors.green
          );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PatientTabsScreen()
          ),
        );
        }
        else if (message['data']['title']=="Doc-con-rej"){
          EdgeAlert.show(
            context,
            title: message['notification']['title'],
            description: message['notification']['body'],
            gravity: EdgeAlert.TOP,
            backgroundColor: Colors.red
          );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PatientRouter()
          ),
        );
        }
        else{
            EdgeAlert.show(
            context,
            title: message['notification']['title'],
            description: message['notification']['body'],
            gravity: EdgeAlert.TOP,
            backgroundColor: Colors.green
          );
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        if (message['data']['title']=="Doc-con-apr"){
          EdgeAlert.show(
            context,
            title: message['notification']['title'],
            description: message['notification']['body'],
            gravity: EdgeAlert.TOP,
            backgroundColor: Colors.green
          );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PatientTabsScreen()
          ),
        );
        }
        else if (message['data']['title']=="Doc-con-rej"){
          EdgeAlert.show(
            context,
            title: message['notification']['title'],
            description: message['notification']['body'],
            gravity: EdgeAlert.TOP,
            backgroundColor: Colors.red
          );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PatientRouter()
          ),
        );
        }
        else{
            EdgeAlert.show(
            context,
            title: message['notification']['title'],
            description: message['notification']['body'],
            gravity: EdgeAlert.TOP,
            backgroundColor: Colors.green
          );
        }
      },
      onResume: (Map<String, dynamic> message) async {
        if (message['data']['title']=="Doc-con-apr"){
          EdgeAlert.show(
            context,
            title: message['notification']['title'],
            description: message['notification']['body'],
            gravity: EdgeAlert.TOP,
            backgroundColor: Colors.green
          );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PatientTabsScreen()
          ),
        );
        }
        else if (message['data']['title']=="Doc-con-rej"){
          EdgeAlert.show(
            context,
            title: message['notification']['title'],
            description: message['notification']['body'],
            gravity: EdgeAlert.TOP,
            backgroundColor: Colors.red
          );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PatientRouter()
          ),
        );
        }
        else{
            EdgeAlert.show(
            context,
            title: message['notification']['title'],
            description: message['notification']['body'],
            gravity: EdgeAlert.TOP,
            backgroundColor: Colors.green
          );
        }
      }
      );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
    });
  }

  Future<void> getConsols() async {
    try {
      await Provider.of<Auth>(context, listen: false).getConsol();
      statusCode = Provider.of<Auth>(context, listen: false).consulstatusget;
       if (statusCode == 3) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => PatientTabsScreen()),
        );
      } else if (statusCode == 2) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => PatientwaitingScreen()),
        );
      } else if(statusCode==0){
         Navigator.of(context).pushReplacement(
           MaterialPageRoute(builder: (ctx) => PatientConsultationScreen()),
         );
       }
       else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => PatientConsultationScreen()),
        );
      }
    } catch (error) {
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
