import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../providers/auth.dart';
import './video_screen.dart';

class ExerciseOverviewScreen extends StatefulWidget {
  @override
  _ExerciseOverviewScreenState createState() => _ExerciseOverviewScreenState();
  List _exerciseData = [];
  ExerciseOverviewScreen(this._exerciseData);
}

class _ExerciseOverviewScreenState extends State<ExerciseOverviewScreen> {
  bool _isLoading = false;

  List<bool> _exerciseDone = [];

  @override
  void initState() {
    super.initState();
    print(widget._exerciseData);
    for (var i = 0; i < widget._exerciseData.length; i++) {
      _exerciseDone.add(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
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
                    Flexible(
                      child: Container(
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
                                            widget._exerciseData[i]
                                                ['video_name'],
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
                  ],
                ),
              ),
      ),
    );
  }
}
