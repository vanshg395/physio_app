import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class ExcerciseChartScreen extends StatefulWidget {
  @override
  _ExcerciseChartScreenState createState() => _ExcerciseChartScreenState();
}

class _ExcerciseChartScreenState extends State<ExcerciseChartScreen> {
  bool _isLoading = false;
  List _excercises = [];
  List<String> assignedEvaluators = [];
  List<bool> isSelected = [];

  @override
  void initState() {
    super.initState();
    getExcercise();
  }

  void toggleSelection(String id, int i) {
    setState(() {
      if (isSelected[i]) {
        assignedEvaluators.remove(id);
        isSelected[i] = false;
      } else {
        assignedEvaluators.add(id);
        isSelected[i] = true;
      }
    });
    print(assignedEvaluators);
  }

  Future<void> getExcercise() async {
    setState(() {
      _isLoading = true;
    });
    try {
      String url = 'https://fitknees.herokuapp.com/auth/upload/video/';

      final response = await http.get(
        url,
        headers: {
          'Authorization': Provider.of<Auth>(context, listen: false).token,
        },
      );
      print(response.body);
      final resBody = json.decode(response.body);
      _excercises = resBody;
      for (var i = 0; i < _excercises.length; i++) {
        isSelected.add(false);
      }
    } catch (e) {}
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Excercise Chart'),
      ),
      body: _isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (ctx, i) => Card(
                      child: ListTile(
                        leading: Icon(
                          Icons.play_circle_outline,
                          size: 40,
                        ),
                        title: Text(_excercises[i]['name']),
                        subtitle: Text(_excercises[i]['description']),
                        trailing: isSelected[i]
                            ? Icon(
                                Icons.check,
                                color: Colors.blue,
                              )
                            : null,
                        onTap: () => toggleSelection(
                          _excercises[i]['id'],
                          i,
                        ),
                      ),
                    ),
                    itemCount: _excercises.length,
                  ),
                ),
                Expanded(
                  child: SizedBox(),
                ),
                InkWell(
                  child: Container(
                    color: Colors.red,
                    height: 100,
                    width: double.infinity,
                    child: SafeArea(
                      child: Center(
                        child: Text(
                          'Assign',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    print('Hello');
                  },
                )
              ],
            ),
    );
  }
}
