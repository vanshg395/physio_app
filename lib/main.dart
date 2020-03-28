import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './doctor/doctor_tabs_screen.dart';
import './doctor/doctor_register_screen.dart';
import './patient/patient_register_screen.dart';
import './patient/patient_tabs_screen.dart';
import './login_screen.dart';
import './providers/auth.dart';
import './patient/router.dart';

//IndexPage()    ---- Video Calling

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Auth(),
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            home: auth.isAuth
                ? auth.entryLevel == 'First'
                    ? auth.userType == 'Doctor'
                        ? DoctorRegisterScreen()
                        : PatientRegisterScreen()
                    : auth.userType == 'Doctor'
                        ? DoctorTabsScreen()
                        : PatientRouter()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, res) {
                      if (res.connectionState == ConnectionState.waiting) {
                        return Scaffold(
                          body: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else {
                        if (res.data) {
                          return auth.entryLevel == 'First'
                              ? auth.userType == 'Doctor'
                                  ? DoctorRegisterScreen()
                                  : PatientRegisterScreen()
                              : auth.userType == 'Doctor'
                                  ? DoctorTabsScreen()
                                  : PatientRouter();
                        } else {
                          return LoginScreen();
                        }
                      }
                    },
                  )
            // home: PatientRegisterScreen(),
            // home: DoctorRegisterScreen(),
            // home: DoctorTabsScreen(),
            ),
      ),
    );
  }
}
