import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:edge_alert/edge_alert.dart';

import './doctor/doctor_tabs_screen.dart';
import './doctor/doctor_register_screen.dart';
import './patient/patient_register_screen.dart';
import './login_screen.dart';
import './providers/auth.dart';
import './patient/router.dart';

//IndexPage()    ---- Video Calling

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

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool videoCall = false;
  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("YO MAMA 0");
        print("onMessage: $message");
        print(message);
        print("chlna chahiye");
        EdgeAlert.show(
          context,
          title: 'Incoming Video Call',
          description: 'Your Physiotherapist is calling you',
          gravity: EdgeAlert.TOP,
          backgroundColor: Colors.red,
        );
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
  }

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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return ChangeNotifierProvider.value(
      value: Auth(),
      child: Consumer<Auth>(
        builder: (ctx, auth, _) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
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
