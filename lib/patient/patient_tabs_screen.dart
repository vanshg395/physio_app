import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import './patient_exercise_screen.dart';
import './patient_consultation_screen.dart';

class PatientTabsScreen extends StatefulWidget {
  @override
  _PatientTabsScreenState createState() => _PatientTabsScreenState();
}

class _PatientTabsScreenState extends State<PatientTabsScreen> {
  List<Map<String, Object>> _pages;
  int _selectedPageIndex = 1;

  @override
  void initState() {
    _pages = [
      {
        'page': PatientConsultationScreen(),
        'title': 'PatConsult',
      },
      {
        'page': PatientExerciseScreen(),
        'title': 'PatExercise',
      },
      // {
      //   'page': DoctorScheduleScreen(),
      //   'title': 'Schedule',
      // },
      // {
      //   'page': AllTeamsScreen(),
      //   'title': 'All Teams',
      // },
      // {
      //   'page': Message(),
      //   'title': 'Messages',
      // },
      // {
      //   'page': EssentialsScreen(),
      //   'title': 'Profile',
      // },
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
              Icons.local_hospital,
              size: 33,
              color: Colors.grey,
            ),
            activeIcon: Icon(
              Icons.local_hospital,
              size: 33,
              color: Color(0xff3284ff),
            ),
            title: Text('Consultation'),
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
              Icons.assessment,
              size: 33,
              color: Colors.grey,
            ),
            activeIcon: Icon(
              Icons.assessment,
              size: 33,
              color: Color(0xff3284ff),
            ),
            title: FittedBox(
                child: Text(
              'Reports',
              textAlign: TextAlign.center,
            )),
          ),
        ],
      ),
    );
  }
}
