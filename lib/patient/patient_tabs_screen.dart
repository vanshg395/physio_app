import 'package:edge_alert/edge_alert.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:physio_app/videocall/intializeCall.dart';

import './patient_profile_screen.dart';
import './patient_exercise_screen.dart';
import './patient_consultation_screen.dart';
import './patients_reports.dart';
import './temp_video.dart';

class PatientTabsScreen extends StatefulWidget {
  @override
  _PatientTabsScreenState createState() => _PatientTabsScreenState();
}

class _PatientTabsScreenState extends State<PatientTabsScreen> {
  List<Map<String, Object>> _pages;
<<<<<<< HEAD
  int _selectedPageIndex = 0;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
=======
  int _selectedPageIndex = 1;
final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
>>>>>>> bd7b0e6e87edfe33fe03ab19f3042eba69d19a3c

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("YO MAMA 0");
        print("onMessage: $message");
        print(message);
        print("chlna chahiye");
        print("Context    :" + context.toString());
        print("chlna chahiy");
        print('1' + message['title']);
        print('2' + 'video-call-by-doc');

        if (message['data']['title'] == "video-call-by-doc" ||
            message['title'] == "video-call-by-doc") {
          print('hey');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => IntializeVideoCall(),
            ),
          );
        } else {
          print('bi');
          EdgeAlert.show(context,
              title: message['notification']['title'],
              description: message['notification']['body'],
              gravity: EdgeAlert.TOP,
              backgroundColor: Colors.green);
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("YO MAMA 1");
        print("onLaunch: $message");
        print(message);
        EdgeAlert.show(
          context,
          title: 'Incoming Video Call',
          description: 'Your Physiotherapist is calling you',
          gravity: EdgeAlert.TOP,
          backgroundColor: Colors.red,
        );
        print("Context    :" + context.toString());
      },
      onResume: (Map<String, dynamic> message) async {
        print("YO MAMA 2");
        print("onResume: $message");
        print(message);
        EdgeAlert.show(
          context,
          title: 'Incoming Video Call',
          description: 'Your Physiotherapist is calling you',
          gravity: EdgeAlert.TOP,
          backgroundColor: Colors.red,
        );
        print("Context    :" + context.toString());
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print(token);
    });
    _pages = [
      {
        'page': VideoPatientScreen(),
        'title': 'Schedule',
      },
      {
        'page': PatientExerciseScreen(),
        'title': 'PatExercise',
      },
      {
        'page': PatientProfileScreen(),
        'title': 'Profile',
      },
    ];
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('objectss');
    return Scaffold(
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Color(0xFF607EEA),
        unselectedItemColor: Colors.white,
        currentIndex: _selectedPageIndex,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.video,
              size: 33,
              color: Colors.grey,
            ),
            activeIcon: Icon(
              FontAwesomeIcons.video,
              size: 33,
              color: Colors.white,
            ),
            title: Text(
              'Video Chat',
              style: TextStyle(color: Colors.white),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.dumbbell,
              size: 33,
              color: Colors.grey,
            ),
            activeIcon: Icon(
              FontAwesomeIcons.dumbbell,
              size: 33,
              color: Colors.white,
            ),
            title: Text(
              'Excercise',
              style: TextStyle(color: Colors.white),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 33,
              color: Colors.grey,
            ),
            activeIcon: Icon(
              Icons.person,
              size: 33,
              color: Colors.white,
            ),
            title: FittedBox(
              child: Text(
                'Profile',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
