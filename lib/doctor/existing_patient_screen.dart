import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:physio_app/doctor/patient_overview_scren.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../providers/auth.dart';
import '../videocall/pages/call.dart';

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
      print(response.body);
      print(response.statusCode);
      final responseBody = json.decode(response.body);
      _patients = responseBody['patients'];
      print(_patients);
      _docId = responseBody['docHandlerId'];
    } catch (e) {
      print(e);
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
    print(initials);
    initials = initials.toUpperCase();
    return initials;
  }

  Future<void> makeVideoCall(docId, patientId) async {
    String url = 'https://fitknees.herokuapp.com/auth/patient/vcall/';

    try {
      final response = await http.post(url, headers: {
        'Authorization': Provider.of<Auth>(context, listen: false).token,
      }, body: {
        'doctor': docId,
        'patient': patientId,
      });
      final responseBody = json.decode(response.body);
      print(responseBody);
      print(response.statusCode);
      final channelName = responseBody[0]['channel'];

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(
            channelName: channelName,
          ),
        ),
      );
    } catch (e) {
      print(e);
    }
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
                      child: CircularProgressIndicator(),
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
                                      child: Text(''),
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(
                                        Icons.video_call,
                                        size: 30,
                                      ),
                                      onPressed: () async {
                                        await makeVideoCall(
                                            Provider.of<Auth>(context,
                                                    listen: false)
                                                .id,
                                            _patients[i]['patHandlerID']);
                                      },
                                      color: Colors.green,
                                    ),
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (ctx) =>
                                              PatientOverviewScreen(
                                            name: _patients[i]['fullName'],
                                            patId: _patients[i]['patHandlerID'],
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
