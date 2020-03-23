import 'package:flutter/material.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

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
                    // controller: _emailController,
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
                    // onSaved: (val) {
                    //   _authData['email'] = val;
                    // },
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
                    // onSaved: (val) {
                    //   _authData['email'] = val;
                    // },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  DropDownFormField(
                    titleText: 'Hospital',
                    hintText: 'Please choose one',
                    required: true,
                    value: _hospital,
                    onSaved: (value) {
                      setState(() {
                        _hospital = value;
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        _hospital = value;
                      });
                    },
                    dataSource: [
                      {
                        "display": "Running",
                        "value": "Running",
                      },
                      {
                        "display": "Climbing",
                        "value": "Climbing",
                      },
                      {
                        "display": "Walking",
                        "value": "Walking",
                      },
                      {
                        "display": "Swimming",
                        "value": "Swimming",
                      },
                      {
                        "display": "Soccer Practice",
                        "value": "Soccer Practice",
                      },
                      {
                        "display": "Baseball Practice",
                        "value": "Baseball Practice",
                      },
                      {
                        "display": "Football Practice",
                        "value": "Football Practice",
                      },
                    ],
                    textField: 'display',
                    valueField: 'value',
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
                        "display": "DPT",
                        "value": "DPT",
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
                        "display": "Rehabilitation",
                        "value": "Rehabilitation",
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
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        _seqQues = value;
                      });
                    },
                    dataSource: [
                      {
                        "display":
                            "What was the name of your elementary school?",
                        "value": "What was the name of your elementary school?",
                      },
                      {
                        "display":
                            "In what city or town does your nearest sibling live?",
                        "value":
                            "In what city or town does your nearest sibling live?",
                      },
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
                              // onPressed: _submit,
                              onPressed: () {},
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