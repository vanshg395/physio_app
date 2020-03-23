import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './doctor/doctor_register_screen.dart';
import './patient/patient_register_screen.dart';
import './login_screen.dart';
import './providers/auth.dart';

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
                  : LoginScreen()
              : LoginScreen(),
        ),
      ),
    );
  }
}
