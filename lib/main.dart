import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import './doctor/doctor_tabs_screen.dart';
import './doctor/doctor_register_screen.dart';
import './patient/patient_register_screen.dart';
import './login_screen.dart';
import './providers/auth.dart';
import './patient/router.dart';


void main() => runApp(
      RestartWidget(
        child: MyApp(),
      ),
    );

class RestartWidget extends StatefulWidget {
  RestartWidget({this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>().restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  bool videoCall = false;
  
  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    FirebaseAnalytics analytics = FirebaseAnalytics();

    return ChangeNotifierProvider.value(
      value: Auth(),
      child: Consumer<Auth>(
        builder: (ctx, auth, _) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              navigatorObservers: [
                  FirebaseAnalyticsObserver(analytics: analytics),
                ],
              theme: ThemeData.light().copyWith(
                primaryColor: Color(0xFF607EEA),
              ),
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
                    ));
        },
      ),
    );
  }
}
