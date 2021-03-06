import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:physio_app/doctor/patient_overview_scren.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../providers/auth.dart';

class ExistingPatientScreen extends StatefulWidget {
  @override
  _ExistingPatientScreenState createState() => _ExistingPatientScreenState();
}

class _ExistingPatientScreenState extends State<ExistingPatientScreen> {
  bool _isLoading = false;
  List<dynamic> _patients = [];
  String _docId;

  @override
  void initState() {
    super.initState();
    getPatients();
    _handleCameraAndMic();
  }

  Future<void> _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }

  Future<void> getPatients() async {
    setState(() {
      _isLoading = true;
    });
    try {
      String url = 'https://fitknees.herokuapp.com/auth/assign/';

      final response = await http.get(
        url,
        headers: {
          'Authorization': Provider.of<Auth>(context, listen: false).token,
        },
      );
      final responseBody = json.decode(response.body);
      _patients = responseBody['patients'];
      _docId = responseBody['docHandlerId'];
    } catch (e) {
    }
    setState(() {
      _isLoading = false;
    });
  }

  String getInitials(String name) {
    String initials = '';
    if (name == '') {
      return '';
    }
    initials = name[0];
    for (var i = 0; i < name.length; i++) {
      if (name[i] == ' ') {
        initials += name[i + 1];
        break;
      }
    }
    initials = initials.toUpperCase();
    return initials;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Text(
              'Existing Patients',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            _isLoading
                ? Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(
                          Colors.grey,
                        ),
                      ),
                    ),
                  )
                : (_patients.length == 0 || _patients == null)
                    ? Expanded(
                        child: Center(
                          child: Text('There are no patients for you.'),
                        ),
                      )
                    : Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (ctx, i) => Column(
                            children: <Widget>[
                              Card(
                                color: Colors.grey[100],
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: ListTile(
                                    title: Text(_patients[i]['fullName']),
                                    leading: CircleAvatar(
                                      child: Text(
                                        getInitials(_patients[i]['fullName']),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (ctx) =>
                                              PatientOverviewScreen(
                                            name: _patients[i]['fullName'],
                                            patId: _patients[i]['patHandlerID'],
                                            medCond: _patients[i]['medical'],
                                            docId: _docId,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Divider(),
                            ],
                          ),
                          itemCount: _patients.length,
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
