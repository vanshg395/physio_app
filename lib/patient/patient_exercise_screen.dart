import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../providers/auth.dart';
import './video_screen.dart';

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
      final id = Provider.of<Auth>(context, listen: false).id;
      print(id);
      print(Provider.of<Auth>(context, listen: false).token);
      String url =
          'https://fitknees.herokuapp.com/auth/excercise/?id=e37a6b92-5018-455a-8bae-3d1f9e587d4f';

      final response = await http.get(
        url,
        headers: {
          'Authorization': Provider.of<Auth>(context, listen: false).token,
        },
      );
      final resBody = json.decode(response.body);
      print(resBody);
      _exerciseData = resBody;
      for (var i = 0; i < _exerciseData.length; i++) {
        _exerciseDone.add(false);
      }
      print(_exerciseData[1]);
    } catch (e) {
      print('err');
      print(e);
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                                        _exerciseData[i][0]['chart_root']
                                            ['name'],
                                        _exerciseData[i][0]['video_handler']
                                            ['video']),
                                  ),
                                );
                              },
                            ),
                            title:
                                Text(_exerciseData[i][0]['chart_root']['name']),
                            subtitle: Text(
                                _exerciseData[i][0]['sets'].toString() +
                                    ' Sets X ' +
                                    _exerciseData[i][0]['reps'].toString() +
                                    ' Reps'),
                            trailing: _exerciseDone[i]
                                ? Icon(
                                    Icons.done,
                                    color: Colors.green,
                                  )
                                : IconButton(
                                    icon: Icon(Icons.hourglass_empty),
                                    onPressed: () {
                                      setState(() {
                                        _exerciseDone[i] = true;
                                      });
                                    },
                                  )),
                      ),
                      itemCount: _exerciseData.length,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
