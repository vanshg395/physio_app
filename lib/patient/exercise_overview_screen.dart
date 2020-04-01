import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../providers/auth.dart';
import './video_screen.dart';

class ExerciseOverviewScreen extends StatefulWidget {
  @override
  _ExerciseOverviewScreenState createState() => _ExerciseOverviewScreenState();
  List _exerciseData = [];
  String _exId;
  ExerciseOverviewScreen(this._exerciseData, this._exId);
}

class _ExerciseOverviewScreenState extends State<ExerciseOverviewScreen> {
  bool _isLoading = false;
  bool _isLoading2 = false;

  List<bool> _exerciseDone = [];

  @override
  void initState() {
    super.initState();
    print(widget._exerciseData);
    for (var i = 0; i < widget._exerciseData.length; i++) {
      _exerciseDone.add(false);
    }
  }

  bool get isAllExDone {
    for (var item in _exerciseDone) {
      if (item == false) {
        return false;
      }
    }
    return true;
  }

  Future<void> _submit() async {
    if (!isAllExDone) {
      await showDialog(
        context: context,
        child: Platform.isIOS
            ? CupertinoAlertDialog(
                title: Text('Error'),
                content:
                    Text('First Complete all exercised before submitting.'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('Ok'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              )
            : AlertDialog(
                title: Text('Error'),
                content:
                    Text('First Complete all exercised before submitting.'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
      );
      return;
    }
    setState(() {
      _isLoading2 = true;
    });
    try {
      String url = 'https://fitknees.herokuapp.com/auth/report/';

      final response = await http.post(
        url,
        headers: {
          'Authorization': Provider.of<Auth>(context, listen: false).token,
        },
        body: {'exercise': widget._exId},
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
      }
    } catch (e) {}
    setState(() {
      _isLoading2 = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Exercise Chart',
        ),
      ),
      body: Container(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: <Widget>[
                  SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (ctx, i) => Card(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          elevation: 3,
                          child: ListTile(
                              leading: IconButton(
                                icon: Icon(
                                  Icons.play_circle_outline,
                                  size: 30,
                                ),
                                onPressed: () {
                                  print('hey');
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) => VideoScreen(
                                          widget._exerciseData[i]['video_name'],
                                          widget._exerciseData[i]['video']),
                                    ),
                                  );
                                },
                              ),
                              title:
                                  Text(widget._exerciseData[i]['video_name']),
                              subtitle: Text(widget._exerciseData[i]['sets']
                                      .toString() +
                                  ' Sets X ' +
                                  widget._exerciseData[i]['reps'].toString() +
                                  ' Reps'),
                              trailing: _exerciseDone[i]
                                  ? Icon(
                                      Icons.check_box,
                                      color: Colors.green,
                                    )
                                  : IconButton(
                                      icon: Icon(
                                        Icons.check_box_outline_blank,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _exerciseDone[i] = true;
                                        });
                                      },
                                    )),
                        ),
                        itemCount: widget._exerciseData.length,
                      ),
                    ),
                  ),
                  Container(
                    height: Platform.isAndroid ? 60 : 80,
                    width: double.infinity,
                    color: Color(0xFF607EEA),
                    child: SafeArea(
                      child: _isLoading2
                          ? Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(
                                  Colors.grey,
                                ),
                              ),
                            )
                          : InkWell(
                              child: Center(
                                child: Text(
                                  'Submit',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                  ),
                                ),
                              ),
                              onTap: _submit,
                            ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
