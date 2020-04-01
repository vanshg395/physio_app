import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class DoctorRegisterScreen extends StatefulWidget {
  @override
  _DoctorRegisterScreenState createState() => _DoctorRegisterScreenState();
}

class _DoctorRegisterScreenState extends State<DoctorRegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String _hospital;
  String _designation;
  String _dept;
  String _seqQues;
  bool _isLoading = false;
  bool _isLoading2 = false;
  List<dynamic> _hospitals = [];
  Map<String, dynamic> _data = {
    'docinfo': '',
    'hospital': '',
    'department': '',
    'designation': '',
    'security_question': '',
    'security_answer': '',
  };

  @override
  void initState() {
    super.initState();
    getHospitals();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      String url = 'https://fitknees.herokuapp.com/auth/doctor/';

      final response = await http.post(
        url,
        headers: {
          'Authorization': Provider.of<Auth>(context, listen: false).token,
        },
        body: _data,
      );
      if (response.statusCode == 200) {
        await Provider.of<Auth>(context, listen: false).changeEntryLevel();
      }
    } catch (e) {
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> getHospitals() async {
    String url = 'https://fitknees.herokuapp.com/auth/hospitals/';

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': Provider.of<Auth>(context, listen: false).token,
        },
      );
      final responseBody = json.decode(response.body);
      setState(() {
        _hospitals = responseBody;
      });
    } catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Personal Details',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'First Name',
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
                    keyboardAppearance: Brightness.light,
                    validator: (val) {
                      if (val == '') {
                        return 'This Field is required.';
                      }
                    },
                    onSaved: (val) {
                      _data['docinfo'] =
                          Provider.of<Auth>(context, listen: false).id;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    // controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
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
                    keyboardAppearance: Brightness.light,
                    validator: (val) {
                      if (val == '') {
                        return 'This Field is required.';
                      }
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  _isLoading2
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(
                              Colors.grey,
                            ),
                          ),
                        )
                      : DropDownFormField(
                          titleText: 'Hospital',
                          hintText: 'Please choose one',
                          required: true,
                          value: _hospital,
                          onSaved: (value) {
                            setState(() {
                              _hospital = value;
                              _data['hospital'] = value;
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              _hospital = value;
                            });
                          },
                          dataSource: _hospitals,
                          textField: 'hospital',
                          valueField: 'id',
                        ),
                  SizedBox(
                    height: 15,
                  ),
                  DropDownFormField(
                    titleText: 'Designation',
                    hintText: 'Please choose one',
                    required: true,
                    value: _designation,
                    onSaved: (value) {
                      setState(() {
                        _designation = value;
                        _data['designation'] = value;
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        _designation = value;
                      });
                    },
                    dataSource: [
                      {
                        "display": "OD",
                        "value": "OD",
                      },
                      {
                        "display": "BPT",
                        "value": "BPT",
                      },
                      {
                        "display": "MPT",
                        "value": "MPT",
                      },
                      {
                        "display": "MS",
                        "value": "MS",
                      },
                      {
                        "display": "MD",
                        "value": "MD",
                      },
                      {
                        "display": "MBBS",
                        "value": "MBBS",
                      },
                    ],
                    textField: 'display',
                    valueField: 'value',
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  DropDownFormField(
                    titleText: 'Department',
                    hintText: 'Please choose one',
                    required: true,
                    value: _dept,
                    onSaved: (value) {
                      setState(() {
                        _dept = value;
                        _data['department'] = value;
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        _dept = value;
                      });
                    },
                    dataSource: [
                      {
                        "display": "Orthopedics",
                        "value": "Orthopedics",
                      },
                      {
                        "display": "Occupational Therapy",
                        "value": "Occupational Therapy",
                      },
                      {
                        "display": "Physiotherapists",
                        "value": "Physiotherapists",
                      },
                    ],
                    textField: 'display',
                    valueField: 'value',
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  DropDownFormField(
                    titleText: 'Security Question',
                    hintText: 'Please choose one',
                    required: true,
                    value: _seqQues,
                    onSaved: (value) {
                      setState(() {
                        _seqQues = value;
                        _data['security_question'] = value;
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        _seqQues = value;
                      });
                    },
                    dataSource: [
                      {
                        "display": "What is your pet's name?",
                        "value": "What is your pet's name?",
                      },
                      {
                        "display": "What is your father's middle name?",
                        "value": "What is your father's middle name?",
                      },
                      {
                        "display": "Your favourite colour?",
                        "value": "Your favourite colour?",
                      },
                    ],
                    textField: 'display',
                    valueField: 'value',
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    maxLines: 1,
                    decoration: InputDecoration(
                      labelText: 'Answer',
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
                    keyboardAppearance: Brightness.light,
                    validator: (val) {
                      if (val == '') {
                        return 'This Field is required.';
                      }
                    },
                    onSaved: (value) {
                      _data['security_answer'] = value;
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 40,
                    ),
                    height: 40,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
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
                                'SUBMIT',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'SFProTextSemiMed',
                                ),
                              ),
                              onPressed: _submit,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
