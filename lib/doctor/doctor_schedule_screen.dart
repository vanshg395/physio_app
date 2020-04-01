import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:physio_app/providers/auth.dart';
import 'package:provider/provider.dart';

class DoctorScheduleScreen extends StatefulWidget {
  @override
  _DoctorScheduleScreenState createState() => _DoctorScheduleScreenState();
}

class _DoctorScheduleScreenState extends State<DoctorScheduleScreen> {
  List<dynamic> _consults = [];
  bool _isLoading = false;
  bool _isLoading2 = false;

  var _res;

  Future<void> _getConsults() async {
    String url = 'https://fitknees.herokuapp.com/auth/myconsults/';
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': Provider.of<Auth>(context, listen: false).token,
        },
      );
      final responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        _consults = responseBody;
      }
    } catch (e) {
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _settingModalBottomSheet(context, String id) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                _isLoading2
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : new ListTile(
                        leading: new Icon(Icons.add),
                        title: new Text('Approve'),
                        onTap: () async {
                          setState(() {
                            _isLoading2 = true;
                          });
                          Navigator.of(context).pop();
                          await _approve(id, context);
                          setState(() {
                            _isLoading2 = false;
                          });
                        }),
                new ListTile(
                    leading: new Icon(Icons.remove),
                    title: new Text('Dis Approve'),
                    onTap: () async {
                      await _disApprove(id, context);
                      Navigator.of(context).pop();
                    }),
              ],
            ),
          );
        });
  }

  void _settingModalBottomSheet1(context, String id) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                _isLoading2
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : new ListTile(
                        leading: new Icon(Icons.close),
                        title: new Text('Close Consultation'),
                        onTap: () async {
                          setState(() {
                            _isLoading2 = true;
                          });
                          Navigator.of(context).pop();
                          await _closeCase(id, context);
                          setState(() {
                            _isLoading2 = false;
                          });
                        }),
                new ListTile(
                  leading: new Icon(Icons.cancel),
                  title: new Text('Cancel'),
                  onTap: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          );
        });
  }

  _approve(String id, context) async {
    String url = 'https://fitknees.herokuapp.com/auth/approve/';

    try {
      final response = await http.post(url, body: {
        'consolId': id,
      });
      if (response.statusCode == 200) {
        await _getConsults();
      }
    } catch (e) {
    }
  }

  _disApprove(String id, context) async {
    String url = 'https://fitknees.herokuapp.com/auth/disapprove/';

    try {
      final response = await http.post(url, headers: {
        'Authorization': Provider.of<Auth>(context, listen: false).token,
      }, body: {
        'consolId': id,
      });
      if (response.statusCode == 200) {
        await _getConsults();
      }
    } catch (e) {
    }
  }

  _closeCase(String id, context) async {
    String url = 'https://fitknees.herokuapp.com/auth/close/';

    try {
      final response = await http.post(url, headers: {
        'Authorization': Provider.of<Auth>(context, listen: false).token,
      }, body: {
        'consolId': id,
      });
      if (response.statusCode == 200) {
        await _getConsults();
      }
    } catch (e) {
    }
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
  void initState() {
    super.initState();
    _getConsults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Text(
              'Consultations',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
              ),
            ),
            _isLoading
                ? Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : _isLoading2
                    ? Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : _consults.length == 0
                        ? Expanded(
                            child: Center(
                              child: Text('No Consultations for You'),
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
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child: ListTile(
                                          title: Text(_consults[i]['name']),
                                          subtitle: _consults[i]['doc_approval']
                                              ? Text('Approved')
                                              : Text('Not Approved'),
                                          leading: CircleAvatar(
                                            child: Text(
                                              getInitials(_consults[i]['name']),
                                            ),
                                          ),
                                          onTap: () {
                                            _consults[i]['doc_approval']
                                                ? _settingModalBottomSheet1(
                                                    context,
                                                    _consults[i]['consul_id'])
                                                : _settingModalBottomSheet(
                                                    context,
                                                    _consults[i]['consul_id']);
                                          }),
                                    ),
                                  ),
                                  Divider(),
                                ],
                              ),
                              itemCount: _consults.length,
                            ),
                          )
          ],
        ),
      ),
    );
  }
}
