// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';

// import '../providers/auth.dart';

// class ChangePasswordScreen extends StatefulWidget {
//   @override
//   _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
// }

// class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
//   List<TextEditingController> _passControllers = [
//     TextEditingController(),
//     TextEditingController(),
//     TextEditingController(),
//   ];
//   final GlobalKey<FormState> _formKey = GlobalKey();
//   List<bool> visiblePassword = [false, false, false];
//   Map<String, String> _data = {
//     'current_password': '',
//     'new_password': '',
//   };
//   bool _isLoading = false;

//   Future<void> _submit() async {
//     if (!_formKey.currentState.validate()) {
//       return;
//     }
//     _formKey.currentState.save();
//     setState(() {
//       _isLoading = true;
//     });
//     try {
//       String url = 'https://fitknees.herokuapp.com/auth/users/set_password/';
//       final response = await http.post(
//         url,
//         headers: {'Authorization': Provider.of<Auth>(context).token},
//         body: _data,
//       );
//       print(response.body);
//     } catch (e) {}
//     _isLoading = false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Change Password'),
//       ),
//       body: Container(
//         padding: EdgeInsets.symmetric(horizontal: 20),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: <Widget>[
//               SizedBox(
//                 height: 50,
//               ),
//               TextFormField(
//                 controller: _passControllers[0],
//                 decoration: InputDecoration(
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       visiblePassword[0]
//                           ? FontAwesomeIcons.eye
//                           : FontAwesomeIcons.eyeSlash,
//                       color: Colors.grey,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         visiblePassword[0] = !visiblePassword[0];
//                       });
//                     },
//                   ),
//                   labelText: 'Current Password',
//                   labelStyle: TextStyle(color: Colors.grey),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.blue),
//                   ),
//                   errorBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.blue),
//                   ),
//                   focusedErrorBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.blue),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.grey),
//                   ),
//                 ),
//                 keyboardType: TextInputType.emailAddress,
//                 keyboardAppearance: Brightness.light,
//                 obscureText: !visiblePassword[0],
//                 validator: (val) {
//                   if (val == '') {
//                     return 'This Field is required.';
//                   }
//                 },
//                 onSaved: (val) {
//                   print('val' + val);
//                   _data['current_password'] = val;
//                 },
//               ),
//               SizedBox(
//                 height: 30,
//               ),
//               TextFormField(
//                 controller: _passControllers[1],
//                 decoration: InputDecoration(
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       visiblePassword[1]
//                           ? FontAwesomeIcons.eye
//                           : FontAwesomeIcons.eyeSlash,
//                       color: Colors.grey,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         visiblePassword[1] = !visiblePassword[1];
//                       });
//                     },
//                   ),
//                   labelText: 'New Password',
//                   labelStyle: TextStyle(color: Colors.grey),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.blue),
//                   ),
//                   errorBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.blue),
//                   ),
//                   focusedErrorBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.blue),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.grey),
//                   ),
//                 ),
//                 keyboardType: TextInputType.emailAddress,
//                 keyboardAppearance: Brightness.light,
//                 obscureText: !visiblePassword[1],
//                 validator: (val) {
//                   if (val == '') {
//                     return 'This Field is required.';
//                   }
//                 },
//                 onSaved: (val) {
//                   _data['new_password'] = val;
//                 },
//               ),
//               SizedBox(
//                 height: 30,
//               ),
//               TextFormField(
//                 controller: _passControllers[2],
//                 decoration: InputDecoration(
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       visiblePassword[1]
//                           ? FontAwesomeIcons.eye
//                           : FontAwesomeIcons.eyeSlash,
//                       color: Colors.grey,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         visiblePassword[2] = !visiblePassword[2];
//                       });
//                     },
//                   ),
//                   labelText: 'Confirm New Password',
//                   labelStyle: TextStyle(color: Colors.grey),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.blue),
//                   ),
//                   errorBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.blue),
//                   ),
//                   focusedErrorBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.blue),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.grey),
//                   ),
//                 ),
//                 keyboardType: TextInputType.emailAddress,
//                 keyboardAppearance: Brightness.light,
//                 obscureText: !visiblePassword[2],
//                 validator: (val) {
//                   if (val == '') {
//                     return 'This Field is required.';
//                   }
//                   if (val != _passControllers[1].text) {
//                     return 'Passwords do not match';
//                   }
//                 },
//                 onSaved: (val) {
//                   _data['new_password'] = val;
//                 },
//               ),
//               SizedBox(
//                 height: 50,
//               ),
//               Center(
//                 child: Container(
//                   width: MediaQuery.of(context).size.width * 0.6,
//                   height: 40,
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(50),
//                     child: _isLoading
//                         ? Center(
//                             child: CircularProgressIndicator(
//                               valueColor: AlwaysStoppedAnimation(
//                                 Colors.grey,
//                               ),
//                             ),
//                           )
//                         : RaisedButton(
//                             color: Colors.grey[350],
//                             textColor: Colors.black,
//                             child: Text(
//                               'Submit',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontFamily: 'SFProTextSemiMed',
//                               ),
//                             ),
//                             onPressed: _submit,
//                             // onPressed: () => _submit,
//                           ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import 'dart:io';
// import 'tabsScreen.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController _passController = TextEditingController();
  TextEditingController _pass1Controller = TextEditingController();
  TextEditingController _pass2Controller = TextEditingController();

  bool visisblePassword = false;
  bool _isLoading = false;

  Map<String, String> _authData = {
    'password': '',
    'password1': '',
    'password2': '',
  };

  final GlobalKey<FormState> _formKey = GlobalKey();

  String errorMessage = '';

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    print('Checkpoint 1');

    final password = _authData['password'];
    final password1 = _authData['password1'];
    final password2 = _authData['password2'];
    print(password);
    setState(() {
      _isLoading = true;
    });
    try {
      print(_authData);
      await Provider.of<Auth>(context, listen: false)
          .changePass(password, password1, password2);
      Navigator.of(context).pop();
    } catch (error) {
      errorMessage = error.toString();
      print(errorMessage);
      setState(() {
        _passController.text = '';
        _pass1Controller.text = '';
        _pass2Controller.text = '';
      });
      showDialog(
        context: context,
        builder: (context) => Platform.isIOS
            ? CupertinoAlertDialog(
                title: Text('Authentication Error'),
                content: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                      'Password could not changed. Please choose another password.'),
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              )
            : AlertDialog(
                backgroundColor: Colors.grey,
                title: Text('Authentication Error'),
                content: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                      'Password could not changed. Please choose another password.'),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF030D18),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Text(
                    'CHANGE PASSWORD',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _passController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        visisblePassword
                            ? FontAwesomeIcons.eye
                            : FontAwesomeIcons.eyeSlash,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          visisblePassword = !visisblePassword;
                        });
                      },
                    ),
                    labelText: 'Current Password',
                    labelStyle: TextStyle(color: Colors.white),
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
                  keyboardType: TextInputType.visiblePassword,
                  keyboardAppearance: Brightness.light,
                  obscureText: !visisblePassword,
                  onChanged: (value) => _authData['password'] = value,
                  validator: (value) {
                    if (value == null) {
                      return 'This field is required';
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _pass1Controller,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        visisblePassword
                            ? FontAwesomeIcons.eye
                            : FontAwesomeIcons.eyeSlash,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          visisblePassword = !visisblePassword;
                        });
                      },
                    ),
                    labelText: 'New Password',
                    labelStyle: TextStyle(color: Colors.white),
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
                  keyboardType: TextInputType.visiblePassword,
                  keyboardAppearance: Brightness.light,
                  obscureText: !visisblePassword,
                  onChanged: (value) => _authData['password1'] = value,
                  validator: (value) {
                    if (value == null) {
                      return 'This field is required';
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _pass2Controller,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        visisblePassword
                            ? FontAwesomeIcons.eye
                            : FontAwesomeIcons.eyeSlash,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          visisblePassword = !visisblePassword;
                        });
                      },
                    ),
                    labelText: 'Confirm New Password',
                    labelStyle: TextStyle(color: Colors.white),
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
                  keyboardType: TextInputType.visiblePassword,
                  keyboardAppearance: Brightness.light,
                  obscureText: !visisblePassword,
                  onChanged: (value) => _authData['password2'] = value,
                  validator: (value) {
                    if (value == null) {
                      return 'This field is required';
                    }
                    if (value != _pass1Controller.text) {
                      return 'Passwords do not match.';
                    }
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 40,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: _isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(
                                Colors.blue,
                              ),
                            ),
                          )
                        : RaisedButton(
                            color: Color(0xff3284ff),
                            textColor: Colors.white,
                            child: Text(
                              'CHANGE PASSWORD',
                              style: TextStyle(
                                fontSize: 14,
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
