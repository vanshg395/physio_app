import 'dart:convert';
import 'dart:io';

import 'package:edge_alert/edge_alert.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import './doctor_add_video.dart';

class ExcerciseChartScreen extends StatefulWidget {
  final String consolId;

  const ExcerciseChartScreen({Key key, this.consolId}) : super(key: key);
  @override
  _ExcerciseChartScreenState createState() => _ExcerciseChartScreenState();
}

class _ExcerciseChartScreenState extends State<ExcerciseChartScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _isLoading = false;
  List _excercises = [];
  List<Map<String, dynamic>> assignedExercises = [];
  List<bool> isSelected = [];
  TextEditingController _nameC = TextEditingController();
  TextEditingController _noteC = TextEditingController();

  @override
  void initState() {
    super.initState();
    getExcercise();
  }

  Future<void> toggleSelection(String id, int i) async {
    if (isSelected[i]) {
      setState(() {
        assignedExercises.removeWhere((element) => element['videoId'] == id);
        isSelected[i] = false;
      });
    } else {
      final _res = await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) => BottomSheet(),
      );
      print(_res);
      setState(() {
        assignedExercises.add({
          'videoId': id,
          'sets': _res[0],
          'reps': _res[1],
        });
        isSelected[i] = true;
      });
    }
    print(assignedExercises);
  }

  Future<void> assign() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    if (assignedExercises == []) {
      return;
    }
    try {
      String url = 'https://fitknees.herokuapp.com/auth/excercise/';
      print({
        'name': _nameC.text,
        'notes': _noteC.text,
        'consolId': widget.consolId,
        'data': assignedExercises,
      });
      final response = await http.post(
        url,
        headers: {
          'Authorization': Provider.of<Auth>(context, listen: false).token,
          'content-type': 'application/json',
        },
        body: json.encode({
          'name': _nameC.text,
          'notes': _noteC.text,
          'consolId': widget.consolId,
          'data': assignedExercises,
        }),
      );
      print(response.statusCode);
      if (response.statusCode >= 200 && response.statusCode < 299) {
        Navigator.of(context).pop();
      } else {
        EdgeAlert.show(
          context,
          title: 'Invalid Consultation',
          description:
              'This patient doesn\'t have a consultation. Exercises could not be assigned.',
          gravity: EdgeAlert.BOTTOM,
          backgroundColor: Colors.red,
          duration: 5,
        );
      }
      print(response.body);
    } catch (e) {
      print('err');
      print(e);
    }
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Exercise Chart'),
      ),
      body: _isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextFormField(
                      controller: _nameC,
                      decoration: InputDecoration(
                        labelText: 'Name of Exercise List',
                        labelStyle: TextStyle(color: Colors.grey),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      keyboardAppearance: Brightness.light,
                      validator: (val) {
                        if (val == '') {
                          return 'This field is required.';
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextFormField(
                      maxLines: 3,
                      controller: _noteC,
                      decoration: InputDecoration(
                        labelText: 'Notes',
                        labelStyle: TextStyle(color: Colors.grey),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      keyboardAppearance: Brightness.light,
                    ),
                  ),
                  Expanded(
                    child: Padding(
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
                  ),
                  Container(
                    height: Platform.isAndroid ? 60 : 80,
                    width: double.infinity,
                    color: Color(0xFF607EEA),
                    child: SafeArea(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Expanded(
                            child: FlatButton(
                              textColor: Colors.white,
                              child: Text('Add Video'),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (ctx) => DoctorVideoAdd()),
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: FlatButton(
                              textColor: Colors.white,
                              child: Text('Assign'),
                              onPressed: () async {
                                await assign();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class BottomSheet extends StatefulWidget {
  @override
  _BottomSheetState createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheet> {
  bool _isLoading = false;
  TextEditingController _setsC = TextEditingController();
  TextEditingController _repsC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 30,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: _setsC,
              decoration: InputDecoration(
                labelText: 'Sets',
                labelStyle: TextStyle(color: Colors.grey),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              keyboardAppearance: Brightness.light,
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: _repsC,
              decoration: InputDecoration(
                labelText: 'Reps',
                labelStyle: TextStyle(color: Colors.grey),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              keyboardAppearance: Brightness.light,
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                            Colors.grey,
                          ),
                        ),
                      )
                    : RaisedButton(
                        color: Colors.grey[350],
                        textColor: Colors.black,
                        child: Text(
                          'ADD',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'SFProTextSemiMed',
                          ),
                        ),
                        // onPressed: _submit,
                        onPressed: () {
                          Navigator.of(context).pop([_setsC.text, _repsC.text]);
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
