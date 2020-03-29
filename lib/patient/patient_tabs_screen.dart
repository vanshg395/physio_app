import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  int _selectedPageIndex = 0;

  @override
  void initState() {
    print('initS');
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
    super.initState();
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
        backgroundColor: Color(0xFF072031),
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
              color: Color(0xff3284ff),
            ),
            title: Text('Video Chat'),
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
              color: Color(0xff3284ff),
            ),
            title: Text('Excercise'),
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
              color: Color(0xff3284ff),
            ),
            title: FittedBox(
              child: Text(
                'Profile',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
