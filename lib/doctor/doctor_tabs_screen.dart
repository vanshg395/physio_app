import 'package:flutter/material.dart';

import './existing_patient_screen.dart';
import './add_patient_screen.dart';
import './doctor_schedule_screen.dart';

class DoctorTabsScreen extends StatefulWidget {
  @override
  _DoctorTabsScreenState createState() => _DoctorTabsScreenState();
}

class _DoctorTabsScreenState extends State<DoctorTabsScreen> {
  List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;

  @override
  void initState() {
    _pages = [
      {
        'page': AddPatientScreen(),
        'title': 'AddPatient',
      },
      {
        'page': ExistingPatientScreen(),
        'title': 'ExistingPatient',
      },
      {
        'page': DoctorScheduleScreen(),
        'title': 'Schedule',
      },
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
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_add,
              size: 33,
              color: Colors.grey,
            ),
            activeIcon: Icon(
              Icons.person_add,
              size: 33,
              color: Color(0xff3284ff),
            ),
            title: SizedBox(),
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
            title: SizedBox(),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.schedule,
              size: 33,
              color: Colors.grey,
            ),
            activeIcon: Icon(
              Icons.schedule,
              size: 33,
              color: Color(0xff3284ff),
            ),
            title: SizedBox(),
          ),
        ],
      ),
    );
  }
}
