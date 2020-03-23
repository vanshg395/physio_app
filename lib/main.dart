import 'package:flutter/material.dart';
import 'package:physio_app/patient/patient_register_screen.dart';

import './login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PatientRegisterScreen(),
    );
  }
}
