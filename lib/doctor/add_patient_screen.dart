import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../providers/auth.dart';

class AddPatientScreen extends StatefulWidget {
  @override
  _AddPatientScreenState createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool visisblePassword = false;
  bool _isLoading = false;
  Map<String, dynamic> _data = {
    'fname': '',
    'lname': '',
    'email': '',
    'doctor': '',
    'medical': '',
  };
  TextEditingController _fnameController = TextEditingController();
  TextEditingController _lnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _medController = TextEditingController();

  @override
  void dispose() {
    _fnameController.dispose();
    _lnameController.dispose();
    _emailController.dispose();
    _medController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    print(_data);
    setState(() {
      _isLoading = true;
    });
    try {
      String url = 'https://fitknees.herokuapp.com/auth/assign/';

      final response = await http.post(
        url,
        headers: {
          'Authorization': Provider.of<Auth>(context, listen: false).token,
        },
        body: _data,
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 201) {
        await showDialog(
          context: context,
          child: Platform.isIOS
              ? CupertinoAlertDialog(
                  title: Text('Success'),
                  content: Text('Patient is added.'),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      child: Text('Ok'),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                )
              : AlertDialog(
                  title: Text('Success'),
                  content: Text('Patient is added.'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Ok'),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                ),
        );
      } else {
        await showDialog(
          context: context,
          child: Platform.isIOS
              ? CupertinoAlertDialog(
                  title: Text('Error'),
                  content: Text('Patient is not added.'),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      child: Text('Ok'),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                )
              : AlertDialog(
                  title: Text('Success'),
                  content: Text('Patient is not added.'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Ok'),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                ),
        );
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      _fnameController.clear();
      _lnameController.clear();
      _emailController.clear();
      _medController.clear();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Text(
                  'New Patient',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _fnameController,
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
                    _data['fname'] = val;
                    _data['doctor'] =
                        Provider.of<Auth>(context, listen: false).id;
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _lnameController,
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
                  onSaved: (val) {
                    _data['lname'] = val;
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email Id',
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
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val == '') {
                      return 'This Field is required.';
                    }
                    if (!RegExp(
                            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                        .hasMatch(val)) {
                      return 'The email is invalid.';
                    }
                  },
                  onSaved: (val) {
                    _data['email'] = val.toLowerCase();
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _medController,
                  decoration: InputDecoration(
                    labelText: 'Medical Condition',
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
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val == '') {
                      return 'This Field is required.';
                    }
                  },
                  onSaved: (val) {
                    _data['medical'] = val;
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
    );
  }
}
