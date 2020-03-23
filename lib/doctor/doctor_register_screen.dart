import 'package:flutter/material.dart';

class DoctorRegisterScreen extends StatefulWidget {
  @override
  _DoctorRegisterScreenState createState() => _DoctorRegisterScreenState();
}

class _DoctorRegisterScreenState extends State<DoctorRegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

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
                    'Registration Form',
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
      
                ]
                )
            )
            )
            )
            )
            );
  }
}