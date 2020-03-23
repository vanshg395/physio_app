import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddPatientScreen extends StatefulWidget {
  @override
  _AddPatientScreenState createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  bool visisblePassword = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
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
            TextFormField(
              // controller: _emailController,
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
              },
              // onSaved: (val) {
              //   _authData['email'] = val;
              // },
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              // controller: _passController,
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
                labelText: 'Password',
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
              obscureText: !visisblePassword,
              validator: (val) {
                if (val == '') {
                  return 'This Field is required.';
                }
              },
              // onSaved: (val) {
              //   _authData['password'] = val;
              // },
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
    );
  }
}
