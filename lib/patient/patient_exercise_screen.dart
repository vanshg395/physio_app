import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import './exercise_overview_screen.dart';
import '../providers/auth.dart';

class PatientExerciseScreen extends StatefulWidget {
  @override
  _PatientExerciseScreenState createState() => _PatientExerciseScreenState();
}

class _PatientExerciseScreenState extends State<PatientExerciseScreen> {
  bool _isLoading = false;
  List _exerciseData = [];
  List<bool> _exerciseDone = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      String url =
          'https://fitknees.herokuapp.com/auth/excercise/';

      final response = await http.get(
        url,
        headers: {
          'Authorization': Provider.of<Auth>(context, listen: false).token,
        },
      );
      final resBody = json.decode(response.body);
      _exerciseData = resBody;
      for (var i = 0; i < _exerciseData.length; i++) {
        _exerciseDone.add(false);
      }
    } catch (e) {
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Column(
                children: <Widget>[
                  Text(
                    'Exercise Chart',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  _exerciseData.length == 0
                      ? Expanded(
                          child: Center(
                            child: Text('No Exercises for you!'),
                          ),
                        )
                      : Flexible(
                          child: Container(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (ctx, i) => Card(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                elevation: 3,
                                child: ListTile(
                                  title: Text(_exerciseData[i]['name']),
                                  subtitle: Text(_exerciseData[i]['des']),
                                  trailing: IconButton(
                                    icon: Icon(Icons.arrow_forward_ios),
                                    onPressed: () {
                                      print('hey');
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ExerciseOverviewScreen(
                                            _exerciseData[i]['data'],
                                            _exerciseData[i]['id'],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              itemCount: _exerciseData.length,
                            ),
                          ),
                        ),
                ],
              ),
            ),
    );
  }
}
